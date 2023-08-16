part of 'profile_bloc.dart';

sealed class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

final class ProfileStatusRequested extends ProfileEvent {
  const ProfileStatusRequested(this.user);

  final User user;
}

final class _AppUserChanged extends ProfileEvent {
  const _AppUserChanged(this.user);

  final User user;
}