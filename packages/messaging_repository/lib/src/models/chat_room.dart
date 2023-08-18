import 'package:authentication_repository/authentication_repository.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chat_room.g.dart';

@JsonSerializable()
class ChatRoom {
  const ChatRoom(
      {required this.id, required this.members, required this.memberIds
      // required this.lastMessage,
      });

  final String id;
  final List<User> members;
  final List<String> memberIds;
  // final ChatMessage lastMessage;

  factory ChatRoom.fromJson(Map<String, dynamic> json) =>
      _$ChatRoomFromJson(json);
  Map<String, dynamic> toJson() => _$ChatRoomToJson(this);
}
