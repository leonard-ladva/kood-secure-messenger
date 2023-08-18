part of 'chat_list_bloc.dart';

sealed class ChatListEvent extends Equatable {
  const ChatListEvent();

  @override
  List<Object?> get props => [];
}

final class ChatListRequested extends ChatListEvent {
  const ChatListRequested();
}

final class _RoomListUpdated extends ChatListEvent {
  const _RoomListUpdated(this.chats);

  final List<ChatRoom> chats;

  @override
  List<Object?> get props => [chats];
}