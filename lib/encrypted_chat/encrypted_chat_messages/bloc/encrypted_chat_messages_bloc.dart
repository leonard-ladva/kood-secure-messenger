import 'dart:async';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:cryptography_repository/cryptography_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:local_storage_repository/local_storage_repository.dart';
import 'package:messaging_repository/messaging_repository.dart';

part 'encrypted_chat_messages_event.dart';
part 'encrypted_chat_messages_state.dart';

class EncryptedChatMessagesBloc
    extends Bloc<EncryptedChatMessagesEvent, EncryptedChatMessagesState> {
  EncryptedChatMessagesBloc({
    required MessagingRepository messagingRepository,
    required CryptographyRepository cryptographyRepository,
    required LocalStorageRepository localStorageRepository,
    required ChatRoom room,
  })  : _messagingRepository = messagingRepository,
        _cryptographyRepository = cryptographyRepository,
        _localStorageRepository = localStorageRepository,
        _room = room,
        super(EncryptedChatMessagesState.initial()) {
    on<MessageSeen>(_onMessageSeen);
    on<_MessageListUpdated>(_onMessageListUpdated);

    _messagingRepository.ecryptedChatMessagesStreamSetup(room.id);
    _messsageSubscription = _messagingRepository.encryptedMessages.listen(
      (messages) => add(_MessageListUpdated(messages)),
    );
  }
  final ChatRoom _room;
  final MessagingRepository _messagingRepository;
  final CryptographyRepository _cryptographyRepository;
  final LocalStorageRepository _localStorageRepository;

  late final StreamSubscription<List<EncryptedMessage>> _messsageSubscription;

  void _onMessageListUpdated(
    _MessageListUpdated event,
    Emitter<EncryptedChatMessagesState> emit,
  ) async {
    List<EncryptedMessage> decryptedMessages = [];
    for (EncryptedMessage message in event.messages) {
      try {
        final Uint8List? combinedCryptoKey =
            await _localStorageRepository.getCombinedKey(_room.id);
        if (combinedCryptoKey == null) {
          emit(EncryptedChatMessagesState.failure(
              'An unknown error occured, please try again'));
          return;
        }

        final decryptedText = await _cryptographyRepository.decrypt(
          message.encryptedText,
          combinedCryptoKey,
        );

        decryptedMessages.add(message.copyWith(text: decryptedText));
      } catch (e) {
        emit(EncryptedChatMessagesState.failure('An unknown error occured'));
        return;
      }
    }
    emit(EncryptedChatMessagesState.success(decryptedMessages));
  }

  void _onMessageSeen(
    MessageSeen event,
    Emitter<EncryptedChatMessagesState> emit,
  ) async {
    try {
      await _messagingRepository.setEncryptedMessageAsRead(
        _room.id,
        event.message.id ?? '',
      );
    } on SetMessageAsReadFailure catch (e) {
      emit(EncryptedChatMessagesState.failure(e.message));
    } catch (_) {
      emit(EncryptedChatMessagesState.failure('An unknown error occured'));
    }
  }

  @override
  Future<void> close() {
    _messsageSubscription.cancel();
    return super.close();
  }
}
