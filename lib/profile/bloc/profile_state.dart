part of 'profile_bloc.dart';

enum ProfileStatus {
  completed,
  failure,
}

final class ProfileState extends Equatable {
  const ProfileState._({
    required this.status,
    this.user = User.empty,
    this.errorMessage,
  });

  const ProfileState.failure(String errorMessage)
      : this._(
          status: ProfileStatus.failure,
          errorMessage: errorMessage,
        );

  const ProfileState.completed(User user)
      : this._(status: ProfileStatus.completed, user: user);

  final ProfileStatus status;
  final User user;
  final String? errorMessage;

  @override
  List<Object?> get props => [status, user, errorMessage];
}
