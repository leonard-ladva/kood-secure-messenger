import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:messaging_repository/messaging_repository.dart';

part 'chat_list_event.dart';
part 'chat_list_state.dart';

class ChatListBloc extends Bloc<ChatListEvent, ChatListState> {
  ChatListBloc({
    required MessagingRepository messagingRepository,
  })  : _messagingRepository = messagingRepository,
        super(ChatListState.initial()) {
    on<MakeRoomRequested>(_onMakeRoomRequested);
    on<_RoomListUpdated>(_onRoomListUpdated);

    _roomsSubscription = messagingRepository.rooms.listen(
      (rooms) => add(_RoomListUpdated(rooms)),
    );
  }
  late final StreamSubscription<List<ChatRoom>> _roomsSubscription;
  final MessagingRepository _messagingRepository;

  void _onRoomListUpdated(
      _RoomListUpdated event, Emitter<ChatListState> emit) async {
    emit(ChatListState.chatsLoaded(event.chats));
  }

  void _onMakeRoomRequested(
      MakeRoomRequested event, Emitter<ChatListState> emit) async {
    final room = await _messagingRepository.makeRoom(event.otherUser.id);
    emit(ChatListState.chatAdded());
    emit(ChatListState.initial());
  }

  @override
  Future<void> close() {
    _roomsSubscription;
    return super.close();
  }
}
