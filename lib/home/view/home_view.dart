import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:relay/app/app.dart';
import 'package:relay/messaging/view/chats_list_page.dart';
import 'package:relay/onboarding_flow/cubit/onboarding_flow_cubit.dart';
import 'package:relay/onboarding_flow/view/onboarding_flow.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.select((AppBloc bloc) => bloc.state.user);
    return BlocListener<OnboardingFlowCubit, OnboardingFlowState>(
      listener: (context, state) async {
        if (state.status == OnboardingFlowStatus.completed) return;

        await Navigator.of(context).push(OnboardingFlow.route());
        context.read<OnboardingFlowCubit>().getStatus(user.id);
      },
      child: ChatsListPage(),
    );
  }
}
