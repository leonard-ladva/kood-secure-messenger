import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:messaging_repository/messaging_repository.dart';

part 'start_chat_state.dart';

class StartChatCubit extends Cubit<StartChatState> {
  StartChatCubit({
    required MessagingRepository messagingRepository,
  })  : _messagingRepository = messagingRepository,
        super(StartChatState.initial());

  final MessagingRepository _messagingRepository;

  void onStartChatRequested(String userId) async {
    emit(StartChatState.loading());
    try {
      log("start");
      final roomExists = await _messagingRepository.roomExists(userId);
      log("room exists: $roomExists");
      if (roomExists) {
        emit(StartChatState.success());
      }

      log("room exists: $roomExists");
      await _messagingRepository.makeRoom(userId);
      emit(StartChatState.success());
    } on RoomExistsFailure catch (e) {
      log("error: ${e.message}");
      emit(StartChatState.failure(e.message));
    } on MakeRoomFailure catch (e) {
      log("error: ${e.message}");
      emit(StartChatState.failure(e.message));
    } catch (e) {
      log("error: ${e.toString()}");
      emit(StartChatState.failure(e.toString()));
    }
  }
}
