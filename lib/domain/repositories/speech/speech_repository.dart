abstract class SpeechRepository {
  Future<void> init();
  void startListening(Function(String) onResult);
  void stopListening();
}
