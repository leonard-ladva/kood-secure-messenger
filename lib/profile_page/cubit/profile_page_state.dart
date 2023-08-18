part of 'profile_page_cubit.dart';

enum ProfilePageStatus {
  loading,
  success,
  failure,
}

final class ProfilePageState extends Equatable {
  const ProfilePageState._({
    required this.status,
    required this.user,
    this.errorMessage,
  });

  final ProfilePageStatus status;
  final User user;
  final String? errorMessage;

  const ProfilePageState.loading()
      : this._(
          status: ProfilePageStatus.loading,
          user: User.empty,
        );

  const ProfilePageState.success(User user)
      : this._(
          status: ProfilePageStatus.success,
          user: user,
        );

  const ProfilePageState.failure(String errorMessage)
      : this._(
          status: ProfilePageStatus.loading,
          user: User.empty,
          errorMessage: errorMessage,
        );

  @override
  List<Object?> get props => [user, status, errorMessage];
}
