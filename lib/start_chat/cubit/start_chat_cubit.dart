import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:messaging_repository/messaging_repository.dart';

part 'start_chat_state.dart';

class StartChatCubit extends Cubit<StartChatState> {
  StartChatCubit({
    required MessagingRepository messagingRepository,
  })  :
        _messagingRepository = messagingRepository,
        super(StartChatState.initial());

  final MessagingRepository _messagingRepository;

  void onStartChatRequested(String userId) async {
    emit(StartChatState.loading());
    try {
      final roomExists = await _messagingRepository.roomExists(userId);
      if (roomExists) {
        final room = await _messagingRepository.getRoom(userId);
        emit(StartChatState.success(room));
        return;
      }
      await _messagingRepository.makeRoom(userId);
      final room = await _messagingRepository.getRoom(userId);
      emit(StartChatState.success(room));
    } on RoomExistsFailure catch (e) {
      emit(StartChatState.failure(e.message));
    } on MakeRoomFailure catch (e) {
      emit(StartChatState.failure(e.message));
    } on GetRoomFailure catch (e) {
      emit(StartChatState.failure(e.message));
    } catch (e) {
      emit(StartChatState.failure(e.toString()));
    }
  }
}
