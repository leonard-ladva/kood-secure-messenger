import 'package:authentication_repository/authentication_repository.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:relay/chat/chat.dart';
import 'package:relay/chat_list/bloc/chat_list_bloc.dart';
import 'package:relay/encrypted_chat/encrypted_chat.dart';
import 'package:relay/helpers/src/initials.dart';

class ChatListView extends StatelessWidget {
  const ChatListView({super.key});

  String otherUser(List<String> memberIds, User currentUser) {
    return memberIds.firstWhere(
      (id) => id != currentUser.id,
      orElse: () => currentUser.id,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatListBloc, ChatListState>(
      builder: (context, state) {
        if (state.status == ChatListStatus.chatsLoaded) {
          return ListView.separated(
            itemCount: state.rooms!.length,
            separatorBuilder: (context, index) => SizedBox(
              height: 20,
            ),
            itemBuilder: (context, index) {
              final room = state.rooms![index];
              return ListTile(
                onTap: () {
                  Navigator.of(context).push(ChatPage.route(room));
                },
                minVerticalPadding: 20,
                titleAlignment: ListTileTitleAlignment.top,
                leading: CircleAvatar(
                  radius: 24,
                  foregroundImage: room.otherUser?.photo == null
                      ? null
                      : CachedNetworkImageProvider(room.otherUser!.photo!),
                  backgroundColor: Color(0xFFb8e986),
                  child: Text(
                    initials(
                      room.otherUser?.name ?? '',
                    ),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF528617),
                    ),
                  ),
                ),
                title: Text(
                  room.otherUser?.name ?? '',
                  style: TextStyle(fontSize: 18),
                ),
                trailing: IconButton(
                    icon: Icon(Icons.lock),
                    onPressed: () {
                      Navigator.of(context).push(EncryptedChatPage.route(room));
                    }),
              );
            },
          );
        }
        return Container(child: Text('hello'));
      },
    );
  }
}
