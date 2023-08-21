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