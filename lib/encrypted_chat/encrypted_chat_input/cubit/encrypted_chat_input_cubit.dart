import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:cryptography_repository/cryptography_repository.dart';
import 'package:database_repository/database_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:local_storage_repository/local_storage_repository.dart';
import 'package:messaging_repository/messaging_repository.dart';

part 'encrpyted_chat_input_state.dart';

class EncryptedChatInputCubit extends Cubit<EncryptedChatInputState> {
  EncryptedChatInputCubit({
    required AuthenticationRepository authenticationRepository,
    required CryptographyRepository cryptographyRepository,
    required MessagingRepository messagingRepository,
    required LocalStorageRepository localStorageRepository,
    required DatabaseRepository databaseRepository,
    required ChatRoom room,
  })  : _authenticationRepository = authenticationRepository,
        _cryptographyRepository = cryptographyRepository,
        _databaseRepository = databaseRepository,
        _messagingRepository = messagingRepository,
        _localStorageRepository = localStorageRepository,
        _room = room,
        super(EncryptedChatInputState.initial());

  final AuthenticationRepository _authenticationRepository;
  final DatabaseRepository _databaseRepository;
  final CryptographyRepository _cryptographyRepository;
  final MessagingRepository _messagingRepository;
  final LocalStorageRepository _localStorageRepository;
  final ChatRoom _room;

  Future<void> textChanged(String text) async {
    emit(EncryptedChatInputState.writing(text));
    try {
      await _messagingRepository.setTypingStatus(_room.id, text.isNotEmpty);
    } catch (e) {
      log(e.toString());
    }
  }

  void sendMessage() async {
    final currentUser = _authenticationRepository.currentUser;
    Uint8List? combinedKey = _localStorageRepository.getCombinedKey(_room.id);
    if (combinedKey == null) {
      emit(EncryptedChatInputState.failure(
        'An unknown error occured, please try again',
      ));
      return;
    }

    final encryptedText = await _cryptographyRepository.encrypt(
      state.text,
      combinedKey,
    );

    final message = EncryptedMessage(
      from: currentUser.id,
      createdAt: DateTime.now(),
      encryptedText: encryptedText,
    );

    try {
      await _messagingRepository.sendEncryptedMessage(
        _room.id,
        message,
      );
      textChanged('');
      emit(EncryptedChatInputState.initial());
    } on SendMessageFailure catch (e) {
      emit(EncryptedChatInputState.failure(e.message));
    } catch (_) {
      emit(EncryptedChatInputState.failure('An unknown error occured'));
    }
  }

  @override
  Future<void> close() async {
    textChanged('');
    return super.close();
  }
}
