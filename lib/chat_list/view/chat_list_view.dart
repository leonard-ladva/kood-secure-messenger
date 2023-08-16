import 'package:flutter/material.dart';

class ChatListView extends StatelessWidget {
  const ChatListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Icon(
        Icons.chat_bubble,
        size: 100,
      ),
    );
  }
}
