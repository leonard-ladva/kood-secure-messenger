part of 'encrypted_chat_messages_bloc.dart';

enum EncryptedChatMessagesStatus {
  initial,
  success,
  failure,
}

final class EncryptedChatMessagesState extends Equatable {
  const EncryptedChatMessagesState._({
    required this.status,
    required this.messages,
    this.errorMessage,
  });

  final EncryptedChatMessagesStatus status;
  final List<EncryptedMessage> messages;
  final String? errorMessage;

  EncryptedChatMessagesState.initial()
      : this._(
          status: EncryptedChatMessagesStatus.initial,
          messages: [],
        );
  const EncryptedChatMessagesState.success(List<EncryptedMessage> messages)
      : this._(
          status: EncryptedChatMessagesStatus.success,
          messages: messages,
        );
  EncryptedChatMessagesState.failure(String errorMessage)
      : this._(
          status: EncryptedChatMessagesStatus.failure,
          errorMessage: errorMessage,
          messages: [],
        );

  EncryptedChatMessagesState copyWith({
    EncryptedChatMessagesStatus? status,
    List<EncryptedMessage>? messages,
    String? errorMessage,
  }) {
    return EncryptedChatMessagesState._(
      status: status ?? this.status,
      messages: messages ?? this.messages,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, messages, errorMessage];
}
