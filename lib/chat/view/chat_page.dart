import 'package:authentication_repository/authentication_repository.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messaging_repository/messaging_repository.dart';
import 'package:relay/chat/chat.dart';
import 'package:relay/helpers/helpers.dart';

class ChatPage extends StatelessWidget {
  const ChatPage(this.room, {super.key});
  final ChatRoom room;

  static Route<void> route(ChatRoom room) {
    return MaterialPageRoute(builder: (_) => ChatPage(room));
  }

  get otherUser => room.otherUser ?? User.empty;
  @override
  Widget build(BuildContext context) {
    return BlocProvider<ChatMessagesBloc>(
      create: (context) => ChatMessagesBloc(
        authenticationRepository: context.read<AuthenticationRepository>(),
        messagingRepository: context.read<MessagingRepository>(),
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
        ),
        body: Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Column(
        children: [
          Expanded(
            child: ChatMessagesScrollView(room),
          ),
          const SizedBox(
            height: 4,
          ),
          ChatInput(room),
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
