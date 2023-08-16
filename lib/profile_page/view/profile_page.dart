import 'package:database_repository/database_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:relay/profile/bloc/profile_bloc.dart';
import 'package:relay/profile_page/profile_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage(this.userId, {super.key});
  final String userId;

  static Page<void> page(String userId) =>
      MaterialPage<void>(child: ProfilePage(userId));

  @override
  Widget build(BuildContext context) {
    final currentUser = context.select((ProfileBloc bloc) => bloc.state.user);
    return Scaffold(
      appBar: AppBar(),
      body: BlocProvider<ProfilePageCubit>(
        create: (context) => ProfilePageCubit(
            databaseRepository: context.read<DatabaseRepository>())
          ..getUserData(userId, currentUser),
        child: ProfileView(),
      ),
    );
  }
}
