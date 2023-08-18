part of 'profile_bloc.dart';

sealed class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

final class ProfileStatusRequested extends ProfileEvent {
  const ProfileStatusRequested(this.userId);

  final String userId;
}

final class _AppUserChanged extends ProfileEvent {
  const _AppUserChanged(this.user);

  final User user;
}