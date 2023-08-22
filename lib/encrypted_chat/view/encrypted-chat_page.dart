import 'package:authentication_repository/authentication_repository.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cryptography_repository/cryptography_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_storage_repository/local_storage_repository.dart';
import 'package:messaging_repository/messaging_repository.dart';
import 'package:relay/encrypted_chat/encrypted_chat.dart';
import 'package:relay/helpers/helpers.dart';

class EncryptedChatPage extends StatelessWidget {
  const EncryptedChatPage(this.room, {super.key});
  final ChatRoom room;

  static Route<void> route(ChatRoom room) {
    return MaterialPageRoute(builder: (_) => EncryptedChatPage(room));
  }

  get otherUser => room.otherUser ?? User.empty;
  @override
  Widget build(BuildContext context) {
    return BlocProvider<EncryptedChatMessagesBloc>(
      create: (context) => EncryptedChatMessagesBloc(
        messagingRepository: context.read<MessagingRepository>(),
        cryptographyRepository: context.read<CryptographyRepository>(),
        localStorageRepository: context.read<LocalStorageRepository>(),
        room: room,
      ),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          leadingWidth: 40,
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _OtherUserAvatar(otherUser),
              const SizedBox(width: 24),
              Text(
                otherUser.name ?? '',
                style: TextStyle(
                  fontSize: 24,
                ),
              ),
            ],
          ),
          actions: [Icon(Icons.lock), const SizedBox(width: 8)],
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: Column(
            children: [
              Expanded(
                child: EncryptedChatMessagesScrollView(room),
              ),
              const SizedBox(
                height: 4,
              ),
              EncryptedChatInput(room),
            ],
          ),
        ),
      ),
    );
  }
}

class _OtherUserAvatar extends StatelessWidget {
  const _OtherUserAvatar(this.user);
  final User user;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      foregroundImage:
          user.photo == null ? null : CachedNetworkImageProvider(user.photo!),
      radius: 18,
      backgroundColor: Color(0xFFb8e986),
      child: Text(
        initials(
          user.name ?? '',
        ),
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Color(0xFF528617),
        ),
      ),
    );
  }
}
