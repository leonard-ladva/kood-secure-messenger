part of 'chat_messages_bloc.dart';

sealed class ChatMessagesEvent extends Equatable {
  const ChatMessagesEvent();

  @override
  List<Object> get props => [];
}

final class LoadNextMessagesRequested extends ChatMessagesEvent {
  const LoadNextMessagesRequested(this.room);
  final ChatRoom room;
}

final class _MessageReceived extends ChatMessagesEvent {
  const _MessageReceived(this.message);

  final ChatMessage message;

  @override
  List<Object> get props => [message];
}

final class MessageSeen extends ChatMessagesEvent {
  const MessageSeen(this.message);

  final ChatMessage message;

  @override
  List<Object> get props => [message];
}

final class StartListeningToMessageStream extends ChatMessagesEvent {
  const StartListeningToMessageStream(this.room);

  final ChatRoom room;

  @override
  List<Object> get props => [room];
}

final class _MessageListUpdated extends ChatMessagesEvent {
  const _MessageListUpdated(this.messages);

  final List<ChatMessage> messages;

  @override
  List<Object> get props => [messages];
}

final class DeleteMessage extends ChatMessagesEvent {
  const DeleteMessage(this.message);

  final ChatMessage message;

  @override
  List<Object> get props => [message];
}