import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:relay/app/app.dart';
import 'package:relay/messaging/view/chats_list_page.dart';
import 'package:relay/onboarding_flow/view/onboarding_flow.dart';
import 'package:relay/profile/bloc/profile_bloc.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.select((AppBloc bloc) => bloc.state.user);
    return BlocListener<ProfileBloc, ProfileState>(
      listener: (context, state) async {
        await Navigator.of(context).push(OnboardingFlow.route());
        context.read<ProfileBloc>().add(ProfileStatusRequested(user));
      },
      child: ChatsListPage(),
    );
  }
}
