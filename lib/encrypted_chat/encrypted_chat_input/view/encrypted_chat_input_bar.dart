import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:relay/encrypted_chat/encrypted_chat.dart';

class EncryptedChatInputBar extends StatelessWidget {
  EncryptedChatInputBar({
    Key? key,
  }) : super(key: key);
  // final ChatRoom room;
  final textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EncryptedChatInputCubit, EncryptedChatInputState>(
      listener: (context, state) {
        if (state.status == EncryptedChatInputStatus.initial) {
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
                      context.read<EncryptedChatInputCubit>().textChanged(value);
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
              _SendButton(state.text.isEmpty),
            ],
          ),
        );
      },
    );
  }
}

class _SendButton extends StatelessWidget {
  const _SendButton(this.isTextEmpty);
  final bool isTextEmpty;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isTextEmpty ? Colors.grey[700] : Colors.red,
      ),
      child: IconButton(
        onPressed: () {
          if (isTextEmpty) return;
          context.read<EncryptedChatInputCubit>().sendMessage();
        },
        icon: Icon(
          Icons.send,
        ),
      ),
    );
  }
}
