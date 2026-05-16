import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:genui/genui.dart';
import 'package:intro_to_genui/catalog/temperament_styled_catalog.dart';
import 'package:intro_to_genui/genui/temperament_quiz_system_prompt.dart';
import 'package:intro_to_genui/quiz/temperament_scoring.dart';
import 'package:intro_to_genui/transport/gemini_a2ui_transport.dart';
import 'package:intro_to_genui/ui/floating_background.dart';
import 'package:intro_to_genui/ui/game_theme.dart';
import 'package:intro_to_genui/ui/responsive.dart';
import 'package:intro_to_genui/ui/result_screen.dart';
import 'package:intro_to_genui/ui/stagger_entry.dart';

const String _kGeminiApiKey = String.fromEnvironment('GEMINI_API_KEY');

/// Live GenUI quiz: questions come from the model via A2UI; optional [transport]
/// for tests (e.g. fake Gemini).
class QuizFlowScreen extends StatefulWidget {
  const QuizFlowScreen({super.key, this.transport});

  final Transport? transport;

  @override
  State<QuizFlowScreen> createState() => _QuizFlowScreenState();
}

class _QuizFlowScreenState extends State<QuizFlowScreen> {
  static final DataPath _answerPath = DataPath('/answer');

  SurfaceController? _controller;
  Conversation? _conversation;
  StreamSubscription<ConversationEvent>? _eventSub;
  late final PageController _pageController;
  Transport? _transport;

