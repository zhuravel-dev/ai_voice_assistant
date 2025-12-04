import 'package:ai_voice_assistant/domain/speech/speech_repository.dart';

class ListenToSpeech {
  final SpeechRepository repository;

  ListenToSpeech(this.repository);

  Future<void> call(Function(String) onResult) async {
    await repository.init();
    repository.startListening(onResult);
  }

  void stop() {
    repository.stopListening();
  }
}