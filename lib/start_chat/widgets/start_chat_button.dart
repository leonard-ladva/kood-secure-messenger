import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:relay/chat/view/view.dart';
import 'package:relay/start_chat/start_chat.dart';

class StartChatButton extends StatelessWidget {
  const StartChatButton({
    required this.userId,
    super.key,
  });
  final String userId;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StartChatCubit, StartChatState>(
      listener: (context, state) {
        if (state.status == StartChatStatus.success) {
          Navigator.of(context).pushReplacement(ChatPage.route(state.room!));
        }
        if (state.status == StartChatStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? 'error'),
            ),
          );
        }
      },
      builder: (context, state) {
        if (state.status == StartChatStatus.loading) {
          return const CircularProgressIndicator.adaptive();
        }

        return ElevatedButton(
          onPressed: () {
            context.read<StartChatCubit>().onStartChatRequested(userId);
          },
          child: const Text('Start Chat'),
        );
      },
    );
  }
}
