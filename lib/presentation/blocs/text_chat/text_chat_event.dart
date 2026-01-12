import 'package:ai_voice_assistant/domain/entities/text_message.dart';

abstract class TextChatEvent {}

class SendTextMessage extends TextChatEvent {
  final TextMessage textMessage;
  SendTextMessage(this.textMessage);
}

class ChatMessageReceived extends TextChatEvent {
  final TextMessage textMessage;
  ChatMessageReceived(this.textMessage);
}
