import 'dart:developer';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:database_repository/database_repository.dart';
import 'package:equatable/equatable.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc(
      {required AuthenticationRepository authenticationRepository,
      required DatabaseRepository databaseRepository})
      : _authenticationRepository = authenticationRepository,
        _databaseRepository = databaseRepository,
        super(const ProfileState.uncompleted())
  // super(
  //   authenticationRepository.currentUser.isNotEmpty
  //       ? ProfileState.authenticated(authenticationRepository.currentUser)
  //       : const AppState.unauthenticated(),
  // ) {
  {
    on<ProfileStatusRequested>(_onProfileStatusRequested);
    // on<AppLogoutRequested>(_onLogoutRequested);
    // _userSubscription = _authenticationRepository.user.listen(
    //   (user) => add(_AppUserChanged(user)),
    // );
  }

  final AuthenticationRepository _authenticationRepository;
  final DatabaseRepository _databaseRepository;
  // late final StreamSubscription<User> _userSubscription;

  void _onProfileStatusRequested(
      ProfileStatusRequested event, Emitter<ProfileState> emit) async {
    try {
      log("go");
      final user = await _databaseRepository.getUser(event.user.id);
      log("fine here");
      emit(
        user.isNotEmpty
            ? ProfileState.completed(user)
            : const ProfileState.uncompleted(),
      );
    } on GetUserProfileFailure catch (e) {
      emit(ProfileState.failure(
        e.message,
      ));
    }
  }
}
