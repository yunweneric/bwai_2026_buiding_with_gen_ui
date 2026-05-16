import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intro_to_genui/quiz/quiz_bank.dart';
import 'package:intro_to_genui/quiz/quiz_models.dart';
import 'package:intro_to_genui/quiz/temperament_scoring.dart';
import 'package:intro_to_genui/ui/floating_background.dart';
import 'package:intro_to_genui/ui/game_theme.dart';
import 'package:intro_to_genui/ui/question_inputs.dart';
import 'package:intro_to_genui/ui/responsive.dart';
import 'package:intro_to_genui/ui/result_screen.dart';
import 'package:intro_to_genui/ui/stagger_entry.dart';

class QuizFlowScreen extends StatefulWidget {
  const QuizFlowScreen({super.key});

  @override
  State<QuizFlowScreen> createState() => _QuizFlowScreenState();
}

class _QuizFlowScreenState extends State<QuizFlowScreen> {
  late final List<QuizQuestion> _questions;
  late final PageController _pageController;
  final Map<int, Object?> _answers = {};
  int _page = 0;

  @override
  void initState() {
    super.initState();
    _questions = loadQuizQuestions();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  bool get _canGoBack => _page > 0;

  bool get _answeredCurrent {
    final q = _questions[_page];
    final v = _answers[q.index];
    if (v == null) return false;
    if (q.kind == QuestionInputKind.toggleRoutineSpontaneity) {
      return v is bool;
    }
    return true;
  }

  bool get _isLast => _page == _questions.length - 1;

  void _goNext() {
    if (!_answeredCurrent) return;
    if (_isLast) {
      final scores = computeScores(_questions, _answers);
      final breakdown = scores.toBreakdown();
      Navigator.of(context).pushReplacement(
        PageRouteBuilder<void>(
          transitionDuration: const Duration(milliseconds: 480),
          pageBuilder: (context, animation, _) => ResultScreen(breakdown: breakdown),
          transitionsBuilder: (context, animation, _, child) {
            final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
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
      return;
    }
    _pageController.nextPage(
      duration: const Duration(milliseconds: 420),
      curve: Curves.easeOutCubic,
    );
  }

  void _goBack() {
    if (!_canGoBack) return;
    _pageController.previousPage(
      duration: const Duration(milliseconds: 420),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
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
          child: LayoutBuilder(
            builder: (context, c) {
              final wide = c.maxWidth >= Breakpoints.md;
              return CenteredContent(
                maxWidth: 1000,
                padding: EdgeInsets.symmetric(
                  horizontal: wide ? 40 : 20,
                ),
                child: Column(
                  children: [
                    _ProgressHeader(
                      current: _page + 1,
                      total: _questions.length,
                    ),
                    Expanded(
                      child: PageView.builder(
                        controller: _pageController,
                        physics: const BouncingScrollPhysics(),
                        itemCount: _questions.length,
                        onPageChanged: (i) => setState(() => _page = i),
                        itemBuilder: (context, i) {
                          final q = _questions[i];
                          return _ParallaxPage(
                            pageController: _pageController,
                            index: i,
                            child: SingleChildScrollView(
                              key: ValueKey('page-${q.index}'),
                              padding: EdgeInsets.symmetric(
                                vertical: wide ? 32 : 16,
                                horizontal: 4,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  StaggerEntry(
                                    child: _QuestionCard(question: q),
                                  ),
                                  SizedBox(height: wide ? 24 : 16),
                                  QuestionInputView(
                                    key: ValueKey('input-${q.index}'),
                                    question: q,
                                    value: _answers[q.index],
                                    onChanged: (v) =>
                                        setState(() => _answers[q.index] = v),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    _NavBar(
                      canGoBack: _canGoBack,
                      canGoNext: _answeredCurrent,
                      isLast: _isLast,
                      onBack: _goBack,
                      onNext: _goNext,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _ProgressHeader extends StatelessWidget {
  const _ProgressHeader({required this.current, required this.total});

  final int current;
  final int total;

  @override
  Widget build(BuildContext context) {
    final progress = current / total;
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
              TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0, end: progress),
                duration: const Duration(milliseconds: 420),
                curve: Curves.easeOutCubic,
                builder: (context, v, _) {
                  return Text(
                    '${(v * 100).round()}%',
                    style: GameTheme.heading(size: 15, color: GameColors.primary),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: progress),
              duration: const Duration(milliseconds: 420),
              curve: Curves.easeOutCubic,
              builder: (context, v, _) {
                return LinearProgressIndicator(
                  value: v,
                  minHeight: 6,
                  backgroundColor: GameColors.border,
                  valueColor: const AlwaysStoppedAnimation<Color>(GameColors.primary),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _QuestionCard extends StatelessWidget {
  const _QuestionCard({required this.question});

  final QuizQuestion question;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: GameTheme.cleanCard(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: GameColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              'Question ${question.index}',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: GameColors.primary,
                letterSpacing: 0.6,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            question.prompt,
            style: GameTheme.display(size: 26),
          ),
          if (question.subtitle != null) ...[
            const SizedBox(height: 8),
            Text(
              question.subtitle!,
              style: GameTheme.body(size: 14),
            ),
          ],
        ],
      ),
    );
  }
}

class _NavBar extends StatelessWidget {
  const _NavBar({
    required this.canGoBack,
    required this.canGoNext,
    required this.isLast,
    required this.onBack,
    required this.onNext,
  });

  final bool canGoBack;
  final bool canGoNext;
  final bool isLast;
  final VoidCallback onBack;
  final VoidCallback onNext;

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
              onPressed: canGoNext ? onNext : null,
              icon: Icon(
                isLast ? Icons.check_rounded : Icons.arrow_forward_rounded,
                size: 18,
              ),
              label: Text(isLast ? 'See my results' : 'Continue'),
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

/// Applies subtle scale + fade based on this page's offset from the viewport.
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
