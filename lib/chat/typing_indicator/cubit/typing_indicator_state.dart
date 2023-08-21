part of 'typing_indicator_cubit.dart';

enum TypingIndicatorStatus {
  typing,
  notTyping,
}

class TypingIndicatorState extends Equatable {
  const TypingIndicatorState._({
    this.status = TypingIndicatorStatus.notTyping,
  });

  final TypingIndicatorStatus status;

  const TypingIndicatorState.typing()
      : this._(
          status: TypingIndicatorStatus.typing,
        );
  
  const TypingIndicatorState.notTyping()
      : this._(
          status: TypingIndicatorStatus.notTyping,
        );

  @override
  List<Object> get props => [status];
}
