/// {@template get_user_profile_failure}
/// Thrown when attemptin to get the users profile.
/// {@endtemplate}
class MakeRoomFailure implements Exception {
  /// {@macro get_user_profile_failure}
  const MakeRoomFailure([
    this.message = 'An unknown exception occurred.',
  ]);

  /// The associated error message.
  final String message;
}

class GetRoomsFailure implements Exception {
  const GetRoomsFailure([
    this.message = 'An unknown exception occurred.',
  ]);

  /// The associated error message.
  final String message;
}

class RoomExistsFailure implements Exception {
  const RoomExistsFailure([
    this.message = 'An unknown exception occurred.',
  ]);

  /// The associated error message.
  final String message;
}