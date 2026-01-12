import 'package:ai_voice_assistant/domain/entities/author_of_messages.dart';
import 'package:ai_voice_assistant/domain/entities/text_message.dart';
import 'package:ai_voice_assistant/presentation/blocs/text_chat/text_chat_bloc.dart';
import 'package:ai_voice_assistant/presentation/blocs/text_chat/text_chat_event.dart';
import 'package:ai_voice_assistant/presentation/blocs/voice_call/voice_call_bloc.dart';
import 'package:ai_voice_assistant/presentation/blocs/voice_call/voice_call_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BottomInputBar extends StatefulWidget {
  const BottomInputBar({super.key});

  @override
  State<BottomInputBar> createState() => _BottomInputBarState();
}

class _BottomInputBarState extends State<BottomInputBar> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      color: Colors.black,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              style: const TextStyle(color: Colors.white),
              onSubmitted: (_) => _sendTextMessageToChat(),
              decoration: InputDecoration(
                hintText: 'Type a message...',
                hintStyle: const TextStyle(color: Colors.white54),
                filled: true,
                fillColor: Colors.grey[900],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          const SizedBox(width: 8),

          IconButton(
            icon: const Icon(Icons.send, color: Colors.white),
            onPressed: _sendTextMessageToChat,
          ),

          IconButton(
            icon: const Icon(Icons.mic, color: Colors.white),
            onPressed: _startVoiceCall,
          ),
        ],
      ),
    );
  }

  void _sendTextMessageToChat() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    final message = TextMessage(text: text, author: AuthorOfMessage.user);

    context.read<TextChatBloc>().add(SendTextMessage(message));
    _controller.clear();
  }

  void _startVoiceCall() {
    context.read<VoiceCallBloc>().add(StartVoiceCall());
  }
}
