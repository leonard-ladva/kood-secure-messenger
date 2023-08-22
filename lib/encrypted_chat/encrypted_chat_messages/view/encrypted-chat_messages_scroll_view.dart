import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:messaging_repository/messaging_repository.dart';
import 'package:relay/app/app.dart';
import 'package:relay/chat/chat.dart' as chat;
import 'package:relay/encrypted_chat/encrypted_chat.dart';

const largeRadius = Radius.circular(16);
const smallRadius = Radius.circular(4);

class EncryptedChatMessagesScrollView extends StatelessWidget {
  const EncryptedChatMessagesScrollView(this.room);
  final ChatRoom room;

  @override
  Widget build(BuildContext context) {
    final currentUser = context.select((AppBloc bloc) => bloc.state.user);
    return BlocBuilder<EncryptedChatMessagesBloc, EncryptedChatMessagesState>(
      builder: (context, state) {
        return CustomScrollView(
          reverse: true,
          slivers: [
            SliverToBoxAdapter(
              child: Align(
                alignment: Alignment.bottomLeft,
                child: chat.TypingIndicator(room),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final nextMessage =
                      index != 0 ? state.messages[index - 1] : null;
                  final previousMessage = index != state.messages.length - 1
                      ? state.messages[index + 1]
                      : null;
                  final message = state.messages[index];
                  final isPreviousSameUser =
                      previousMessage?.from == message.from;
                  final isNextSameUser = nextMessage?.from == message.from;

                  final isSameDayAsPrevious = DateUtils.isSameDay(
                      previousMessage?.createdAt, message.createdAt);
                  List<Widget> children = [];

                  if (!isSameDayAsPrevious) {
                    children.add(
                      Text(
                        DateFormat('E, d MMM').format(message.createdAt),
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey[300],
                        ),
                      ),
                    );
                  }
                  final isFromMe = message.from == currentUser.id;
                  children.add(
                    _Message(
                      message: message,
                      isNextSameUser: isNextSameUser,
                      isPreviousSameUser: isPreviousSameUser,
                      room: room,
                      isFromMe: isFromMe,
                    ),
                  );
                  return Column(children: children);
                },
                childCount: state.messages.length,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _TextContent extends StatelessWidget {
  const _TextContent({
    required this.message,
    required this.isNextSameUser,
    required this.isPreviousSameUser,
    required this.room,
    required this.isFromMe,
  });
  final EncryptedMessage message;
  final bool isNextSameUser;
  final bool isPreviousSameUser;
  final ChatRoom room;
  final bool isFromMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Text.rich(
        TextSpan(
          text: message.text,
          style: TextStyle(
            fontSize: 16,
          ),
          children: [
            TextSpan(text: '  '),
            TextSpan(
              text: DateFormat('Hm').format(message.createdAt),
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[300],
              ),
            ),
            if (isFromMe) TextSpan(text: '  '),
            if (isFromMe)
              WidgetSpan(
                child: Icon(
                  message.isRead
                      ? Icons.check_circle_sharp
                      : Icons.check_circle_outline_sharp,
                  size: 18,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

BorderRadius _MyMessageBorderRadius(bool isPreviousSameUser, isNextSameUser) {
  return BorderRadius.only(
    topLeft: largeRadius,
    bottomLeft: largeRadius,
    topRight: isPreviousSameUser ? smallRadius : largeRadius,
    bottomRight: isNextSameUser ? smallRadius : largeRadius,
  );
}

BoxDecoration _MyMessageDecoration(bool isPreviousSameUser, isNextSameUser) {
  return BoxDecoration(
    color: Colors.red,
    borderRadius: _MyMessageBorderRadius(isPreviousSameUser, isNextSameUser),
  );
}

BorderRadius _OtherPersonMessageBorderRadius(
    bool isPreviousSameUser, isNextSameUser) {
  return BorderRadius.only(
    topRight: largeRadius,
    bottomRight: largeRadius,
    topLeft: isPreviousSameUser ? smallRadius : largeRadius,
    bottomLeft: isNextSameUser ? smallRadius : largeRadius,
  );
}

BoxDecoration _OtherPersonMessageDecoration(
    bool isPreviousSameUser, isNextSameUser) {
  return BoxDecoration(
    color: Colors.grey[700],
    borderRadius:
        _OtherPersonMessageBorderRadius(isPreviousSameUser, isNextSameUser),
  );
}

class _Message extends StatelessWidget {
  const _Message({
    required this.message,
    required this.isNextSameUser,
    required this.isPreviousSameUser,
    required this.room,
    required this.isFromMe,
  });
  final EncryptedMessage message;
  final bool isNextSameUser;
  final bool isPreviousSameUser;
  final ChatRoom room;
  final bool isFromMe;

  @override
  Widget build(BuildContext context) {
    if (!isFromMe && message.isRead == false) {
      context.read<EncryptedChatMessagesBloc>().add(MessageSeen(message));
    }
    final alignment = isFromMe ? Alignment.centerRight : Alignment.centerLeft;
    return Padding(
      padding: const EdgeInsets.only(top: 2.0),
      child: Align(
        alignment: alignment,
        child: FractionallySizedBox(
          widthFactor: 0.9,
          child: Align(
            alignment: alignment,
            child: Container(
              decoration: isFromMe
                  ? _MyMessageDecoration(
                      isPreviousSameUser,
                      isNextSameUser,
                    )
                  : _OtherPersonMessageDecoration(
                      isPreviousSameUser,
                      isNextSameUser,
                    ),
              child: _TextContent(
                message: message,
                isNextSameUser: isNextSameUser,
                isPreviousSameUser: isPreviousSameUser,
                room: room,
                isFromMe: isFromMe,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
