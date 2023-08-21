import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messaging_repository/messaging_repository.dart';
import 'package:relay/chat/chat.dart';

class TypingIndicator extends StatelessWidget {
  const TypingIndicator(this.room, {super.key});

  final ChatRoom room;
  @override
  Widget build(BuildContext context) {
    return BlocProvider<TypingIndicatorCubit>(
      create: (context) => TypingIndicatorCubit(
        messagingRepository: context.read<MessagingRepository>(),
        room: room,
      ),
      child: _TypingIndicator(),
    );
  }
}

class _TypingIndicator extends StatefulWidget {
  const _TypingIndicator();

  final Color bubbleColor = const Color(0xFF646b7f);
  final Color flashingCircleDarkColor = const Color(0xFF333333);
  final Color flashingCircleBrightColor = const Color(0xFFaec1dd);

  @override
  State<_TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<_TypingIndicator>
    with TickerProviderStateMixin {
  late AnimationController _appearanceController;

  late AnimationController _repeatingController;
  final List<Interval> _dotIntervals = const [
    Interval(0.25, 0.8),
    Interval(0.35, 0.9),
    Interval(0.45, 1.0),
  ];

  @override
  void initState() {
    super.initState();

    _appearanceController = AnimationController(
      vsync: this,
    )..addListener(() {
        setState(() {});
      });

    _repeatingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    // _showIndicator();
  }

  // @override
  // void didUpdateWidget(_TypingIndicator oldWidget) {
  //   super.didUpdateWidget(oldWidget);

  //   if (widget.showIndicator != oldWidget.showIndicator) {
  //     if (widget.showIndicator) {
  //       _showIndicator();
  //     } else {
  //       _hideIndicator();
  //     }
  //   }
  // }

  @override
  void dispose() {
    _appearanceController.dispose();
    _repeatingController.dispose();
    super.dispose();
  }

  void _showIndicator() {
    _appearanceController
      ..duration = const Duration(milliseconds: 750)
      ..forward();
    _repeatingController.repeat();
  }

  void _hideIndicator() {
    _appearanceController
      ..duration = const Duration(milliseconds: 150)
      ..reverse();
    _repeatingController.stop();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TypingIndicatorCubit, TypingIndicatorState>(
      listener: (context, state) {
        setState(() {
          state.status == TypingIndicatorStatus.typing
              ? _showIndicator()
              : _hideIndicator();
        });
      },
      builder: (context, state) {
        if (state.status == TypingIndicatorStatus.typing) {
          return Padding(
            padding: const EdgeInsets.only(top: 2.0),
            child: StatusBubble(
              repeatingController: _repeatingController,
              dotIntervals: _dotIntervals,
              flashingCircleDarkColor: widget.flashingCircleDarkColor,
              flashingCircleBrightColor: widget.flashingCircleBrightColor,
              bubbleColor: widget.bubbleColor,
            ),
          );
        }
        return Container();
      },
    );
  }
}

class StatusBubble extends StatelessWidget {
  const StatusBubble({
    super.key,
    required this.repeatingController,
    required this.dotIntervals,
    required this.flashingCircleBrightColor,
    required this.flashingCircleDarkColor,
    required this.bubbleColor,
  });

  final AnimationController repeatingController;
  final List<Interval> dotIntervals;
  final Color flashingCircleDarkColor;
  final Color flashingCircleBrightColor;
  final Color bubbleColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(27),
        color: Colors.grey[700],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          FlashingCircle(
            index: 0,
            repeatingController: repeatingController,
            dotIntervals: dotIntervals,
            flashingCircleDarkColor: flashingCircleDarkColor,
            flashingCircleBrightColor: flashingCircleBrightColor,
          ),
          const SizedBox(width: 4),
          FlashingCircle(
            index: 1,
            repeatingController: repeatingController,
            dotIntervals: dotIntervals,
            flashingCircleDarkColor: flashingCircleDarkColor,
            flashingCircleBrightColor: flashingCircleBrightColor,
          ),
          const SizedBox(width: 4),
          FlashingCircle(
            index: 2,
            repeatingController: repeatingController,
            dotIntervals: dotIntervals,
            flashingCircleDarkColor: flashingCircleDarkColor,
            flashingCircleBrightColor: flashingCircleBrightColor,
          ),
        ],
      ),
    );
  }
}

class FlashingCircle extends StatelessWidget {
  const FlashingCircle({
    super.key,
    required this.index,
    required this.repeatingController,
    required this.dotIntervals,
    required this.flashingCircleBrightColor,
    required this.flashingCircleDarkColor,
  });

  final int index;
  final AnimationController repeatingController;
  final List<Interval> dotIntervals;
  final Color flashingCircleDarkColor;
  final Color flashingCircleBrightColor;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: repeatingController,
      builder: (context, child) {
        final circleFlashPercent = dotIntervals[index].transform(
          repeatingController.value,
        );
        final circleColorPercent = sin(pi * circleFlashPercent);

        return Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Color.lerp(
              flashingCircleDarkColor,
              flashingCircleBrightColor,
              circleColorPercent,
            ),
          ),
        );
      },
    );
  }
}
