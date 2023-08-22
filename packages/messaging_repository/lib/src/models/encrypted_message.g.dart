// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'encrypted_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EncryptedMessage _$EncryptedMessageFromJson(Map<String, dynamic> json) =>
    EncryptedMessage(
      from: json['from'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      encryptedText: json['encryptedText'] as String,
      isRead: json['isRead'] as bool? ?? false,
      isEdited: json['isEdited'] as bool? ?? false,
    );

Map<String, dynamic> _$EncryptedMessageToJson(EncryptedMessage instance) =>
    <String, dynamic>{
      'from': instance.from,
      'createdAt': instance.createdAt.toIso8601String(),
      'encryptedText': instance.encryptedText,
      'isRead': instance.isRead,
      'isEdited': instance.isEdited,
    };
