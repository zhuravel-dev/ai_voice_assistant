import 'dart:async';
import 'package:ai_voice_assistant/domain/signaling/signaling_repository.dart';

class FakeSignalingRepositoryImpl implements SignalingRepository {
  final _controller = StreamController<Map<String, dynamic>>.broadcast();

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
    await Future.delayed(const Duration(milliseconds: 500));

    String sdp = offer['sdp'] as String;

    sdp = sdp.replaceAll('a=setup:actpass', 'a=setup:passive');

    final fakeAnswer = {
      'type': 'answer',
      'sdp': sdp,
    };

    print('[FAKE SIGNALING] emit answer');
    _controller.add(fakeAnswer);

    _emitRemoteIceCandidates();
  }

  void _handleIceCandidate(Map<String, dynamic> candidate) {
    print('[FAKE SIGNALING] got local ice: ${candidate['candidate']}');
  }

  void _emitRemoteIceCandidates() async {
    for (int i = 0; i < 3; i++) {
      await Future.delayed(const Duration(milliseconds: 300));

      final ice = {
        'type': 'ice-candidate',
        'candidate': {
          'candidate': 'fake-candidate-$i',
          'sdpMid': '0',
          'sdpMLineIndex': 0,
        }
      };

      print('[FAKE SIGNALING] emit remote ice');
      _controller.add(ice);
    }
  }

  @override
  void dispose() {
    _controller.close();
  }
}
