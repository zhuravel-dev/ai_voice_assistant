import 'package:ai_voice_assistant/data/signaling/fake_signaling_repository_impl.dart';
import 'package:ai_voice_assistant/data/webrtc/webrtc_repository_impl.dart';
import 'package:get_it/get_it.dart';
import 'package:ai_voice_assistant/data/signaling/signaling_repository_impl.dart';
import 'package:ai_voice_assistant/domain/signaling/signaling_repository.dart';
import 'package:ai_voice_assistant/domain/webrtc/webrtc_repository.dart';

abstract class RepositoriesInitializer {
  static void initialize({bool useFake = true}) {
    if (useFake) {
      GetIt.I.registerSingleton<SignalingRepository>(
        FakeSignalingRepositoryImpl(),
      );
    } else {
      GetIt.I.registerSingleton<SignalingRepository>(
        SignalingRepositoryImpl('wss://exemple-signaling-server.com'),
      );
    }

    GetIt.I.registerSingleton<WebRTCRepository>(WebRTCRepositoryImpl());
  }
}
