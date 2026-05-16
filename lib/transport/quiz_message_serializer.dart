import 'package:genui/genui.dart';

/// Turns a GenUI [ChatMessage] (text + optional UI interaction payloads) into a
/// single user prompt string for Gemini.
String serializeUserChatMessage(ChatMessage message) {
  final buffer = StringBuffer();
  if (message.text.trim().isNotEmpty) {
    buffer.writeln(message.text.trim());
  }
  for (final part in message.parts) {
    if (part is DataPart &&
        part.mimeType == UiPartConstants.interactionMimeType) {
      buffer.writeln('[genui_ui_interaction]');
      buffer.writeln(UiInteractionPart.fromDataPart(part).interaction);
    }
  }
  return buffer.toString().trim();
}
