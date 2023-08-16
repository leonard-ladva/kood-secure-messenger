import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:database_repository/database_repository.dart';
import 'package:equatable/equatable.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc({
    required DatabaseRepository databaseRepository,
    required AuthenticationRepository authenticationRepository,
  })  : _databaseRepository = databaseRepository,
        _authenticationRepository = authenticationRepository,
        super(const ProfileState.completed(User.empty)) {
    on<ProfileStatusRequested>(_onProfileStatusRequested);
    on<_AppUserChanged>(_onAppUserChanged);

    _userSubscription = _authenticationRepository.user.listen(
      (user) => add(_AppUserChanged(user)),
    );
  }
  late final StreamSubscription<User> _userSubscription;
  final DatabaseRepository _databaseRepository;
  final AuthenticationRepository _authenticationRepository;

  void _onAppUserChanged(
      _AppUserChanged event, Emitter<ProfileState> emit) async {
    add(ProfileStatusRequested(event.user.id));
  }

  void _onProfileStatusRequested(
      ProfileStatusRequested event, Emitter<ProfileState> emit) async {
    try {
      final user = await _databaseRepository.getUser(event.userId);
      emit(ProfileState.completed(user));
    } on GetUserProfileFailure catch (e) {
      emit(ProfileState.failure(
        e.message,
      ));
    }
  }

  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }
}
