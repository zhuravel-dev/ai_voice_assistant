import 'package:get_it/get_it.dart';
import 'package:ai_voice_assistant/data/signaling/signaling_repository_impl.dart';
import 'package:ai_voice_assistant/domain/signaling/signaling_repository.dart';
import 'package:ai_voice_assistant/data/webrtc/webrtc_repository_impl.dart';
import 'package:ai_voice_assistant/domain/webrtc/webrtc_repository.dart';

abstract class RepositoriesInitializer {
  static void initialize() {
    // Signaling, future URL my WebSocket server
    GetIt.I.registerSingleton<SignalingRepository>(
      SignalingRepositoryImpl('wss://exemple-signaling-server.com'),
    );

    // WebRTC
    GetIt.I.registerSingleton<WebRTCRepository>(
      WebRTCRepositoryImpl(),
    );
  }
}
