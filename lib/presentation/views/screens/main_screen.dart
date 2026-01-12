import 'package:ai_voice_assistant/presentation/blocs/text_chat/text_chat_bloc.dart';
import 'package:ai_voice_assistant/presentation/blocs/text_chat/text_chat_state.dart';
import 'package:ai_voice_assistant/presentation/views/components/bottom_input_bar.dart';
import 'package:ai_voice_assistant/presentation/views/components/center_empty_content.dart';
import 'package:ai_voice_assistant/presentation/views/components/icons_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            const IconsRow(),
            Expanded(
              child: BlocBuilder<TextChatBloc, TextChatState>(
                builder: (context, state) {
                  final textMessages = state.textMessages;
                  if (textMessages.isEmpty) return const CenterEmptyContent();
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    itemCount: textMessages.length,
                    itemBuilder: (context, index) {
                      final textMessage = textMessages[index];
                      final isUser = textMessage.isUserMessage;
                      return Align(
                        alignment: isUser
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: isUser
                                  ? Colors.blueAccent
                                  : Colors.amber[800],
                              borderRadius: BorderRadius.circular(16),
                            ),
                          child: Text(
                            textMessage.text,
                            style: const TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            const BottomInputBar(),
          ],
        ),
      ),
    );
  }
}
