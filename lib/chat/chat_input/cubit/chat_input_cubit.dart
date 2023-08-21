import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:messaging_repository/messaging_repository.dart';

part 'chat_input_state.dart';

class ChatInputCubit extends Cubit<ChatInputState> {
  ChatInputCubit({
    required AuthenticationRepository authenticationRepository,
    required MessagingRepository messagingRepository,
  })  : _authenticationRepository = authenticationRepository,
        _messagingRepository = messagingRepository,
        super(ChatInputState.initial());

  final AuthenticationRepository _authenticationRepository;
  final MessagingRepository _messagingRepository;

  void textChanged(String text) {
    emit(ChatInputState.writing(text));
  }

  void sendMessage(ChatRoom room) async {
    final currentUser = _authenticationRepository.currentUser;
    final message = ChatMessage(
      from: currentUser.id,
      createdAt: DateTime.now(),
      text: state.text,
    );

    try {
      await _messagingRepository.sendMessage(
        room.id,
        message,
      );
      emit(ChatInputState.initial());
    } on SendMessageFailure catch (e) {
      emit(ChatInputState.failure(e.message));
    } catch (_) {
      emit(ChatInputState.failure('An unknown error occured'));
    }
  }
}
