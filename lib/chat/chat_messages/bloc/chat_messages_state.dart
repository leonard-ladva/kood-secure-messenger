part of 'chat_messages_bloc.dart';

enum ChatMessagesStatus {
  initial,
  success,
  failure,
}

final class ChatMessagesState extends Equatable {
  const ChatMessagesState._({
    required this.status,
    required this.messages,
    this.errorMessage,
  });

  final ChatMessagesStatus status;
  final List<ChatMessage> messages;
  final String? errorMessage;

  ChatMessagesState.initial()
      : this._(
          status: ChatMessagesStatus.initial,
          messages: [],
        );
  const ChatMessagesState.success(List<ChatMessage> messages)
      : this._(
          status: ChatMessagesStatus.success,
          messages: messages,
        );
  ChatMessagesState.failure(String errorMessage)
      : this._(
          status: ChatMessagesStatus.failure,
          errorMessage: errorMessage,
          messages: [],
        );

  ChatMessagesState copyWith({
    ChatMessagesStatus? status,
    List<ChatMessage>? messages,
    String? errorMessage,
  }) {
    return ChatMessagesState._(
      status: status ?? this.status,
      messages: messages ?? this.messages,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, messages, errorMessage];
}
