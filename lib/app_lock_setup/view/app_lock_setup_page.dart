import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_storage_repository/local_storage_repository.dart';
import 'package:relay/app_lock_setup/app_lock_setup.dart';

class AppLockSetupPage extends StatelessWidget {
  const AppLockSetupPage({super.key});

  static Page<void> page() =>
      const MaterialPage<void>(child: AppLockSetupView());

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AppLockSetupCubit>(
      create: (context) => AppLockSetupCubit(
        localStorageRepository: context.read<LocalStorageRepository>(),
      )
      ..getBiometricAuthStatus(),
      child: AppLockSetupView(),
    );
  }
}
