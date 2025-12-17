abstract class CallEvent {}

class StartCall extends CallEvent {}

class SignalingMessageReceived extends CallEvent {
  final Map<String, dynamic> message;

  SignalingMessageReceived(this.message);
}
