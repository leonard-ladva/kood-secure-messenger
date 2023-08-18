part of 'chat_list_bloc.dart';

enum ChatListStatus {
  initial,
  chatAdded,
  chatsLoaded,
  failure,
}

final class ChatListState extends Equatable {
  const ChatListState._({
    required this.status,
    this.rooms,
  });

  const ChatListState.initial() : this._(status: ChatListStatus.initial);
  const ChatListState.chatAdded() : this._(status: ChatListStatus.chatAdded);
  const ChatListState.chatsLoaded(List<ChatRoom> rooms)
      : this._(
          status: ChatListStatus.chatsLoaded,
          rooms: rooms,
        );

  final ChatListStatus status;
  final List<ChatRoom>? rooms;

  @override
  List<Object> get props => [];
}
