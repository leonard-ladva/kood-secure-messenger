import 'package:database_repository/database_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:relay/app/app.dart';
import 'package:relay/home/home.dart';
import 'package:relay/onboarding_flow/cubit/onboarding_flow_cubit.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static Page<void> page() => const MaterialPage<void>(child: HomePage());

  @override
  Widget build(BuildContext context) {
    final user = context.select((AppBloc bloc) => bloc.state.user);
    return BlocProvider<OnboardingFlowCubit>(
      create: (context) => OnboardingFlowCubit(
        databaseRepository: context.read<DatabaseRepository>(),
      )..getStatus(user.id),
      child: const HomeView(),
    );
  }
}
