import 'dart:async';
import 'package:ai_voice_assistant/domain/signaling/signaling_repository.dart';
import 'package:ai_voice_assistant/domain/webrtc/webrtc_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'voice_call_event.dart';
import 'voice_call_state.dart';

class VoiceCallBloc extends Bloc<VoiceCallEvent, VoiceCallState> {
  final SignalingRepository signalingRepository;
  final WebRTCRepository webRTCRepository;

  StreamSubscription? _signalingSubscription;

  VoiceCallBloc({required this.signalingRepository, required this.webRTCRepository})
    : super(const VoiceCallInitial()) {
    on<StartVoiceCall>(_onStartCall);
    on<SignalingMessageReceived>(_onSignalingMessage);

    _signalingSubscription = signalingRepository.messages.listen((message) {
      add(SignalingMessageReceived(message));
    });
  }

  Future<void> _onStartCall(StartVoiceCall event, Emitter<VoiceCallState> emit) async {
    try {
      emit(VoiceCallConnecting(messages: state.messages));

      await webRTCRepository.init();

      (webRTCRepository as dynamic).setOnIceCandidate((RTCIceCandidate candidate) {
        signalingRepository.sendMessage({
          'type': 'ice-candidate',
          'candidate': {
            'candidate': candidate.candidate,
            'sdpMid': candidate.sdpMid,
            'sdpMLineIndex': candidate.sdpMLineIndex,
          },
        });
      });

      final offer = await webRTCRepository.createOffer();

      signalingRepository.sendMessage({'type': 'offer', 'sdp': offer.sdp});
      emit(VoiceCallConnected(messages: state.messages));
    } catch (e) {
      emit(VoiceCallError(e.toString(), messages: state.messages));
    }
  }

  Future<void> _onSignalingMessage(
    SignalingMessageReceived event,
    Emitter<VoiceCallState> emit,
  ) async {
    final msg = event.message;

    switch (msg['type']) {
      case 'answer':
        await webRTCRepository.setRemoteDescription(RTCSessionDescription(msg['sdp'], 'answer'));
        emit(VoiceCallConnected(messages: state.messages));
        break;

      case 'ice-candidate':
        await webRTCRepository.addIceCandidate(
          RTCIceCandidate(
            msg['candidate']['candidate'],
            msg['candidate']['sdpMid'],
            msg['candidate']['sdpMLineIndex'],
          ),
        );
        break;

      case 'chat':
        final newMessages = List<String>.from(state.messages)..add(msg['text']);
        emit(VoiceCallConnected(messages: newMessages));
        break;
    }
  }

  @override
  Future<void> close() {
    _signalingSubscription?.cancel();
    signalingRepository.dispose();
    webRTCRepository.dispose();
    return super.close();
  }
}
