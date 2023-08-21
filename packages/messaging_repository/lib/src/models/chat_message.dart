import 'dart:io';

import 'package:json_annotation/json_annotation.dart';

part 'chat_message.g.dart';

@JsonSerializable()
class ChatMessage {
  const ChatMessage({
    this.id,
    required this.from,
    required this.createdAt,
    required this.text,
    this.file,
    this.fileUrl,
    this.isRead = false,
    this.isEdited = false,
  });

  @JsonKey(includeIfNull: false, includeFromJson: false)
  final String? id;
  final String from;
  final DateTime createdAt;
  final String text;

  @JsonKey(includeFromJson: false, includeToJson: false)
  final File? file;
  @JsonKey(includeIfNull: false)
  final String? fileUrl;

  final bool isRead;
  final bool isEdited;

  factory ChatMessage.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageFromJson(json);
  Map<String, dynamic> toJson() => _$ChatMessageToJson(this);

  ChatMessage copyWith({
    String? id,
    String? from,
    DateTime? createdAt,
    String? text,
    File? file,
    String? fileUrl,
    bool? isRead,
    bool? isEdited,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      from: from ?? this.from,
      createdAt: createdAt ?? this.createdAt,
      text: text ?? this.text,
      file: file ?? this.file,
      fileUrl: fileUrl ?? this.fileUrl,
      isRead: isRead ?? this.isRead,
      isEdited: isEdited ?? this.isEdited,
    );
  }
}
