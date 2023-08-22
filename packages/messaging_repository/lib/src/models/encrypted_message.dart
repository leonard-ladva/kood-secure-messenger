import 'package:json_annotation/json_annotation.dart';
part 'encrypted_message.g.dart';

@JsonSerializable(explicitToJson: true)
class EncryptedMessage {
  const EncryptedMessage({
    this.id,
    required this.from,
    required this.createdAt,
    required this.encryptedText,
    this.text,
    this.isRead = false,
    this.isEdited = false,
  });

  @JsonKey(includeIfNull: false, includeFromJson: false)
  final String? id;
  final String from;
  final DateTime createdAt;
  final String encryptedText;
  @JsonKey(includeFromJson: false, includeToJson: false)
  final String? text;

  final bool isRead;
  final bool isEdited;

  factory EncryptedMessage.fromJson(Map<String, dynamic> json) =>
      _$EncryptedMessageFromJson(json);
  Map<String, dynamic> toJson() => _$EncryptedMessageToJson(this);

  EncryptedMessage copyWith({
    String? id,
    String? from,
    DateTime? createdAt,
    String? encryptedText,
    String? text,
    bool? isRead,
    bool? isEdited,
  }) {
    return EncryptedMessage(
      id: id ?? this.id,
      from: from ?? this.from,
      createdAt: createdAt ?? this.createdAt,
      encryptedText: encryptedText ?? this.encryptedText,
      text: text ?? this.text,
      isRead: isRead ?? this.isRead,
      isEdited: isEdited ?? this.isEdited,
    );
  }
}
