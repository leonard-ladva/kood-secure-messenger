import 'package:authentication_repository/authentication_repository.dart';
import 'package:database_repository/database_repository.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_storage_repository/local_storage_repository.dart';
import 'package:messaging_repository/messaging_repository.dart';
import 'package:relay/app/app.dart';
import 'package:relay/deep_links/deep_links.dart';
import 'package:relay/profile/profile.dart';
import 'package:relay/theme.dart';
import 'package:storage_bucket_repository/storage_bucket_repository.dart';

class App extends StatelessWidget {
  const App({
    required AuthenticationRepository authenticationRepository,
    required DatabaseRepository databaseRepository,
    required LocalStorageRepository localStorageRepository,
    required MessagingRepository messagingRepository,
    super.key,
  })  : _authenticationRepository = authenticationRepository,
        _databaseRepository = databaseRepository,
        _localStorageRepository = localStorageRepository,
        _messagingRepository = messagingRepository;

  final AuthenticationRepository _authenticationRepository;
  final DatabaseRepository _databaseRepository;
  final LocalStorageRepository _localStorageRepository;
  final MessagingRepository _messagingRepository;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthenticationRepository>.value(
          value: _authenticationRepository,
        ),
        RepositoryProvider<DatabaseRepository>.value(
          value: _databaseRepository,
        ),
        RepositoryProvider<StorageBucketRepository>(
          create: (context) => StorageBucketRepository(),
        ),
        RepositoryProvider<LocalStorageRepository>.value(
          value: _localStorageRepository,
        ),
        RepositoryProvider<MessagingRepository>.value(
          value: _messagingRepository,
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<DeepLinksCubit>(
            create: (context) => DeepLinksCubit()..init(),
          ),
          BlocProvider<AppBloc>(
            create: (_) => AppBloc(
              authenticationRepository: _authenticationRepository,
              localStorageRepository: _localStorageRepository,
            ),
          ),
          BlocProvider<ProfileBloc>(
            create: (context) => ProfileBloc(
              authenticationRepository: _authenticationRepository,
              databaseRepository: _databaseRepository,
            ),
          ),
         
        ],
        child: AppView(),
      ),
    );
  }
}

class AppView extends StatelessWidget {
  AppView({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: theme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      home: BlocListener<DeepLinksCubit, DeepLinksState>(
        listener: (context, state) {
          if (state.status == DeepLinksStatus.newLinkReceived) {
            if (state.destination == null) return;
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => state.destination!,
              ),
            );
          }
        },
        child: FlowBuilder<AppStatus>(
          state: context.select((AppBloc bloc) => bloc.state.status),
          onGeneratePages: onGenerateAppViewPages,
        ),
      ),
    );
  }
}
