part of 'start_chat_cubit.dart';

enum StartChatStatus {
  initial,
  loading,
  success,
  failure,
}

final class StartChatState extends Equatable {
  const StartChatState._({
    required this.status,
    this.errorMessage,
    this.room,
  });

  final StartChatStatus status;
  final String? errorMessage;
  final ChatRoom? room;

  const StartChatState.initial() : this._(status: StartChatStatus.initial);
  const StartChatState.loading() : this._(status: StartChatStatus.loading);
  const StartChatState.success(ChatRoom room)
      : this._(
          status: StartChatStatus.success,
          room: room,
        );
  const StartChatState.failure(String errorMessage)
      : this._(
          status: StartChatStatus.failure,
          errorMessage: errorMessage,
        );

  @override
  List<Object?> get props => [status, errorMessage];
}
