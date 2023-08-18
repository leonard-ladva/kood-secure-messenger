import 'dart:async';
import 'dart:developer';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:database_repository/database_repository.dart';
import 'package:messaging_repository/messaging_repository.dart';

/// {@template database_repository}
/// Repository which manages cloud data storage.
/// {@endtemplate}
class MessagingRepository {
  /// {@macro database_repository}
  MessagingRepository({
    FirebaseFirestore? firestore,
    required AuthenticationRepository authenticationRepository,
  })  : _authenticationRepository = authenticationRepository,
        _firestore = firestore ?? FirebaseFirestore.instance,
        super() {
    // _chatRoomsSubscription =
    log('id: ${_authenticationRepository.currentUser.id}');
    _rooms.onListen = () => _firestore
        .collection('chats')
        .where('memberIds',
            arrayContains: _authenticationRepository.currentUser.id)
        .snapshots()
        .listen((snapshot) => _onNewRoomsDataReceived(snapshot));
    // _firestore
    //     .collection('chats')
    //     .where('memberIds',
    //         arrayContains: _authenticationRepository.currentUser.id)
    //     .snapshots()
    //     .listen((snapshot) => _onNewRoomsDataReceived(snapshot));
  }

  final AuthenticationRepository _authenticationRepository;
  final DatabaseRepository _databaseRepository = DatabaseRepository();
  final FirebaseFirestore _firestore;

  // late final StreamSubscription<QuerySnapshot> _chatRoomsSubscription;
  Stream<List<ChatRoom>> get rooms => _rooms.stream;
  final StreamController<List<ChatRoom>> _rooms =
      StreamController<List<ChatRoom>>.broadcast();

  void _onNewRoomsDataReceived(QuerySnapshot snapshot) async {
    log("here");
    if (_rooms.hasListener == false) return;
    log("here too");

    try {
      log(snapshot.docs.length.toString());
      final updatedRooms = snapshot.docs.map((doc) {
        final room = ChatRoom.fromJson(doc.data() as Map<String, dynamic>);
        return room;
      }).toList();
      log(updatedRooms.toString());
      _rooms.add(updatedRooms);
    } catch (e) {
      log('error');
      _rooms.addError(e);
    }
  }

  Future<void> makeRoom(String contactId) async {
    User currentUser = _authenticationRepository.currentUser;
    User otherUser = User.empty;
    try {
      currentUser = await _databaseRepository.getUser(currentUser.id);
    } on GetUserProfileFailure catch (e) {
      throw MakeRoomFailure(e.toString());
    } catch (e) {
      throw MakeRoomFailure(e.toString());
    }
    try {
      otherUser = await _databaseRepository.getUser(contactId);
    } on GetUserProfileFailure catch (e) {
      throw MakeRoomFailure(e.toString());
    } catch (e) {
      throw MakeRoomFailure(e.toString());
    }

    final ids = [currentUser.id, contactId];
    ids.sort();
    final roomId = ids.join('-');
    final room = ChatRoom(
      id: roomId,
      members: [currentUser, otherUser],
      memberIds: ids,
    );
    try {
      await _firestore.collection('chats').doc(room.id).set(room.toJson());
    } catch (e) {
      throw MakeRoomFailure(e.toString());
    }
  }
}
