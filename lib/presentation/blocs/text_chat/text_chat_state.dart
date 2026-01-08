import 'package:ai_voice_assistant/domain/entities/text_message.dart';

abstract class TextChatState {
  final List<TextMessage> textMessages;
  const TextChatState({this.textMessages = const []});
}

class TextChatInitial extends TextChatState {
  const TextChatInitial() : super(textMessages: const []);
}

class TextChatConnected extends TextChatState {
  const TextChatConnected({required super.textMessages});
}

class TextChatError extends TextChatState {
  final String error;
  const TextChatError(this.error, {required super.textMessages});
}
