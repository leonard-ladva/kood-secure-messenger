// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_room.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatRoom _$ChatRoomFromJson(Map<String, dynamic> json) => ChatRoom(
      id: json['id'] as String,
      memberIds:
          (json['memberIds'] as List<dynamic>).map((e) => e as String).toList(),
      isTyping: Map<String, bool>.from(json['isTyping'] as Map),
    );

Map<String, dynamic> _$ChatRoomToJson(ChatRoom instance) => <String, dynamic>{
      'id': instance.id,
      'memberIds': instance.memberIds,
      'isTyping': instance.isTyping,
    };
