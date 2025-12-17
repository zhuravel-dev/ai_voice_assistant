abstract class CallState {}

class CallInitial extends CallState {}

class CallConnecting extends CallState {}

class CallConnected extends CallState {}

class CallError extends CallState {
  final String message;

  CallError(this.message);
}
