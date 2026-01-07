import 'dart:async';
import 'package:ai_voice_assistant/domain/signaling/signaling_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'text_chat_event.dart';
import 'text_chat_state.dart';

class TextChatBloc extends Bloc<TextChatEvent, TextChatState> {
  final SignalingRepository signalingRepository;
  StreamSubscription? _signalingSubscription;

  TextChatBloc({required this.signalingRepository}) : super(const TextChatInitial()) {
    on<SendTextMessage>(_onSendMessage);
    on<ChatMessageReceived>(_onIncomingMessage);

    _signalingSubscription = signalingRepository.messages.listen((message) {
      if (message['type'] == 'chat') {
        add(ChatMessageReceived(message));
      }
    });
  }

  Future<void> _onSendMessage(SendTextMessage event, Emitter<TextChatState> emit) async {
    final newMessages = List<String>.from(state.textMessages)..add(event.textMessage);

    signalingRepository.sendMessage({'type': 'chat', 'text': event.textMessage});

    emit(TextChatConnected(textMessages: newMessages));
  }

  Future<void> _onIncomingMessage(ChatMessageReceived event, Emitter<TextChatState> emit) async {
    final text = event.textMessage['text'];

    final newMessages = List<String>.from(state.textMessages)..add(text);
    emit(TextChatConnected(textMessages: newMessages));
  }

  @override
  Future<void> close() {
    _signalingSubscription?.cancel();
    signalingRepository.dispose();
    return super.close();
  }
}
