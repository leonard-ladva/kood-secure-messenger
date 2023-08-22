import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:messaging_repository/messaging_repository.dart';

part 'chat_messages_event.dart';
part 'chat_messages_state.dart';

class ChatMessagesBloc extends Bloc<ChatMessagesEvent, ChatMessagesState> {
  ChatMessagesBloc({
    required MessagingRepository messagingRepository,
    required ChatRoom room,
  })  : _messagingRepository = messagingRepository,
        _room = room,
        super(ChatMessagesState.initial()) {
    on<LoadNextMessagesRequested>(_onLoadNextMessagesRequested);
    on<_MessageReceived>(_onMessageReceived);
    on<MessageSeen>(_onMessageSeen);
    on<_MessageListUpdated>(_onMessageListUpdated);
    on<DeleteMessage>(_onDeleteMessage);
    on<EditMessage>(_onEditMessage);

    _messagingRepository.chatMessagesStreamSetup(room.id);
    _messsageSubscription = _messagingRepository.messages.listen(
      (messages) => add(_MessageListUpdated(messages)),
    );
  }
  final ChatRoom _room;
  final MessagingRepository _messagingRepository;

  void _onLoadNextMessagesRequested(
    LoadNextMessagesRequested event,
    Emitter<ChatMessagesState> emit,
  ) async {
    final offset = state.messages.length;
    try {
      final messages = await _messagingRepository.getChatMessages(
        event.room.id,
        offset,
      );
      emit(ChatMessagesState.success(messages));
    } on GetChatMessagesFailure catch (e) {
      emit(ChatMessagesState.failure(e.message));
    } catch (_) {
      emit(ChatMessagesState.failure('An unknown error occured'));
    }
  }

  late final StreamSubscription<List<ChatMessage>> _messsageSubscription;

  void _onMessageListUpdated(
    _MessageListUpdated event,
    Emitter<ChatMessagesState> emit,
  ) async {
    emit(ChatMessagesState.success(event.messages));
  }

  void _onMessageReceived(
    _MessageReceived event,
    Emitter<ChatMessagesState> emit,
  ) async {}

  void _onMessageSeen(
    MessageSeen event,
    Emitter<ChatMessagesState> emit,
  ) async {
    try {
      await _messagingRepository.setMessageAsRead(
        _room.id,
        event.message.id ?? '',
      );
    } on SetMessageAsReadFailure catch (e) {
      emit(ChatMessagesState.failure(e.message));
    } catch (_) {
      emit(ChatMessagesState.failure('An unknown error occured'));
    }
  }

  void _onDeleteMessage(
    DeleteMessage event,
    Emitter<ChatMessagesState> emit,
  ) async {
    try {
      await _messagingRepository.deleteMessage(
        _room.id,
        event.message.id ?? '',
      );
    } on DeleteMessageFailure catch (e) {
      emit(ChatMessagesState.failure(e.message));
    } catch (_) {
      emit(ChatMessagesState.failure('An unknown error occured'));
    }
  }

  void _onEditMessage(
    EditMessage event,
    Emitter<ChatMessagesState> emit,
  ) async {
    final message = event.message.copyWith(text: event.newText);
    try {
      await _messagingRepository.updateMessage(
        _room.id,
        message,
      );
    } on DeleteMessageFailure catch (e) {
      emit(ChatMessagesState.failure(e.message));
    } catch (_) {
      emit(ChatMessagesState.failure('An unknown error occured'));
    }
  }

  @override
  Future<void> close() {
    _messsageSubscription.cancel();
    return super.close();
  }
}
