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
    _roomsStreamSetup();
  }

  final AuthenticationRepository _authenticationRepository;
  final DatabaseRepository _databaseRepository = DatabaseRepository();
  final FirebaseFirestore _firestore;

  Stream<List<ChatRoom>> get rooms => _roomsStreamController.stream;
  final StreamController<List<ChatRoom>> _roomsStreamController =
      StreamController<List<ChatRoom>>.broadcast();
  late StreamSubscription<QuerySnapshot> _firestoreChatsStream;

  void _roomsStreamSetup() {
    _roomsStreamController.onListen = () {
      _firestoreChatsStream = _firestore
          .collection('chats')
          .where('memberIds',
              arrayContains: _authenticationRepository.currentUser.id)
          .snapshots()
          .listen((snapshot) => _onNewRoomsDataReceived(snapshot));
    };
    _roomsStreamController.onCancel = () {
      _firestoreChatsStream.cancel();
    };
  }

  String _otherUserId(List<String> memberIds, User currentUser) {
    return memberIds.firstWhere(
      (id) => id != currentUser.id,
      orElse: () => currentUser.id,
    );
  }

  void _onNewRoomsDataReceived(QuerySnapshot snapshot) async {
    if (_roomsStreamController.isClosed) return;
    if (_roomsStreamController.hasListener == false) return;

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
      _roomsStreamController.add(updatedRooms);
    } catch (e) {
      _roomsStreamController.addError(e);
    }
  }

  Future<ChatRoom> getRoom(String otherUserId) async {
    User currentUser = _authenticationRepository.currentUser;

    final roomId = _roomId(currentUser.id, otherUserId);
    try {
      final doc = await _firestore.collection('chats').doc(roomId).get();
      final room = ChatRoom.fromJson(doc.data() as Map<String, dynamic>);
      final otherUser = await _databaseRepository.getUser(otherUserId);
      return room.copyWith(otherUser: otherUser);
    } catch (e) {
      throw GetRoomFailure(e.toString());
    }
  }

  Future<void> makeRoom(String otherUserId) async {
    User currentUser = _authenticationRepository.currentUser;

    final room = ChatRoom(id: _roomId(currentUser.id, otherUserId), memberIds: [
      currentUser.id,
      otherUserId
    ], isTyping: {
      currentUser.id: false,
      otherUserId: false,
    });

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

  Stream<List<ChatMessage>> get messages => _messagesStreamController.stream;
  final _messagesStreamController =
      StreamController<List<ChatMessage>>.broadcast();
  late StreamSubscription<QuerySnapshot> _firestoreMessagesStream;

  void chatMessagesStreamSetup(String roomId) {
    _messagesStreamController.onListen = () {
      _firestoreMessagesStream = _firestore
          .collection('chats')
          .doc(roomId)
          .collection('messages')
          .orderBy('createdAt', descending: true)
          .snapshots()
          .listen((snapshot) => _onNewMessagesDataReceived(snapshot));
    };
    _messagesStreamController.onCancel = () {
      _firestoreMessagesStream.cancel();
    };
  }

  void _onNewMessagesDataReceived(QuerySnapshot snapshot) async {
    if (_messagesStreamController.isClosed) return;
    if (_messagesStreamController.hasListener == false) return;

    try {
      final updatedMessages = snapshot.docs.map((doc) {
        final message =
            ChatMessage.fromJson(doc.data() as Map<String, dynamic>);
        return message.copyWith(id: doc.id);
      }).toList();

      _messagesStreamController.add(updatedMessages);
    } catch (e) {
      _messagesStreamController.addError(e);
    }
  }

  Future<List<ChatMessage>> getChatMessages(String roomId, int offset) async {
    try {
      final querySnapshot = await _firestore
          .collection('chats')
          .doc(roomId)
          .collection('messages')
          .orderBy('createdAt', descending: true)
          .limit(50)
          .get();
      return querySnapshot.docs.map((doc) {
        final message = ChatMessage.fromJson(doc.data());
        return message.copyWith(id: doc.id);
      }).toList();
    } catch (e) {
      throw GetChatMessagesFailure(e.toString());
    }
  }

  Future<void> sendMessage(String roomId, ChatMessage message) async {
    try {
      // Todo: handle files
      await _firestore
          .collection('chats')
          .doc(roomId)
          .collection('messages')
          .add(message.toJson());
    } catch (e) {
      throw SendMessageFailure(e.toString());
    }
  }

  Future<void> setMessageAsRead(String roomId, String messageId) async {
    try {
      await _firestore
          .collection('chats')
          .doc(roomId)
          .collection('messages')
          .doc(messageId)
          .update({
        'isRead': true,
      });
    } catch (e) {
      throw SetMessageAsReadFailure(e.toString());
    }
  }

  Stream<bool> get typingStatus =>
      _typingStatusStreamController.stream;
  final _typingStatusStreamController =
      StreamController<bool>.broadcast();
  late StreamSubscription<DocumentSnapshot> _firestoreRoomUpdateStream;

  void typingStatusStreamSetup(String roomId) {
    _typingStatusStreamController.onListen = () {
      _firestoreRoomUpdateStream = _firestore
          .collection('chats')
          .doc(roomId)
          .snapshots()
          .listen((snapshot) => _onNewTypingStatusReceived(snapshot));
    };
    _typingStatusStreamController.onCancel = () {
      _firestoreRoomUpdateStream.cancel();
    };
  }

  void _onNewTypingStatusReceived(DocumentSnapshot snapshot) async {
    if (_typingStatusStreamController.isClosed) return;
    if (_typingStatusStreamController.hasListener == false) return;

    try {
      final room = ChatRoom.fromJson(snapshot.data() as Map<String, dynamic>);
      final otherUserId = _otherUserId(
        room.memberIds,
        _authenticationRepository.currentUser,
      );
      final bool isOtherPersonTyping = room.isTyping[otherUserId] ?? false; 
      
      _typingStatusStreamController.add(isOtherPersonTyping);
    } catch (e) {
      _typingStatusStreamController.addError(e);
    }
  }

  Future<void> setTypingStatus(String roomId, bool isTyping) async {
    User currentUser = _authenticationRepository.currentUser;

    try {
      await _firestore.collection('chats').doc(roomId).update({
        'isTyping.${currentUser.id}': isTyping,
      });
    } catch (e) {
      throw SetTypingStatusFailure(e.toString());
    }
  }
}
