import 'package:authentication_repository/authentication_repository.dart';
import 'package:database_repository/database_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:relay/profile_setup/profile_setup.dart';
import 'package:storage_bucket_repository/storage_bucket_repository.dart';

class ProfileSetupView extends StatelessWidget {
  const ProfileSetupView({super.key});

  static Page<void> page() =>
      const MaterialPage<void>(child: ProfileSetupView());

  @override
  Widget build(BuildContext context) {
      return BlocProvider(
        create: (_) => ProfileSetupCubit(
          authenticationRepository: context.read<AuthenticationRepository>(),
          databaseRepository: context.read<DatabaseRepository>(),
          storageBucketRepository: context.read<StorageBucketRepository>(),
        ),
        child: const ProfileSetupForm(),
    );
  }
}
