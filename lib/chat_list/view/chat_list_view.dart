import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:relay/chat_list/bloc/chat_list_bloc.dart';
import 'package:relay/profile/bloc/profile_bloc.dart';

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
    final currentUser = context.read<ProfileBloc>().state.user;
    return BlocBuilder<ChatListBloc, ChatListState>(
      builder: (context, state) {
        if (state.status == ChatListStatus.chatsLoaded) {
          return ListView.builder(
              itemCount: state.rooms!.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    otherUser(
                      state.rooms![index].memberIds,
                      currentUser,
                    ),
                  ),
                );
              });
        }
        return Container(child: Text('hello'));
      },
    );
  }
}
