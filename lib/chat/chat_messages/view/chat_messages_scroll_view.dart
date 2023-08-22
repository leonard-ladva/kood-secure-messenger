import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:messaging_repository/messaging_repository.dart';
import 'package:relay/app/app.dart';
import 'package:relay/chat/chat.dart';
import 'package:relay/chat/chat_messages/widgets/message_long_click_dialog.dart';
import 'package:video_player/video_player.dart';

const largeRadius = Radius.circular(16);
const smallRadius = Radius.circular(4);

class ChatMessagesScrollView extends StatelessWidget {
  const ChatMessagesScrollView(this.room);
  final ChatRoom room;

  @override
  Widget build(BuildContext context) {
    final currentUser = context.select((AppBloc bloc) => bloc.state.user);
    return BlocBuilder<ChatMessagesBloc, ChatMessagesState>(
      builder: (context, state) {
        return CustomScrollView(
          reverse: true,
          slivers: [
            SliverToBoxAdapter(
              child: Align(
                alignment: Alignment.bottomLeft,
                child: TypingIndicator(room),
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

class _MediaContent extends StatelessWidget {
  const _MediaContent({
    required this.message,
    required this.isNextSameUser,
    required this.isPreviousSameUser,
    required this.room,
    required this.isFromMe,
  });

  final ChatMessage message;
  final bool isNextSameUser;
  final bool isPreviousSameUser;
  final ChatRoom room;
  final bool isFromMe;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 0.65,
      child: Align(
        alignment: Alignment.centerRight,
        child: ClipRRect(
          borderRadius: isFromMe
              ? _MyMessageBorderRadius(
                  isPreviousSameUser,
                  isNextSameUser,
                )
              : _OtherPersonMessageBorderRadius(
                  isPreviousSameUser,
                  isNextSameUser,
                ),
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              message.media!.type == ChatMediaType.image
                  ? _ImageContent(message.media!)
                  : _VideoContent(message.media!),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 2,
                ),
                child: Text.rich(
                  TextSpan(
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _VideoContent extends StatefulWidget {
  const _VideoContent(this.media);
  final ChatMedia media;

  @override
  State<_VideoContent> createState() => _VideoContentState();
}

class _VideoContentState extends State<_VideoContent> {
  late VideoPlayerController _videoController;

  @override
  void initState() {
    super.initState();
    if (widget.media.type == ChatMediaType.video) {
      _videoController =
          VideoPlayerController.networkUrl(Uri.parse(widget.media.fileUrl))
            ..initialize().then((_) => setState(() {}));
    }
  }

  @override
  Widget build(BuildContext context) {
    return _videoController.value.isInitialized
        ? Stack(
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    _videoController.value.isPlaying
                        ? _videoController.pause()
                        : _videoController.play();
                  });
                },
                child: AspectRatio(
                  aspectRatio: _videoController.value.aspectRatio,
                  child: VideoPlayer(_videoController),
                ),
              ),
              if (!_videoController.value.isPlaying)
                Align(
                  alignment: Alignment.topRight,
                  child: Icon(
                    Icons.play_arrow,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
            ],
          )
        : Container();
  }
}

class _ImageContent extends StatelessWidget {
  const _ImageContent(this.media);
  final ChatMedia media;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: media.fileUrl,
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
  final ChatMessage message;
  final bool isNextSameUser;
  final bool isPreviousSameUser;
  final ChatRoom room;
  final bool isFromMe;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () async {
        if (!isFromMe) return;
        final LongPressDialogReturnValues result = await showDialog(
          context: context,
          builder: (context) => LongPressDialog(),
        );

        if (result.delete == false && result.edit == false) return;
        if (result.delete) {
          context.read<ChatMessagesBloc>().add(DeleteMessage(message));
          return;
        }
        context
            .read<ChatMessagesBloc>()
            .add(EditMessage(result.newText, message));
      },
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
  final ChatMessage message;
  final bool isNextSameUser;
  final bool isPreviousSameUser;
  final ChatRoom room;
  final bool isFromMe;

  @override
  Widget build(BuildContext context) {
    if (!isFromMe && message.isRead == false) {
      context.read<ChatMessagesBloc>().add(MessageSeen(message));
    }
    final alignment = isFromMe ? Alignment.centerRight : Alignment.centerLeft;
    return Padding(
      padding: const EdgeInsets.only(top: 2.0),
      child: Align(
        alignment: alignment,
        child: message.media == null
            ? FractionallySizedBox(
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
              )
            : _MediaContent(
                message: message,
                isNextSameUser: isNextSameUser,
                isPreviousSameUser: isPreviousSameUser,
                room: room,
                isFromMe: isFromMe,
              ),
      ),
    );
  }
}
