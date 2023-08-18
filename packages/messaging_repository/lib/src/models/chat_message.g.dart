// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatMessage _$ChatMessageFromJson(Map<String, dynamic> json) => ChatMessage(
      id: json['id'] as String,
      from: json['from'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      text: json['text'] as String,
      fileUrl: json['fileUrl'] as String?,
      isRead: json['isRead'] as bool? ?? false,
      isEdited: json['isEdited'] as bool? ?? false,
    );

Map<String, dynamic> _$ChatMessageToJson(ChatMessage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'from': instance.from,
      'createdAt': instance.createdAt.toIso8601String(),
      'text': instance.text,
      'fileUrl': instance.fileUrl,
      'isRead': instance.isRead,
      'isEdited': instance.isEdited,
    };
