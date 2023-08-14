import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:relay/app/app.dart';

class ChatsListPage extends StatelessWidget {
  const ChatsListPage({super.key});

  static Page<void> page() => const MaterialPage<void>(child: ChatsListPage());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [
        IconButton(
          icon: const Icon(Icons.logout_rounded),
          onPressed: () {
            context.read<AppBloc>().add(const AppLogoutRequested());
          },
        )
      ]),
      body: Center(
        child: Icon(
          Icons.chat,
          size: 100,
        ),
      ),
    );
  }
}