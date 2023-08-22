import 'package:authentication_repository/authentication_repository.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cryptography_repository/cryptography_repository.dart';
import 'package:database_repository/database_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_storage_repository/local_storage_repository.dart';
import 'package:messaging_repository/messaging_repository.dart';
import 'package:relay/app/app.dart';
import 'package:relay/chat_list/bloc/chat_list_bloc.dart';
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
    return BlocProvider<ChatListBloc>(
      create: (context) => ChatListBloc(
        messagingRepository: context.read<MessagingRepository>(),
        localStorageRepository: context.read<LocalStorageRepository>(),
        authenticationRepository: context.read<AuthenticationRepository>(),
        databaseRepository: context.read<DatabaseRepository>(),
        cryptographyRepository: context.read<CryptographyRepository>(),
      ),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          leadingWidth: 32,
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _MyProfileButton(currentUser),
              const SizedBox(width: 24),
              Text(
                'Relay',
                style: TextStyle(
                  fontSize: 24,
                ),
              ),
            ],
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
      ),
    );
  }
}

class _MyProfileButton extends StatelessWidget {
  const _MyProfileButton(this.currentUser);
  final User currentUser;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 8,
      ),
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
              : CachedNetworkImageProvider(currentUser.photo!),
          radius: 14,
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
    );
  }
}
