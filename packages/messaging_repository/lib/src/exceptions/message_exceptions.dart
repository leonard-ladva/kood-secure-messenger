class GetChatMessagesFailure implements Exception {
  const GetChatMessagesFailure([
    this.message = 'An unknown exception occurred.',
  ]);

  /// The associated error message.
  final String message;
}

class SendMessageFailure implements Exception {
  const SendMessageFailure([
    this.message = 'An unknown exception occurred.',
  ]);

  /// The associated error message.
  final String message;
}

class SetTypingStatusFailure implements Exception {
  const SetTypingStatusFailure([
    this.message = 'An unknown exception occurred.',
  ]);

  /// The associated error message.
  final String message;
}

class DeleteMessageFailure implements Exception {
  const DeleteMessageFailure([
    this.message = 'An unknown exception occurred.',
  ]);

  /// The associated error message.
  final String message;
}

class UpdateMessageFailure implements Exception {
  const UpdateMessageFailure([
    this.message = 'An unknown exception occurred.',
  ]);

  /// The associated error message.
  final String message;
}