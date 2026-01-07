abstract class VoiceCallState {
  final List<String> messages;
  const VoiceCallState({required this.messages});
}

class VoiceCallInitial extends VoiceCallState {
  const VoiceCallInitial({super.messages = const []});
}

class VoiceCallConnecting extends VoiceCallState {
  const VoiceCallConnecting({required super.messages});
}

class VoiceCallConnected extends VoiceCallState {
  const VoiceCallConnected({required super.messages});
}

class VoiceCallError extends VoiceCallState {
  final String errorMessage;
  const VoiceCallError(this.errorMessage, {required super.messages});
}
