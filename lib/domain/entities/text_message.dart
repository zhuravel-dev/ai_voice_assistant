import 'author_of_messages.dart';

class TextMessage {
  final String text;
  final AuthorOfMessage author;

  TextMessage({required this.text, required this.author});

  bool get isUserMessage => author == AuthorOfMessage.user;

  bool get isAssistantMessage => author == AuthorOfMessage.donoAssistant;
}
