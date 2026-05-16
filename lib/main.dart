import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart' as gemini;
import 'package:genui/genui.dart' as genui;
import 'package:genui/genui.dart' hide TextPart;
import 'package:intro_to_genui/theme/app_theme.dart';
import 'package:intro_to_genui/widgets/message_bubble.dart';

const _geminiApiKey = String.fromEnvironment('GEMINI_API_KEY');
const _geminiModelRaw = String.fromEnvironment(
  'GEMINI_MODEL',
  defaultValue: 'gemini-2.0-flash',
);

String get _geminiModel =>
    _geminiModelRaw.startsWith('models/') ? _geminiModelRaw : 'models/$_geminiModelRaw';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (_geminiApiKey.isEmpty) {
    throw StateError(
      'GEMINI_API_KEY is not set. Copy env.json.example to env.json and run with:\n'
      'flutter run -d chrome --dart-define-from-file=env.json',
    );
  }

  gemini.Gemini.init(apiKey: _geminiApiKey);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Just Today',
      theme: AppTheme.light(),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

sealed class ConversationItem {}

class TextItem extends ConversationItem {
  final String text;
  final bool isUser;
  TextItem({required this.text, this.isUser = false});
}

class SurfaceItem extends ConversationItem {
  final String surfaceId;
  SurfaceItem({required this.surfaceId});
}

class _MyHomePageState extends State<MyHomePage> {
  final List<ConversationItem> _items = [];
  final List<gemini.Content> _chatHistory = [];
  final _textController = TextEditingController();
  final _scrollController = ScrollController();

  late final String _systemPrompt;
  late final SurfaceController _controller;
  late final A2uiTransportAdapter _transport;
  late final Conversation _conversation;
  late final Catalog catalog;

  Future<void> _sendAndReceive(ChatMessage msg) async {
    if (msg.role == ChatMessageRole.system) {
      return;
    }

    final text = _extractMessageText(msg);
    if (text.isEmpty) {
      return;
    }

    try {
      _chatHistory.add(
        gemini.Content(parts: [gemini.Part.text(text)], role: 'user'),
      );
      final response = await gemini.Gemini.instance.chat(
        _chatHistory,
        systemPrompt: _systemPrompt,
        modelName: _geminiModel,
      );
      final output = response?.output;
      if (output == null || output.isEmpty) {
        return;
      }
      _chatHistory.add(
        gemini.Content(parts: [gemini.Part.text(output)], role: 'model'),
      );
      _transport.addChunk(output);
    } catch (error, stackTrace) {
      debugPrint('Gemini error: $error\n$stackTrace');
      rethrow;
    }
  }

  String _extractMessageText(ChatMessage msg) {
    final buffer = StringBuffer();

    for (final part in msg.parts) {
      if (part.isUiInteractionPart) {
        buffer.write(part.asUiInteractionPart!.interaction);
      } else if (part is genui.TextPart) {
        buffer.write(part.text);
      }
    }

    if (buffer.isEmpty) {
      buffer.write(msg.text);
    }

    return buffer.toString().trim();
  }

  @override
  void initState() {
    super.initState();

    catalog = BasicCatalogItems.asCatalog();
    _controller = SurfaceController(catalogs: [catalog]);
    _transport = A2uiTransportAdapter(onSend: _sendAndReceive);
    _conversation = Conversation(controller: _controller, transport: _transport);

    _conversation.events.listen((event) {
      setState(() {
        switch (event) {
          case ConversationSurfaceAdded added:
            _items.add(SurfaceItem(surfaceId: added.surfaceId));
            _scrollToBottom();
          case ConversationSurfaceRemoved removed:
            _items.removeWhere(
              (item) =>
                  item is SurfaceItem && item.surfaceId == removed.surfaceId,
            );
          case ConversationContentReceived content:
            _items.add(TextItem(text: content.text, isUser: false));
            _scrollToBottom();
          case ConversationError error:
            debugPrint('GenUI Error: ${error.error}');
          default:
            break;
        }
      });
    });

    final promptBuilder = PromptBuilder.chat(
      catalog: catalog,
      systemPromptFragments: [systemInstruction],
    );
    _systemPrompt = promptBuilder.systemPromptJoined();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _conversation.sendRequest(ChatMessage.user('Start our session.'));
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    _conversation.dispose();
    super.dispose();
  }

  Future<void> _addMessage() async {
    final text = _textController.text.trim();
    if (text.isEmpty) {
      return;
    }

    _textController.clear();

    setState(() {
      _items.add(TextItem(text: text, isUser: true));
    });

    _scrollToBottom();

    await _conversation.sendRequest(ChatMessage.user(text));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: const Text('Just Today'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              children: [
                for (final item in _items)
                  switch (item) {
                    TextItem() => MessageBubble(
                        text: item.text,
                        isUser: item.isUser,
                      ),
                    SurfaceItem() => Surface(
                        surfaceContext: _controller.contextFor(
                          item.surfaceId,
                        ),
                      ),
                  },
              ],
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      onSubmitted: (_) => _addMessage(),
                      decoration: const InputDecoration(
                        hintText: 'Enter a message',
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  FilledButton(
                    onPressed: _addMessage,
                    child: const Text('Send'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

const systemInstruction = '''
  ## PERSONA
  You are an expert task planner.

  ## GOAL
  Work with me to produce a list of tasks that I should do today, and then track
  the completion status of each one.

  ## RULES
  Talk with me only about tasks that I should do today.
  Do not engage in conversation about any other topic.
  Do not offer suggestions unless I ask for them.
  Do not offer encouragement unless I ask for it.
  Do not offer advice unless I ask for it.
  Do not offer opinions unless I ask for them.

  ## PROCESS
  ### Planning
  *   Ask me for information about tasks that I should do today.
  *   Synthesize a list of tasks from that information.
  *   Ask clarifying questions if you need to.
  *   When you have a list of tasks that you think I should do today, present it
    to me for review.
  *   Respond to my suggestions for changes, if I have any, until I accept the
    list.

  ### Tracking
  *   Once the list is accepted, ask me to let you know when individual tasks are
    complete.
  *   If I tell you a task is complete, mark it as complete.
  *   Once all tasks are complete, send a message acknowledging that, and then
    end the conversation.
''';
