import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:relay/app/app.dart';
import 'package:relay/chat_list/chat_list.dart';
import 'package:relay/onboarding_flow/onboarding_flow.dart';
import 'package:relay/profile/bloc/profile_bloc.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.select((AppBloc bloc) => bloc.state.user);
    return BlocListener<OnboardingFlowCubit, OnboardingFlowState>(
      listener: (context, state) async {
        context.read<ProfileBloc>().add(ProfileStatusRequested(user.id));
        if (state.status == OnboardingFlowStatus.completed) return;

        await Navigator.of(context).push(OnboardingFlow.route());
        context.read<OnboardingFlowCubit>().getStatus(user.id);
      },
      child: ChatListPage(),
    );
  }
}
