// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatMessage _$ChatMessageFromJson(Map<String, dynamic> json) => ChatMessage(
      from: json['from'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      text: json['text'] as String,
      fileUrl: json['fileUrl'] as String?,
      isRead: json['isRead'] as bool? ?? false,
      isEdited: json['isEdited'] as bool? ?? false,
    );

Map<String, dynamic> _$ChatMessageToJson(ChatMessage instance) {
  final val = <String, dynamic>{
    'from': instance.from,
    'createdAt': instance.createdAt.toIso8601String(),
    'text': instance.text,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('fileUrl', instance.fileUrl);
  val['isRead'] = instance.isRead;
  val['isEdited'] = instance.isEdited;
  return val;
}
