// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_media.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatMedia _$ChatMediaFromJson(Map<String, dynamic> json) => ChatMedia(
      fileUrl: json['fileUrl'] as String,
      type: $enumDecode(_$ChatMediaTypeEnumMap, json['type']),
    );

Map<String, dynamic> _$ChatMediaToJson(ChatMedia instance) => <String, dynamic>{
      'type': _$ChatMediaTypeEnumMap[instance.type]!,
      'fileUrl': instance.fileUrl,
    };

const _$ChatMediaTypeEnumMap = {
  ChatMediaType.image: 'image',
  ChatMediaType.video: 'video',
};
