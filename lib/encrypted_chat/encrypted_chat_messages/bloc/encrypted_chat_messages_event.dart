part of 'encrypted_chat_messages_bloc.dart';

sealed class EncryptedChatMessagesEvent extends Equatable {
  const EncryptedChatMessagesEvent();

  @override
  List<Object> get props => [];
}

final class MessageSeen extends EncryptedChatMessagesEvent {
  const MessageSeen(this.message);

  final EncryptedMessage message;

  @override
  List<Object> get props => [message];
}

final class StartListeningToMessageStream extends EncryptedChatMessagesEvent {
  const StartListeningToMessageStream(this.room);

  final ChatRoom room;

  @override
  List<Object> get props => [room];
}

final class _MessageListUpdated extends EncryptedChatMessagesEvent {
  const _MessageListUpdated(this.messages);

  final List<EncryptedMessage> messages;

  @override
  List<Object> get props => [messages];
}