abstract class TextChatEvent {}

class SendTextMessage extends TextChatEvent {
  final String textMessage;
  SendTextMessage(this.textMessage);
}

class ChatMessageReceived extends TextChatEvent {
  final Map<String, dynamic> textMessage;
  ChatMessageReceived(this.textMessage);
}
