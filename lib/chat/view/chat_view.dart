import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:messaging_repository/messaging_repository.dart';
import 'package:relay/app/app.dart';
import 'package:relay/chat/chat.dart';

class ChatView extends StatelessWidget {
  const ChatView(this.room, {super.key});
  final ChatRoom room;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatMessagesBloc, ChatMessagesState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: Column(
            children: [
              Expanded(
                child: _MessagesView(room),
              ),
              const SizedBox(
                height: 4,
              ),
              ChatInput(room),
            ],
          ),
        );
      },
    );
  }
}

class _MessagesView extends StatelessWidget {
  const _MessagesView(this.room);
  final ChatRoom room;

  @override
  Widget build(BuildContext context) {
    final currentUser = context.select((AppBloc bloc) => bloc.state.user);
    return BlocBuilder<ChatMessagesBloc, ChatMessagesState>(
      builder: (context, state) {
        return CustomScrollView(
          reverse: true,
          slivers: [
            SliverList(
              delegate: SliverChildListDelegate.fixed([
                const SizedBox(height: 8),
              ]),
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
                  final isSameDayAsNext = DateUtils.isSameDay(
                      nextMessage?.createdAt, message.createdAt);
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
                    isFromMe
                        ? _MyMessage(
                            message: message,
                            isNextSameUser: isNextSameUser && isSameDayAsNext,
                            isPreviousSameUser:
                                isPreviousSameUser && isSameDayAsPrevious,
                            room: room)
                        : _OtherPersonMessage(
                            message: message,
                            isNextSameUser: isNextSameUser,
                            isPreviousSameUser: isPreviousSameUser,
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

class _OtherPersonMessage extends StatelessWidget {
  const _OtherPersonMessage({
    required this.message,
    required this.isNextSameUser,
    required this.isPreviousSameUser,
  });
  final ChatMessage message;
  final bool isNextSameUser;
  final bool isPreviousSameUser;

  static const largeRadius = Radius.circular(16);
  static const smallRadius = Radius.circular(4);
  @override
  Widget build(BuildContext context) {
    if (message.isRead == false) {
      context.read<ChatMessagesBloc>().add(MessageSeen(message));
    }
    return Padding(
      padding: const EdgeInsets.only(top: 2.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: FractionallySizedBox(
          widthFactor: 0.9,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[700],
                borderRadius: BorderRadius.only(
                  topLeft: isPreviousSameUser ? smallRadius : largeRadius,
                  bottomLeft: isNextSameUser ? smallRadius : largeRadius,
                  topRight: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: Text.rich(
                  TextSpan(
                    text: message.text,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                    children: [
                      TextSpan(
                        text: '  ',
                      ),
                      TextSpan(
                        text: DateFormat('Hm').format(message.createdAt),
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey[300],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MyMessage extends StatelessWidget {
  const _MyMessage({
    required this.message,
    required this.isNextSameUser,
    required this.isPreviousSameUser,
    required this.room,
  });
  final ChatMessage message;
  final bool isNextSameUser;
  final bool isPreviousSameUser;
  final ChatRoom room;


  static const largeRadius = Radius.circular(16);
  static const smallRadius = Radius.circular(4);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 2.0),
      child: Align(
        alignment: Alignment.centerRight,
        child: FractionallySizedBox(
          widthFactor: 0.9,
          child: Align(
            alignment: Alignment.centerRight,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                  topRight: isPreviousSameUser ? smallRadius : largeRadius,
                  bottomRight: isNextSameUser ? smallRadius : largeRadius,
                ),
              ),
              child: Padding(
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
                      TextSpan(text: '  '),
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
              ),
            ),
          ),
        ),
      ),
    );
  }
}
