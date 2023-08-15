part of 'app_lock_setup_cubit.dart';

enum AppLockSetupStatus {
  initial,
  noBiometricsSupport,
  biometricsNotSetup,
  success,
}

class AppLockSetupState extends Equatable {
  const AppLockSetupState({
    this.status = AppLockSetupStatus.initial,
  });

  final AppLockSetupStatus status;

  @override
  List<Object> get props => [status];

  AppLockSetupState copyWith({
    AppLockSetupStatus? status,
  }) {
    return AppLockSetupState(
      status: status ?? this.status,
    );
  }
}
