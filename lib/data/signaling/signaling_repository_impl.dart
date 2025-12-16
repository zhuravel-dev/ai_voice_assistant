import 'dart:convert';
import 'package:ai_voice_assistant/domain/signaling/signaling_repository.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class SignalingRepositoryImpl implements SignalingRepository {
  final WebSocketChannel _channel;

  SignalingRepositoryImpl(String url)
    : _channel = WebSocketChannel.connect(Uri.parse(url));

  @override
  void sendMessage(Map<String, dynamic> message) {
    _channel.sink.add(jsonEncode(message));
  }

  @override
  Stream<Map<String, dynamic>> get messages =>
      _channel.stream.map((event) => jsonDecode(event));

  @override
  void dispose() {
    _channel.sink.close();
  }
}
