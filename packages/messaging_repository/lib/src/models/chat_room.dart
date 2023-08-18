import 'package:authentication_repository/authentication_repository.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chat_room.g.dart';

@JsonSerializable()
class ChatRoom {
  const ChatRoom({
    required this.id,
    this.otherUser,
    required this.memberIds,
    // required this.lastMessage,
  });

  final String id;
  @JsonKey(includeFromJson: false, includeToJson: false)
  final User? otherUser;
  final List<String> memberIds;
  // final ChatMessage lastMessage;

  //copy with 
  ChatRoom copyWith({
    String? id,
    User? otherUser,
    List<String>? memberIds,
    // ChatMessage? lastMessage,
  }) {
    return ChatRoom(
      id: id ?? this.id,
      otherUser: otherUser ?? this.otherUser,
      memberIds: memberIds ?? this.memberIds,
      // lastMessage: lastMessage ?? this.lastMessage,
    );
  }

  factory ChatRoom.fromJson(Map<String, dynamic> json) =>
      _$ChatRoomFromJson(json);
  Map<String, dynamic> toJson() => _$ChatRoomToJson(this);
}
