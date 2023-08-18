import 'package:authentication_repository/authentication_repository.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:relay/app/app.dart';
import 'package:relay/app_lock_setup/cubit/app_lock_setup_cubit.dart';
import 'package:relay/onboarding_flow/onboarding_flow.dart';

class AppLockSetupView extends StatelessWidget {
  const AppLockSetupView({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppLockSetupCubit, AppLockSetupState>(
        builder: (context, state) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Align(
          alignment: Alignment(0, -0.5),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.fingerprint,
                size: 100,
              ),
              const SizedBox(
                height: 20,
                width: double.infinity,
              ),
              Text(
                'App Lock Setup',
                style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              switch (state.status) {
                // switch (AppLockSetupStatus.success) {
                AppLockSetupStatus.initial => _LoadingAppLock(),
                AppLockSetupStatus.noBiometricsSupport =>
                  _NoBiometricsSupport(),
                AppLockSetupStatus.biometricsNotSetup => _BiometricsNotSetup(),
                AppLockSetupStatus.success => _BiometricsSetupAndEnabled(),
              }
            ],
          ),
        ),
      );
    });
  }
}

class _LoadingAppLock extends StatelessWidget {
  const _LoadingAppLock();
  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator.adaptive();
  }
}

class _NoBiometricsSupport extends StatelessWidget {
  const _NoBiometricsSupport();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Your device does not support biometric authentication so you can\'t use this feature.',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(
          height: 16,
        ),
        _ContinueButton(false),
      ],
    );
  }
}

class _BiometricsNotSetup extends StatelessWidget {
  const _BiometricsNotSetup();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'You don\'t have biometrics set up on your device.',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 16,
        ),
        Text(
          'Please set it up in your device settings and come back to this screen if you wish to use this feature.',
          style: TextStyle(
            fontSize: 24,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 16,
        ),
        _ContinueButton(false),
      ],
    );
  }
}

class _BiometricsSetupAndEnabled extends StatelessWidget {
  const _BiometricsSetupAndEnabled();

  static const _textStyle = TextStyle(
    fontSize: 24,
  );
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Biometric authentication is set up and enabled.\n',
          style: _textStyle,
          textAlign: TextAlign.center,
        ),
        const SizedBox(
          height: 16,
        ),
        _ContinueButton(true),
      ],
    );
  }
}

class _ContinueButton extends StatelessWidget {
  _ContinueButton(this.authEnabled);
  final bool authEnabled;

  @override
  Widget build(BuildContext context) {
    final currentUser = context.read<AppBloc>().state.user;
    return ElevatedButton(
      onPressed: () {
        context.read<AppLockSetupCubit>().setAppLockStatus(currentUser.id, authEnabled);
        context.read<OnboardingFlowCubit>().setStatus(
              currentUser,
              OnboardingFlowStatus.completed,
            );
        context.flow<OnboardingFlowStatus>().complete(
              (_) => context.read<OnboardingFlowCubit>().state.status,
            );
      },
      child: Text('Continue'),
    );
  }
}
