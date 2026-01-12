import 'package:ai_voice_assistant/domain/repositories/signaling/signaling_repository.dart';
import 'package:ai_voice_assistant/domain/repositories/webrtc/webrtc_repository.dart';
import 'package:ai_voice_assistant/domain/services/assistant_text_reply_service.dart';
import 'package:ai_voice_assistant/domain/usecases/get_fake_reply_useCase.dart';
import 'package:ai_voice_assistant/presentation/blocs/text_chat/text_chat_bloc.dart';
import 'package:ai_voice_assistant/presentation/blocs/voice_call/voice_call_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

abstract class ProvidersInitializer {
  static Future<List<BlocProvider>> initialize() async {
    final signalingRepository = GetIt.I<SignalingRepository>();
    final webRTCRepository = GetIt.I<WebRTCRepository>();
    final assistantReplyService = GetIt.I<AssistantTextReplyService>();
    final getFakeReplyUseCase = GetFakeReplyUseCase(assistantReplyService);


    final voiceCallBloc = VoiceCallBloc(
      signalingRepository: signalingRepository,
      webRTCRepository: webRTCRepository,
    );
    GetIt.I.registerSingleton<VoiceCallBloc>(voiceCallBloc);

    final textChatBloc = TextChatBloc(
      signalingRepository: signalingRepository,
      getFakeReplyUseCase: getFakeReplyUseCase,
      //assistantTextReplyService: assistantReplyService,
    );
    GetIt.I.registerSingleton<TextChatBloc>(textChatBloc);

    return [
      BlocProvider<VoiceCallBloc>(
        create: (BuildContext context) => voiceCallBloc,
      ),
      BlocProvider<TextChatBloc>(
        create: (BuildContext context) => textChatBloc,
      ),
    ];
  }
}