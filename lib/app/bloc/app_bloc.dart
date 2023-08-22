import 'dart:async';
import 'dart:developer';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_storage_repository/local_storage_repository.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc({
    required AuthenticationRepository authenticationRepository,
    required LocalStorageRepository localStorageRepository,
  })  : _authenticationRepository = authenticationRepository,
        _localStorageRepository = localStorageRepository,
        super(
          authenticationRepository.currentUser.isNotEmpty
              ? localStorageRepository
                      .isAppLockEnabled(authenticationRepository.currentUser.id)
                  ? AppState.locked(authenticationRepository.currentUser)
                  : AppState.authenticated(authenticationRepository.currentUser)
              : const AppState.unauthenticated(),
        ) {
    on<_AppUserChanged>(_onUserChanged);
    on<AppLogoutRequested>(_onLogoutRequested);
    on<AppUnlockRequested>(_onUnlockRequested);

    _userSubscription = _authenticationRepository.user.listen(
      (user) => add(_AppUserChanged(user)),
    );
  }
  final AuthenticationRepository _authenticationRepository;
  final LocalStorageRepository _localStorageRepository;
  final LocalAuthentication _localAuthentication = LocalAuthentication();
  late final StreamSubscription<User> _userSubscription;

  void _onUserChanged(_AppUserChanged event, Emitter<AppState> emit) async {
    final state = event.user.isNotEmpty
        ? _localStorageRepository.isAppLockEnabled(event.user.id)
            ? AppState.locked(_authenticationRepository.currentUser)
            : AppState.authenticated(_authenticationRepository.currentUser)
        : AppState.unauthenticated();
    emit(state);
  }

  void _onLogoutRequested(AppLogoutRequested event, Emitter<AppState> emit) {
    unawaited(_authenticationRepository.logOut());
  }

  void _onUnlockRequested(
      AppUnlockRequested event, Emitter<AppState> emit) async {
    try {
      final List<BiometricType> availableBiometrics =
          await _localAuthentication.getAvailableBiometrics();

      if (availableBiometrics.isEmpty) {
        emit(AppState.authenticated(_authenticationRepository.currentUser));
        return;
      }

      final bool didAuthenticate = await _localAuthentication.authenticate(
        localizedReason: 'Authenticate to open relay',
        options: const AuthenticationOptions(
          biometricOnly: true,
        ),
      );
      if (didAuthenticate) {
        emit(AppState.authenticated(_authenticationRepository.currentUser));
      }
    } on PlatformException catch (e) {
      log(e.toString());
    }
  }

  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }
}
