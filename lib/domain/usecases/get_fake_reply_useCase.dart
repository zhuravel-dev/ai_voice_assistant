import 'package:ai_voice_assistant/domain/entities/author_of_messages.dart';
import 'package:ai_voice_assistant/domain/entities/text_message.dart';
import 'package:ai_voice_assistant/domain/services/assistant_text_reply_service.dart';

class GetFakeReplyUseCase {
  final AssistantTextReplyService service;
  GetFakeReplyUseCase(this.service);

  Future<TextMessage> call(String text) async {
    final replyText = await service.getReply(text);
    return TextMessage(text: replyText, author: AuthorOfMessage.donoAssistant);
  }
}
