import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:genui/genui.dart';

import 'package:intro_to_genui/transport/a2ui_version_inject.dart';
import 'package:intro_to_genui/transport/quiz_message_serializer.dart';

/// [Transport] that streams A2UI by feeding Gemini output into
/// [A2uiTransportAdapter] (same pipeline GenUI expects).
class GeminiA2uiTransport implements Transport {
  GeminiA2uiTransport({
    required String apiKey,
    required String systemPrompt,
    String model = const String.fromEnvironment(
      'GEMINI_MODEL',
      defaultValue: 'gemini-2.0-flash',
    ),
  }) : _model = GenerativeModel(
         model: model,
         apiKey: apiKey,
         systemInstruction: Content.system(systemPrompt),
       ) {
    _chat = _model.startChat();
    _adapter = A2uiTransportAdapter();
  }

  final GenerativeModel _model;
  late final ChatSession _chat;
  late final A2uiTransportAdapter _adapter;

  @override
  Stream<String> get incomingText => _adapter.incomingText;

  @override
  Stream<A2uiMessage> get incomingMessages => _adapter.incomingMessages;

  @override
  Future<void> sendRequest(ChatMessage message) async {
    final prompt = serializeUserChatMessage(message);
    if (prompt.isEmpty) {
      return;
    }
    final response = await _chat.sendMessage(Content.text(prompt));
    try {
      final text = response.text;
      if (text != null && text.trim().isNotEmpty) {
        _adapter.addChunk(ensureA2uiVersionOnJsonObjects(text));
      }
    } on GenerativeAIException {
      _adapter.addChunk(
        'The model response was blocked or filtered. Ask the user to tap '
        'Continue to try again, or rephrase.',
      );
    }
  }

  @override
  void dispose() {
    _adapter.dispose();
  }
}
