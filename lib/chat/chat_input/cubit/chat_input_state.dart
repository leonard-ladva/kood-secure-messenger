part of 'chat_input_cubit.dart';

enum ChatInputStatus {
  initial,
  writing,
  failure,
}

final class ChatInputState extends Equatable {
  const ChatInputState._({
    required this.status,
    required this.text,
  });

  final ChatInputStatus status;
  final String text;

  const ChatInputState.initial()
      : this._(
          status: ChatInputStatus.initial,
          text: '',
        );
  const ChatInputState.writing(String text)
      : this._(
          status: ChatInputStatus.writing,
          text: text,
        );
  const ChatInputState.failure(String errorMessage)
      : this._(
          status: ChatInputStatus.failure,
          text: ''
        );

  @override
  List<Object?> get props => [status, text];
}
