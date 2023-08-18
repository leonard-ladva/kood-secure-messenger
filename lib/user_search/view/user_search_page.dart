import 'package:database_repository/database_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:relay/user_search/bloc/user_search_bloc.dart';
import 'package:relay/user_search/user_search.dart';

class UserSearchPage extends StatelessWidget {
  const UserSearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<UserSearchBloc>(
      create: (context) => UserSearchBloc(
        databaseRepository: context.read<DatabaseRepository>(),
      )..add(QueryChanged('')),
      child: UserSearchView(),
    );
  }
}
