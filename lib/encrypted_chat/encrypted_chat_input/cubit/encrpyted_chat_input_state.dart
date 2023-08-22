part of 'encrypted_chat_input_cubit.dart';

enum EncryptedChatInputStatus {
  initial,
  writing,
  failure,
}

final class EncryptedChatInputState extends Equatable {
  const EncryptedChatInputState._({
    required this.status,
    required this.text,
    this.file,
  });

  final EncryptedChatInputStatus status;
  final String text;
  final File? file;

  const EncryptedChatInputState.initial()
      : this._(
          status: EncryptedChatInputStatus.initial,
          text: '',
        );
  const EncryptedChatInputState.writing(String text)
      : this._(
          status: EncryptedChatInputStatus.writing,
          text: text,
        );
  const EncryptedChatInputState.failure(String errorMessage)
      : this._(
          status: EncryptedChatInputStatus.failure,
          text: ''
        );

  @override
  List<Object?> get props => [status, text];
}
