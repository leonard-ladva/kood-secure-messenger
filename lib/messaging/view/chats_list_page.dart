import 'package:flutter/material.dart';

class ChatsListPage extends StatefulWidget {
  const ChatsListPage({super.key});

  static Page<void> page() => const MaterialPage<void>(child: ChatsListPage());

  @override
  State<ChatsListPage> createState() => _ChatsListPageState();
}

class _ChatsListPageState extends State<ChatsListPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Icon(Icons.people, size: 100),
    );
  }
}