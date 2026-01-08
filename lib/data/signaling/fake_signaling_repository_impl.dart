import 'dart:async';
import 'package:ai_voice_assistant/domain/repositories/signaling/signaling_repository.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class FakeSignalingRepositoryImpl implements SignalingRepository {
  final _controller = StreamController<Map<String, dynamic>>.broadcast();
  RTCPeerConnection? _remotePeer;
  MediaStream? _remoteStream;

  @override
  Stream<Map<String, dynamic>> get messages => _controller.stream;

  @override
  void sendMessage(Map<String, dynamic> message) {
    print('[FAKE SIGNALING] send: $message');

    switch (message['type']) {
      case 'offer':
        _handleOffer(message);
        break;

      case 'ice-candidate':
        _handleIceCandidate(message);
        break;
    }
  }

  void _handleOffer(Map<String, dynamic> offer) async {
    try {
      print('[FAKE SIGNALING] Creating remote peer connection');

      _remotePeer = await createPeerConnection({
        'iceServers': [
          {'urls': 'stun:stun.l.google.com:19302'},
        ],
      });

      _remoteStream = await navigator.mediaDevices.getUserMedia({
        'audio': {'echoCancellation': true, 'noiseSuppression': true},
        'video': false,
      });

      _remoteStream!.getAudioTracks().forEach((track) {
        _remotePeer!.addTrack(track, _remoteStream!);
        print('[FAKE SIGNALING] Added audio track to remote peer');
      });

      _remotePeer!.onIceCandidate = (candidate) {
        if (candidate.candidate != null) {
          print('[FAKE SIGNALING] remote peer ice candidate');
          _controller.add({
            'type': 'ice-candidate',
            'candidate': {
              'candidate': candidate.candidate,
              'sdpMid': candidate.sdpMid,
              'sdpMLineIndex': candidate.sdpMLineIndex,
            },
          });
        }
      };

      print('[FAKE SIGNALING] Setting remote description (offer)');
      await _remotePeer!.setRemoteDescription(
        RTCSessionDescription(offer['sdp'], offer['type']),
      );

      print('[FAKE SIGNALING] Creating answer');
      final answer = await _remotePeer!.createAnswer();
      await _remotePeer!.setLocalDescription(answer);

      await Future.delayed(const Duration(milliseconds: 500));

      print('[FAKE SIGNALING] emit answer');
      _controller.add({'type': answer.type, 'sdp': answer.sdp});

      print('[FAKE SIGNALING] Remote peer setup complete');
    } catch (e) {
      print('[FAKE SIGNALING] Error creating answer: $e');
    }
  }

  void _handleIceCandidate(Map<String, dynamic> message) async {
    print('[FAKE SIGNALING] got local ice: ${message['candidate']}');

    if (_remotePeer != null) {
      try {
        final candidateData = message['candidate'];
        await _remotePeer!.addCandidate(
          RTCIceCandidate(
            candidateData['candidate'],
            candidateData['sdpMid'],
            candidateData['sdpMLineIndex'],
          ),
        );
      } catch (e) {
        print('[FAKE SIGNALING] Error adding ice candidate: $e');
      }
    }
  }

  @override
  void dispose() {
    print('[FAKE SIGNALING] Disposing...');
    _remoteStream?.dispose();
    _remotePeer?.close();
    _controller.close();
  }
}
