import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:database_repository/database_repository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_storage_repository/local_storage_repository.dart';
import 'package:relay/app/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = const AppBlocObserver();

  await Firebase.initializeApp();
  await LocalStorageRepository.init();

  // android status bar / ios navigation bar
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  final authenticationRepository = AuthenticationRepository();
  await authenticationRepository.user.first;

  final localStorageRepository = await LocalStorageRepository.create();
  final databaseRepository = DatabaseRepository();

  runApp(App(
    authenticationRepository: authenticationRepository,
    databaseRepository: databaseRepository,
    localStorageRepository: localStorageRepository,
  ));
}
