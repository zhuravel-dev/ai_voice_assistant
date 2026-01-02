import 'package:ai_voice_assistant/domain/webrtc/webrtc_repository.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class WebRTCRepositoryImpl implements WebRTCRepository {
  RTCPeerConnection? _peerConnection;
  MediaStream? _localStream;

  @override
  Future<void> init() async {
    _localStream = await navigator.mediaDevices.getUserMedia({
      'audio': true,
      'video': false,
    });

    _peerConnection = await createPeerConnection({
      'sdpSemantics': 'unified-plan',
      'iceServers': [
        {'urls': 'stun:stun.l.google.com:19302'},
      ],
    });

    for (final track in _localStream!.getTracks()) {
      await _peerConnection!.addTrack(track, _localStream!);
    }
  }

  void setOnIceCandidate(Function(RTCIceCandidate) onCandidate) {
    _peerConnection?.onIceCandidate = onCandidate;
  }

  @override
  Future<RTCSessionDescription> createOffer() async {
    final offer = await _peerConnection!.createOffer();
    await _peerConnection!.setLocalDescription(offer);
    return offer;
  }

  @override
  Future<void> setRemoteDescription(RTCSessionDescription description) async {
    await _peerConnection!.setRemoteDescription(description);
  }

  @override
  Future<void> addIceCandidate(RTCIceCandidate candidate) async {
    await _peerConnection!.addCandidate(candidate);
  }

  @override
  void dispose() {
    _localStream?.getTracks().forEach((t) => t.stop());
    _localStream?.dispose();
    _peerConnection?.close();
  }
}
