import 'package:database_repository/database_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:relay/app/app.dart';
import 'package:relay/home/home.dart';
import 'package:relay/profile/bloc/profile_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static Page<void> page() => const MaterialPage<void>(child: HomePage());

  @override
  Widget build(BuildContext context) {
    final user = context.select((AppBloc bloc) => bloc.state.user);
    return BlocProvider<ProfileBloc>(
      create: (context) => ProfileBloc(
        databaseRepository: context.read<DatabaseRepository>(),
      )..add(
          ProfileStatusRequested(user),
        ),
      child: const HomeView(),
    );
  }
}
