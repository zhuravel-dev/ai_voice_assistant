import 'package:ai_voice_assistant/domain/services/assistant_text_reply_service.dart';

class AssistantTextReplyServiceImpl implements AssistantTextReplyService {
  int _currentIndex = 0;

  final List<String> _replies = [
    'Gotcha, I hear you!',
    'Alrighty!',
    'Wanna hear something fun?',
    'Hold on, thinking…',
    'So, what’s the plan?',
    'Nice!',
  ];

  @override
  Future<String> getReply(String userMessage) async {
    await Future.delayed(const Duration(milliseconds: 800));

    final reply = _replies[_currentIndex];

    _currentIndex++;
    if (_currentIndex >= _replies.length) {
      _currentIndex = 0;
    }

    return reply;
  }
}
