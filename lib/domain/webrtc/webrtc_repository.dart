import 'package:flutter_webrtc/flutter_webrtc.dart';

abstract class WebRTCRepository {
  Future<void> init();
  Future<RTCSessionDescription> createOffer();
  Future<void> setRemoteDescription(RTCSessionDescription description);
  Future<void> addIceCandidate(RTCIceCandidate candidate);
  void dispose();
}
