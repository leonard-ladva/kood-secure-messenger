import 'package:authentication_repository/authentication_repository.dart';
import 'package:cryptography_repository/cryptography_repository.dart';
import 'package:database_repository/database_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_storage_repository/local_storage_repository.dart';
import 'package:messaging_repository/messaging_repository.dart';
import 'package:relay/encrypted_chat/encrypted_chat.dart';

class EncryptedChatInput extends StatelessWidget {
  const EncryptedChatInput(this.room, {super.key});
  final ChatRoom room;
  @override
  Widget build(BuildContext context) {
    return BlocProvider<EncryptedChatInputCubit>(
      create: (context) => EncryptedChatInputCubit(
        authenticationRepository: context.read<AuthenticationRepository>(),
        messagingRepository: context.read<MessagingRepository>(),
        databaseRepository: context.read<DatabaseRepository>(),
        localStorageRepository: context.read<LocalStorageRepository>(),
        cryptographyRepository: context.read<CryptographyRepository>(),
        room: room,
      ),
      child: EncryptedChatInputBar(),
    );
  }
}
