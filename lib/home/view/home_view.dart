import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:relay/home/routes/routes.dart';
import 'package:relay/profile/bloc/profile_bloc.dart';



class HomeView extends StatelessWidget {
  const HomeView ({super.key});

  @override
  Widget build(BuildContext context) {
    return FlowBuilder<ProfileStatus>(
      state: context.select((ProfileBloc bloc) => bloc.state.status),
      onGeneratePages: onGenerateHomeViewPages,
    );
  }
}
