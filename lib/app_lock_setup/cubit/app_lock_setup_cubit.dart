import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_storage_repository/local_storage_repository.dart';

part 'app_lock_setup_state.dart';

class AppLockSetupCubit extends Cubit<AppLockSetupState> {
  AppLockSetupCubit({
    required LocalStorageRepository localStorageRepository,
  })  : _localStorageRepository = localStorageRepository,
        super(AppLockSetupState());

  final LocalAuthentication _localAuthentication = LocalAuthentication();
  final LocalStorageRepository _localStorageRepository;

  void getBiometricAuthStatus() async {
    final bool canAuthenticateWithBiometrics =
        await _localAuthentication.canCheckBiometrics;
    if (!canAuthenticateWithBiometrics) {
      emit(state.copyWith(status: AppLockSetupStatus.noBiometricsSupport));
      return;
    }

    final List<BiometricType> availableBiometrics =
        await _localAuthentication.getAvailableBiometrics();

    if (availableBiometrics.isEmpty) {
      emit(state.copyWith(status: AppLockSetupStatus.biometricsNotSetup));
    }
    emit(state.copyWith(status: AppLockSetupStatus.success));
  }

  void setAppLockStatus(String userId, bool status) {
    _localStorageRepository.setAppLockEnabledStatus(userId, status);
  }
}
