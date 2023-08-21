import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:relay/chat/chat_input/cubit/chat_input_cubit.dart';

class ChatInputBar extends StatelessWidget {
  ChatInputBar({
    Key? key,
  }) : super(key: key);
  // final ChatRoom room;
  final textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatInputCubit, ChatInputState>(
      listener: (context, state) {
        if (state.status == ChatInputStatus.initial) {
          // empty the text field
          textController.clear();
        }
      },
      builder: (context, state) {
        return SizedBox(
          height: 44,
          child: Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: double.infinity,
                  child: TextField(
                    controller: textController,
                    onChanged: (value) {
                      context.read<ChatInputCubit>().textChanged(value);
                    },
                    textAlignVertical: TextAlignVertical.center,
                    decoration: InputDecoration(
                      fillColor: Colors.grey[700],
                      filled: true,
                      contentPadding: EdgeInsets.only(
                        left: 16,
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.all(
                          Radius.circular(30),
                        ),
                      ),
                      hintText: 'Relay message',
                    ),
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              if (state.text.isEmpty) _ImageButton() else _SendButton(),
            ],
          ),
        );
      },
    );
  }
}

class _SendButton extends StatelessWidget {
  const _SendButton();
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.red,
      ),
      child: IconButton(
        onPressed: () => context.read<ChatInputCubit>().sendMessage(),
        icon: Icon(
          Icons.send,
        ),
      ),
    );
  }
}

class _ImageButton extends StatelessWidget {
  const _ImageButton();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.red,
      ),
      child: IconButton(
        onPressed: () {},
        icon: Icon(
          Icons.add,
        ),
      ),
    );
  }
}
