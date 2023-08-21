import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messaging_repository/messaging_repository.dart';
import 'package:relay/chat/chat.dart';
import 'package:relay/chat/chat_input/cubit/chat_input_cubit.dart';

class ChatInput extends StatelessWidget {
  const ChatInput(this.room, {super.key});
  final ChatRoom room;
  @override
  Widget build(BuildContext context) {
    return BlocProvider<ChatInputCubit>(
      create: (context) => ChatInputCubit(
        authenticationRepository: context.read<AuthenticationRepository>(),
        messagingRepository: context.read<MessagingRepository>(),
      ),
      child: ChatInputBar(room),
    );
  }
}