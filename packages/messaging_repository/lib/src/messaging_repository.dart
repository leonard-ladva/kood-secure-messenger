import 'dart:async';
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
    _rooms.onListen = () => _firestore
        .collection('chats')
        .where('memberIds',
            arrayContains: _authenticationRepository.currentUser.id)
        .snapshots()
        .listen((snapshot) => _onNewRoomsDataReceived(snapshot));
  }

  final AuthenticationRepository _authenticationRepository;
  final DatabaseRepository _databaseRepository = DatabaseRepository();
  final FirebaseFirestore _firestore;

  // late final StreamSubscription<QuerySnapshot> _chatRoomsSubscription;
  Stream<List<ChatRoom>> get rooms => _rooms.stream;
  final StreamController<List<ChatRoom>> _rooms =
      StreamController<List<ChatRoom>>.broadcast();

  String _otherUserId(List<String> memberIds, User currentUser) {
    return memberIds.firstWhere(
      (id) => id != currentUser.id,
      orElse: () => currentUser.id,
    );
  }

  void _onNewRoomsDataReceived(QuerySnapshot snapshot) async {
    if (_rooms.hasListener == false) return;

    try {
      final updatedRoomsFuture = snapshot.docs.map((doc) {
        final room = ChatRoom.fromJson(doc.data() as Map<String, dynamic>);
        return room;
      }).map((room) async {
        final otherUserId =
            _otherUserId(room.memberIds, _authenticationRepository.currentUser);
        final otherUser = await _databaseRepository.getUser(otherUserId);
        return room.copyWith(otherUser: otherUser);
      }).toList();

      final updatedRooms = await Future.wait(updatedRoomsFuture);
      _rooms.add(updatedRooms);
    } catch (e) {
      _rooms.addError(e);
    }
  }

  Future<void> makeRoom(String otherUserId) async {
    User currentUser = _authenticationRepository.currentUser;

    final room = ChatRoom(
      id: _roomId(currentUser.id, otherUserId),
      memberIds: [currentUser.id, otherUserId],
    );

    try {
      room.toJson();
    } catch (e) {
      throw MakeRoomFailure(e.toString());
    }

    try {
      await _firestore.collection('chats').doc(room.id).set(room.toJson());
    } catch (e) {
      throw MakeRoomFailure(e.toString());
    }
  }

  Future<bool> roomExists(String contactId) async {
    User currentUser = _authenticationRepository.currentUser;

    final roomId = _roomId(currentUser.id, contactId);
    try {
      final doc = await _firestore.collection('chats').doc(roomId).get();
      return doc.exists;
    } catch (e) {
      throw RoomExistsFailure(e.toString());
    }
  }

  String _roomId(String userId1, String userId2) {
    final ids = [userId1, userId2];
    ids.sort();
    final roomId = ids.join('-');
    return roomId;
  }
}
