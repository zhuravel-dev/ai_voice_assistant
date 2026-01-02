import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:ai_voice_assistant/presentation/bloc/call_bloc.dart';
import 'package:ai_voice_assistant/domain/signaling/signaling_repository.dart';
import 'package:ai_voice_assistant/domain/webrtc/webrtc_repository.dart';

abstract class ProvidersInitializer {
  static Future<List<BlocProvider>> initialize() async {
    final signalingRepo = GetIt.I<SignalingRepository>();
    final webRTCRepo = GetIt.I<WebRTCRepository>();

    final callBloc = CallBloc(
      signalingRepository: signalingRepo,
      webRTCRepository: webRTCRepo,
    );

    GetIt.I.registerSingleton<CallBloc>(callBloc);

    return [BlocProvider<CallBloc>(create: (BuildContext context) => callBloc)];
  }
}
