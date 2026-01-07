abstract class VoiceCallEvent {}

class StartVoiceCall extends VoiceCallEvent {}

class SignalingMessageReceived extends VoiceCallEvent {
  final Map<String, dynamic> message;
  SignalingMessageReceived(this.message);
}
