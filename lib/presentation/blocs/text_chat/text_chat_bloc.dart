import 'dart:async';
import 'package:ai_voice_assistant/domain/entities/author_of_messages.dart';
import 'package:ai_voice_assistant/domain/entities/text_message.dart';
import 'package:ai_voice_assistant/domain/repositories/signaling/signaling_repository.dart';
import 'package:ai_voice_assistant/domain/usecases/get_fake_reply_useCase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'text_chat_event.dart';
import 'text_chat_state.dart';

class TextChatBloc extends Bloc<TextChatEvent, TextChatState> {
  final SignalingRepository signalingRepository;
  final GetFakeReplyUseCase getFakeReplyUseCase;
  StreamSubscription? _signalingSubscription;

  TextChatBloc({
    required this.signalingRepository,
    required this.getFakeReplyUseCase,
  }) : super(const TextChatInitial()) {
    on<SendTextMessage>(_onSendMessage);
    on<ChatMessageReceived>(_onIncomingMessage);

    _signalingSubscription = signalingRepository.messages.listen((message) {
      if (message['type'] == 'chat') {
        add(ChatMessageReceived(
          TextMessage(
            text: message['text'],
            author: AuthorOfMessage.donoAssistant,
          ),
        ));
      }
    });
  }

  Future<void> _onSendMessage(
      SendTextMessage event,
      Emitter<TextChatState> emit,
      ) async {
    final newMessages = List<TextMessage>.from(state.textMessages)
      ..add(event.textMessage);

    emit(TextChatConnected(textMessages: newMessages));

    signalingRepository.sendMessage({
      'type': 'chat',
      'text': event.textMessage.text,
    });

    final replyMessage = await getFakeReplyUseCase(event.textMessage.text);

    add(ChatMessageReceived(replyMessage));
  }

  Future<void> _onIncomingMessage(
      ChatMessageReceived event,
      Emitter<TextChatState> emit,
      ) async {
    final newMessages = List<TextMessage>.from(state.textMessages)
      ..add(event.textMessage);

    emit(TextChatConnected(textMessages: newMessages));
  }

  @override
  Future<void> close() {
    _signalingSubscription?.cancel();
    signalingRepository.dispose();
    return super.close();
  }
}
