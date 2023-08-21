import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:messaging_repository/messaging_repository.dart';

part 'typing_indicator_state.dart';

class TypingIndicatorCubit extends Cubit<TypingIndicatorState> {
  TypingIndicatorCubit({
    required MessagingRepository messagingRepository,
    required ChatRoom room,
  })  : _messagingRepository = messagingRepository,
        super(TypingIndicatorState.notTyping()) {

    _messagingRepository.typingStatusStreamSetup(room.id);
    _typingStatusStream = _messagingRepository.typingStatus.listen(
      (typingStatus) {
        log('got new typing status: $typingStatus');
        if (typingStatus) {
          emit(TypingIndicatorState.typing());
        } else {
          emit(TypingIndicatorState.notTyping());
        }
      },
    );
  }
  final MessagingRepository _messagingRepository;
  late final StreamSubscription<bool> _typingStatusStream;

  @override
  Future<void> close() {
    _typingStatusStream.cancel();
    return super.close();
  }
}
