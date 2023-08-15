import 'package:authentication_repository/authentication_repository.dart';
import 'package:database_repository/database_repository.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:relay/app/app.dart';
import 'package:relay/app_lock_setup/view/app_lock_setup_page.dart';
import 'package:relay/onboarding_flow/cubit/onboarding_flow_cubit.dart';
import 'package:relay/onboarding_flow/view/onboarding_flow_page.dart';
import 'package:relay/profile_setup/profile_setup.dart';

class OnboardingFlow extends StatelessWidget {
  const OnboardingFlow({super.key});

  static Route<OnboardingFlowStatus> route() {
    return MaterialPageRoute(builder: (_) => const OnboardingFlow());
  }

  @override
  Widget build(BuildContext context) {
    final user = context.select((AppBloc bloc) => bloc.state.user);
    return BlocProvider(
      create: (context) => OnboardingFlowCubit(
        databaseRepository: context.read<DatabaseRepository>(),
      )..getStatus(user.id),
      child: const OnboardingFlowView(),
    );
  }
}

class OnboardingFlowView extends StatelessWidget {
  const OnboardingFlowView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlowBuilder<OnboardingFlowStatus>(
        state:
            context.select((OnboardingFlowCubit cubit) => cubit.state.status),
        onGeneratePages: (profile, pages) {
          return [
            switch (profile) {
              OnboardingFlowStatus.profileSetup =>
                OnboardingFlowPage.page(ProfileSetupView()),
              OnboardingFlowStatus.appLockSetup =>
                OnboardingFlowPage.page(AppLockSetupPage()),
              OnboardingFlowStatus.completed =>
                OnboardingFlowPage.page(Container()),
            }
          ];
        },
      ),
    );
  }
}
