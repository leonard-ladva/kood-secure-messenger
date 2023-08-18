import 'package:json_annotation/json_annotation.dart';

part 'chat_message.g.dart';

@JsonSerializable()
class ChatMessage {
  const ChatMessage({
    required this.id,
    required this.from,
    required this.createdAt,
    required this.text,
    this.fileUrl,
    this.isRead = false,
    this.isEdited = false,
  });

  final String id;
  final String from;
  final DateTime createdAt;
  final String text;
  final String? fileUrl;
  final bool isRead;
  final bool isEdited;

  factory ChatMessage.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageFromJson(json);
  Map<String, dynamic> toJson() => _$ChatMessageToJson(this);
}
