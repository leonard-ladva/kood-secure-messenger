import 'package:authentication_repository/authentication_repository.dart';
import 'package:database_repository/database_repository.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_storage_repository/local_storage_repository.dart';
import 'package:relay/app/app.dart';
import 'package:relay/theme.dart';
import 'package:storage_bucket_repository/storage_bucket_repository.dart';

class App extends StatelessWidget {
  const App({
    required AuthenticationRepository authenticationRepository,
    required LocalStorageRepository localStorageRepository,
    super.key,
  }) : _authenticationRepository = authenticationRepository,
       _localStorageRepository = localStorageRepository;

  final AuthenticationRepository _authenticationRepository;
  final LocalStorageRepository _localStorageRepository;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthenticationRepository>.value(
          value: _authenticationRepository,
        ),
        RepositoryProvider<DatabaseRepository>(
          create: (context) => DatabaseRepository(),
        ),
        RepositoryProvider<StorageBucketRepository>(
          create: (context) => StorageBucketRepository(),
        ),
        RepositoryProvider<LocalStorageRepository>.value(
          value: _localStorageRepository,
        ),
      ],
      child: BlocProvider(
        create: (_) => AppBloc(
          authenticationRepository: _authenticationRepository,
        ),
        child: const AppView(),
      ),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: theme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      home: FlowBuilder<AppStatus>(
        state: context.select((AppBloc bloc) => bloc.state.status),
        onGeneratePages: onGenerateAppViewPages,
      ),
    );
  }
}
