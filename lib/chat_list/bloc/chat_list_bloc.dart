import 'dart:async';
import 'dart:typed_data';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:cryptography_repository/cryptography_repository.dart';
import 'package:database_repository/database_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:local_storage_repository/local_storage_repository.dart';
import 'package:messaging_repository/messaging_repository.dart';

part 'chat_list_event.dart';
part 'chat_list_state.dart';

class ChatListBloc extends Bloc<ChatListEvent, ChatListState> {
  ChatListBloc({
    required MessagingRepository messagingRepository,
    required LocalStorageRepository localStorageRepository,
    required AuthenticationRepository authenticationRepository,
    required DatabaseRepository databaseRepository,
    required CryptographyRepository cryptographyRepository,
  })  : _localStorageRepository = localStorageRepository,
        _authenticationRepository = authenticationRepository,
        _databaseRepository = databaseRepository,
        _cryptographyRepository = cryptographyRepository,
        super(ChatListState.initial()) {
    on<_RoomListUpdated>(_onRoomListUpdated);

    _roomsSubscription = messagingRepository.rooms.listen(
      (rooms) => add(_RoomListUpdated(rooms)),
    );
  }
  late final StreamSubscription<List<ChatRoom>> _roomsSubscription;
  final LocalStorageRepository _localStorageRepository;
  final AuthenticationRepository _authenticationRepository;
  final DatabaseRepository _databaseRepository;
  final CryptographyRepository _cryptographyRepository;

  void _onRoomListUpdated(
      _RoomListUpdated event, Emitter<ChatListState> emit) async {
    try {
      for (ChatRoom room in event.chats) {
        Uint8List? combinedKey =
            await _localStorageRepository.getCombinedKey(room.id);
        if (combinedKey != null) continue;
          final currentUser = _authenticationRepository.currentUser;
          final otherUserId =
              room.memberIds.firstWhere((id) => id != currentUser.id);

          final myPrivateKey =
              _localStorageRepository.getUserKeySet(currentUser.id).privateKey;
          final otherUser = await _databaseRepository.getUser(otherUserId);
          
          combinedKey = await _cryptographyRepository.deriveCombinedCryptoKey(myPrivateKey, otherUser.publicKey!);
          _localStorageRepository.saveCombinedKey(room.id, combinedKey);
        
      }
    } catch (e) {
      emit(ChatListState.failure('An unknown error occured'));
      return;
    }
    emit(ChatListState.chatsLoaded(event.chats));
  }

  @override
  Future<void> close() {
    _roomsSubscription.cancel();
    return super.close();
  }
}
