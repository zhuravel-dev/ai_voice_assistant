import 'package:ai_voice_assistant/domain/repositories/speech/speech_repository.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechRepositoryImpl implements SpeechRepository {
  final SpeechToText _speech = SpeechToText();

  @override
  Future<void> init() async {
    await _speech.initialize();
  }

  @override
  void startListening(Function(String) onResult) {
    _speech.listen(onResult: (result) {
      onResult(result.recognizedWords);
    });
  }

  @override
  void stopListening() {
    _speech.stop();
  }
}