  var _textAccumulator = '';
  var _navigatedToResults = false;
  var _started = false;
  var _pageIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _bootstrapEngine();
  }

  void _bootstrapEngine() {
    final transport = widget.transport ??
        (_kGeminiApiKey.isNotEmpty
            ? GeminiA2uiTransport(
                apiKey: _kGeminiApiKey,
                systemPrompt: temperamentQuizSystemPrompt(),
              )
            : null);
    if (transport == null) {
      return;
    }
    _transport = transport;
    _controller = SurfaceController(catalogs: [temperamentQuestCatalog()]);
    _conversation = Conversation(
      controller: _controller!,
      transport: _transport!,
    );
    _eventSub = _conversation!.events.listen(_onConversationEvent);
    WidgetsBinding.instance.addPostFrameCallback((_) => _kickoff());
  }

  void _kickoff() {
    if (_started || _conversation == null) {
      return;
    }
    _started = true;
    unawaited(
      _conversation!.sendRequest(
        ChatMessage.user(kTemperamentQuizKickoffMessage),
      ),
    );
  }

  void _onConversationEvent(ConversationEvent event) {
    if (event is ConversationContentReceived) {
      _textAccumulator += event.text;
      _maybeFinishFromScores();
      return;
    }
    if (event is ConversationSurfaceAdded) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || !_pageController.hasClients || _conversation == null) {
          return;
        }
        final n = _conversation!.state.value.surfaces.length;
        if (n <= 0) {
          return;
        }
        final last = n - 1;
        _pageController.jumpToPage(last);
        setState(() => _pageIndex = last);
      });
    }
    if (event is ConversationError) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Something went wrong: ${event.error}')),
      );
    }
    if (mounted) {
      setState(() {});
    }
  }

  void _maybeFinishFromScores() {
    if (_navigatedToResults || !mounted) {
      return;
    }
    final breakdown = tryParseScoreLine(_textAccumulator);
    if (breakdown == null) {
      return;
    }
    _navigatedToResults = true;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder<void>(
        transitionDuration: const Duration(milliseconds: 480),
        pageBuilder: (context, animation, _) =>
            ResultScreen(breakdown: breakdown),
        transitionsBuilder: (context, animation, _, child) {
          final curved = CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
          );
          return FadeTransition(
            opacity: curved,
            child: ScaleTransition(
              scale: Tween<double>(begin: 0.97, end: 1).animate(curved),
              child: child,
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _eventSub?.cancel();
    _conversation?.dispose();
    _controller?.dispose();
    _transport?.dispose();
    _pageController.dispose();
    super.dispose();
  }

  bool get _hasEngine => _conversation != null && _controller != null;

  bool _hasAnswer(Object? value) => meaningfulQuizAnswer(value);

  Future<void> _submitAnswerToModel() async {
    if (!_hasEngine || _conversation!.state.value.isWaiting) {
      return;
    }
    final surfaces = _conversation!.state.value.surfaces;
    if (surfaces.isEmpty) {
      return;
    }
    final idx = _pageIndex.clamp(0, surfaces.length - 1);
    final surfaceId = surfaces[idx];
    final answer = _controller!.store
        .getDataModel(surfaceId)
        .getValue<Object>(_answerPath);
    if (!_hasAnswer(answer)) {
      return;
    }
    final payload = jsonEncode({'surfaceId': surfaceId, 'answer': answer});
    await _conversation!.sendRequest(
      ChatMessage.user(
        'The user answered on surface "$surfaceId". Payload: $payload\n'
        'Continue with the next A2UI question (new surfaceId) or finish with '
        'the SCORES line.',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_hasEngine) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: Text('Temperament Quest', style: GameTheme.heading(size: 17)),
          leading: IconButton(
            icon: const Icon(Icons.close_rounded, color: GameColors.textPrimary),
            onPressed: () => Navigator.of(context).maybePop(),
          ),
        ),
        body: FloatingBackground(
          child: SafeArea(
            child: CenteredContent(
              maxWidth: 560,
              padding: const EdgeInsets.all(24),
              child: Text(
                'Add a project-root env.json (see env.json.example) with '
                'GEMINI_API_KEY, then launch from VS Code/Cursor using '
                '“Temperament Quest (Chrome)” so env.json is passed in.\n\n'
                'Or from a terminal:\n'
                'flutter run --dart-define-from-file=env.json',
                style: GameTheme.body(size: 15),
              ),
            ),
          ),
        ),
      );
    }

    return ValueListenableBuilder<ConversationState>(
      valueListenable: _conversation!.state,
      builder: (context, conv, _) {
        final surfaces = conv.surfaces;
        final waiting = conv.isWaiting;
        final pageCount = surfaces.isEmpty ? 1 : surfaces.length;

        return Scaffold(
          backgroundColor: Colors.transparent,
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            title: Text('Temperament Quest', style: GameTheme.heading(size: 17)),
            leading: IconButton(
              icon: const Icon(Icons.close_rounded, color: GameColors.textPrimary),
              onPressed: waiting ? null : () => Navigator.of(context).maybePop(),
            ),
          ),
          body: FloatingBackground(
            child: SafeArea(
              child: LayoutBuilder(
                builder: (context, c) {
                  final wide = c.maxWidth >= Breakpoints.md;
                  return Stack(
                    children: [
                      CenteredContent(
                        maxWidth: 1000,
                        padding: EdgeInsets.symmetric(
                          horizontal: wide ? 40 : 20,
                        ),
                        child: Column(
                          children: [
                            _ProgressHeader(
                              current: surfaces.isEmpty ? 1 : _pageIndex + 1,
                              total: surfaces.isEmpty ? 1 : surfaces.length,
                              indeterminate: surfaces.isEmpty,
                            ),
                            Expanded(
                              child: PageView.builder(
                                controller: _pageController,
                                physics: const BouncingScrollPhysics(),
                                itemCount: pageCount,
                                onPageChanged: (i) =>
                                    setState(() => _pageIndex = i),
                                itemBuilder: (context, i) {
                                  if (surfaces.isEmpty) {
                                    return _ParallaxPage(
                                      pageController: _pageController,
                                      index: i,
                                      child: Center(
                                        child: StaggerEntry(
                                          child: Text(
                                            waiting
                                                ? 'Warming up the quiz…'
                                                : 'Waiting for the first question…',
                                            textAlign: TextAlign.center,
                                            style: GameTheme.body(size: 16),
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                  final id = surfaces[i];
                                  return _ParallaxPage(
                                    pageController: _pageController,
                                    index: i,
                                    child: SingleChildScrollView(
                                      key: ValueKey('surface-$id'),
                                      padding: EdgeInsets.symmetric(
                                        vertical: wide ? 32 : 16,
                                        horizontal: 4,
                                      ),
                                      child: StaggerEntry(
                                        child: Surface(
                                          surfaceContext:
                                              _controller!.contextFor(id),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            if (surfaces.isEmpty)
                              _NavBar(
                                canGoBack: false,
                                canSubmit: false,
                                onBack: () {},
                                onSubmit: () async {},
                              )
                            else
                              _AnswerAwareNavBar(
                                key: ValueKey(
                                  surfaces[_pageIndex.clamp(
                                    0,
                                    surfaces.length - 1,
                                  )],
                                ),
                                surfaceId: surfaces[_pageIndex.clamp(
                                  0,
                                  surfaces.length - 1,
                                )],
                                controller: _controller!,
                                waiting: waiting,
                                pageIndex: _pageIndex,
                                onBack: () {
                                  if (_pageIndex <= 0) {
                                    return;
                                  }
                                  _pageController.previousPage(
                                    duration: const Duration(milliseconds: 420),
                                    curve: Curves.easeOutCubic,
                                  );
                                },
                                onSubmit: _submitAnswerToModel,
                              ),
                          ],
                        ),
                      ),
                      if (waiting)
                        const ModalBarrier(
                          dismissible: false,
                          color: Color(0x66000000),
                        ),
                      if (waiting)
                        const Center(
                          child: CircularProgressIndicator(),
                        ),
                    ],
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

bool meaningfulQuizAnswer(Object? value) {
  if (value == null) {
    return false;
  }
  if (value is String) {
    return value.trim().isNotEmpty;
  }
  if (value is List) {
    return value.isNotEmpty;
  }
  if (value is bool) {
    return true;
  }
  if (value is num) {
    return true;
  }
  return true;
}

class _AnswerAwareNavBar extends StatefulWidget {
  const _AnswerAwareNavBar({
    super.key,
    required this.surfaceId,
    required this.controller,
    required this.waiting,
    required this.pageIndex,
    required this.onBack,
    required this.onSubmit,
  });

  final String surfaceId;
  final SurfaceController controller;
  final bool waiting;
  final int pageIndex;
  final VoidCallback onBack;
  final Future<void> Function() onSubmit;

  @override
  State<_AnswerAwareNavBar> createState() => _AnswerAwareNavBarState();
}

class _AnswerAwareNavBarState extends State<_AnswerAwareNavBar> {
  static final DataPath _answerPath = DataPath('/answer');
  ValueNotifier<Object?>? _answerNotifier;

  @override
  void initState() {
    super.initState();
    _attach();
  }

  @override
  void didUpdateWidget(covariant _AnswerAwareNavBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.surfaceId != widget.surfaceId) {
      _detach();
      _attach();
    }
  }

  void _attach() {
    _answerNotifier = widget.controller.store
        .getDataModel(widget.surfaceId)
        .subscribe<Object?>(_answerPath);
    _answerNotifier!.addListener(_onAnswer);
  }

  void _detach() {
    _answerNotifier?.removeListener(_onAnswer);
    _answerNotifier?.dispose();
    _answerNotifier = null;
  }

  void _onAnswer() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _detach();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final answer = _answerNotifier?.value;
    final canSubmit =
        meaningfulQuizAnswer(answer) && !widget.waiting;
    return _NavBar(
      canGoBack: widget.pageIndex > 0 && !widget.waiting,
      canSubmit: canSubmit,
      onBack: widget.onBack,
      onSubmit: widget.onSubmit,
    );
  }
}

class _ProgressHeader extends StatelessWidget {
  const _ProgressHeader({
    required this.current,
    required this.total,
    this.indeterminate = false,
  });

  final int current;
  final int total;
  final bool indeterminate;

  @override
  Widget build(BuildContext context) {
    final progress = indeterminate ? 0.0 : current / total;
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 16, 0, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Question $current of $total',
                style: GameTheme.body(size: 14, weight: FontWeight.w600),
              ),
              if (!indeterminate)
                TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0, end: progress),
                  duration: const Duration(milliseconds: 420),
                  curve: Curves.easeOutCubic,
                  builder: (context, v, _) {
                    return Text(
                      '${(v * 100).round()}%',
                      style: GameTheme.heading(
                        size: 15,
                        color: GameColors.primary,
                      ),
                    );
                  },
                ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: indeterminate
                ? const LinearProgressIndicator(minHeight: 6)
                : TweenAnimationBuilder<double>(
                    tween: Tween<double>(begin: 0, end: progress),
                    duration: const Duration(milliseconds: 420),
                    curve: Curves.easeOutCubic,
                    builder: (context, v, _) {
                      return LinearProgressIndicator(
                        value: v,
                        minHeight: 6,
                        backgroundColor: GameColors.border,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          GameColors.primary,
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _NavBar extends StatelessWidget {
  const _NavBar({
    required this.canGoBack,
    required this.canSubmit,
    required this.onBack,
    required this.onSubmit,
  });

  final bool canGoBack;
  final bool canSubmit;
  final VoidCallback onBack;
  final Future<void> Function() onSubmit;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 20),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: canGoBack ? onBack : null,
              icon: const Icon(Icons.arrow_back_rounded, size: 18),
              label: const Text('Back'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 18),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: FilledButton.icon(
              onPressed: canSubmit ? () => unawaited(onSubmit()) : null,
              icon: const Icon(Icons.arrow_forward_rounded, size: 18),
              label: const Text('Continue'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ParallaxPage extends StatelessWidget {
  const _ParallaxPage({
    required this.pageController,
    required this.index,
    required this.child,
  });

  final PageController pageController;
  final int index;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: pageController,
      child: child,
      builder: (context, child) {
        double page = index.toDouble();
        if (pageController.position.haveDimensions) {
          page = pageController.page ?? index.toDouble();
        }
        final delta = (index - page).clamp(-1.0, 1.0);
        final scale = 1 - (delta.abs() * 0.06);
        final opacity = 1 - (delta.abs() * 0.5);
        return Opacity(
          opacity: opacity.clamp(0.0, 1.0),
          child: Transform.translate(
            offset: Offset(delta * 40, 0),
            child: Transform.scale(scale: scale, child: child),
          ),
        );
      },
    );
  }
}
