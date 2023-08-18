import 'dart:async';

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

  @override
  Future<void> close() {
    _roomsSubscription;
    return super.close();
  }
}
