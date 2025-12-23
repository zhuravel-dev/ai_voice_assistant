import 'dart:async';
import 'package:ai_voice_assistant/domain/signaling/signaling_repository.dart';
import 'package:ai_voice_assistant/domain/webrtc/webrtc_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'call_event.dart';
import 'call_state.dart';

class CallBloc extends Bloc<CallEvent, CallState> {
  final SignalingRepository signalingRepository;
  final WebRTCRepository webRTCRepository;

  StreamSubscription? _signalingSubscription;

  CallBloc({required this.signalingRepository, required this.webRTCRepository})
    : super(CallInitial()) {
    on<StartCall>(_onStartCall);
    on<SignalingMessageReceived>(_onSignalingMessage);

    _signalingSubscription = signalingRepository.messages.listen((message) {
      add(SignalingMessageReceived(message));
    });
  }

  Future<void> _onStartCall(StartCall event, Emitter<CallState> emit) async {
    try {
      emit(CallConnecting());

      await webRTCRepository.init();

      if (webRTCRepository is dynamic) {
        (webRTCRepository as dynamic).setOnIceCandidate((
          RTCIceCandidate candidate,
        ) {
          signalingRepository.sendMessage({
            'type': 'ice-candidate',
            'candidate': {
              'candidate': candidate.candidate,
              'sdpMid': candidate.sdpMid,
              'sdpMLineIndex': candidate.sdpMLineIndex,
            },
          });
        });
      }

      final offer = await webRTCRepository.createOffer();

      signalingRepository.sendMessage({'type': 'offer', 'sdp': offer.sdp});
    } catch (e) {
      emit(CallError(e.toString()));
    }
  }

  Future<void> _onSignalingMessage(
    SignalingMessageReceived event,
    Emitter<CallState> emit,
  ) async {
    final msg = event.message;

    switch (msg['type']) {
      case 'answer':
        await webRTCRepository.setRemoteDescription(
          RTCSessionDescription(msg['sdp'], 'answer'),
        );
        emit(CallConnected());
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
