abstract class TextChatState {
  final List<String> textMessages;
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
