abstract class SignalingRepository {
  void sendMessage(Map<String, dynamic> message);
  Stream<Map<String, dynamic>> get messages;
  void dispose();
}
