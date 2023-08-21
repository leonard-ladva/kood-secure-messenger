import 'dart:developer';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:messaging_repository/messaging_repository.dart';

part 'chat_input_state.dart';

class ChatInputCubit extends Cubit<ChatInputState> {
  ChatInputCubit({
    required AuthenticationRepository authenticationRepository,
    required MessagingRepository messagingRepository,
    required ChatRoom room,
  })  : _authenticationRepository = authenticationRepository,
        _messagingRepository = messagingRepository,
        _room = room,
        super(ChatInputState.initial());

  final AuthenticationRepository _authenticationRepository;
  final MessagingRepository _messagingRepository;
  final ChatRoom _room;

  Future<void> textChanged(String text) async {
    emit(ChatInputState.writing(text));
    try {
      await _messagingRepository.setTypingStatus(_room.id, text.isNotEmpty);
    } catch (e) {
      log(e.toString());
    }
  }

  void sendMessage() async {
    final currentUser = _authenticationRepository.currentUser;
    final message = ChatMessage(
      from: currentUser.id,
      createdAt: DateTime.now(),
      text: state.text,
    );

    try {
      await _messagingRepository.sendMessage(
        _room.id,
        message,
      );
      textChanged('');
      emit(ChatInputState.initial());
    } on SendMessageFailure catch (e) {
      emit(ChatInputState.failure(e.message));
    } catch (_) {
      emit(ChatInputState.failure('An unknown error occured'));
    }
  }

  @override
  Future<void> close() async {
    textChanged('');
    return super.close();
  }
}
