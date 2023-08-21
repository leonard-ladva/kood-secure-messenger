import 'package:authentication_repository/authentication_repository.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chat_room.g.dart';

@JsonSerializable()
class ChatRoom {
  const ChatRoom({
    required this.id,
    this.otherUser,
    required this.memberIds,
    required this.isTyping,
  });

  final String id;
  @JsonKey(includeFromJson: false, includeToJson: false)
  final User? otherUser;
  final List<String> memberIds;
  final Map<String, bool> isTyping;

  ChatRoom copyWith({
    String? id,
    User? otherUser,
    List<String>? memberIds,
    Map<String, bool>? isTyping,
  }) {
    return ChatRoom(
      id: id ?? this.id,
      otherUser: otherUser ?? this.otherUser,
      memberIds: memberIds ?? this.memberIds,
      isTyping: isTyping ?? this.isTyping,
    );
  }

  factory ChatRoom.fromJson(Map<String, dynamic> json) =>
      _$ChatRoomFromJson(json);
  Map<String, dynamic> toJson() => _$ChatRoomToJson(this);
}
