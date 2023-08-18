import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:relay/app/app.dart';
import 'package:relay/chat_list/chat_list.dart';
import 'package:relay/helpers/helpers.dart';
import 'package:relay/profile/profile.dart';
import 'package:relay/profile_page/profile_page.dart';
import 'package:relay/user_search/user_search.dart';

class ChatListPage extends StatelessWidget {
  const ChatListPage({super.key});

  static Page<void> page() => const MaterialPage<void>(child: ChatListPage());

  @override
  Widget build(BuildContext context) {
    final currentUser = context.select((ProfileBloc bloc) => bloc.state.user);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leadingWidth: 70,
        title: Text(
          'Chats',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 32,
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.only(left: 4, top: 4, bottom: 4),
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).push<void>(
                MaterialPageRoute(
                  builder: (context) => ProfilePage(currentUser.id),
                ),
              );
            },
            child: CircleAvatar(
              foregroundImage: currentUser.photo == null
                  ? null
                  : NetworkImage(currentUser.photo!),
              // radius: 10,
              backgroundColor: Color(0xFFb8e986),
              child: Text(
                initials(
                  currentUser.name ?? '',
                ),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF528617),
                ),
              ),
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              Navigator.of(context).push<void>(
                MaterialPageRoute(
                  builder: (context) => UserSearchPage(),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              context.read<AppBloc>().add(AppLogoutRequested());
            },
          ),
        ],
      ),
      body: ChatListView(),
    );
  }
}
