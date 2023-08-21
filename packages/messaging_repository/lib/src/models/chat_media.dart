import 'package:json_annotation/json_annotation.dart';

part 'chat_media.g.dart';

enum ChatMediaType {
  image,
  video,
}

@JsonSerializable()
class ChatMedia {
  const ChatMedia({
    required this.fileUrl,
    required this.type,
  });

  final ChatMediaType type;
  final String fileUrl;


  factory ChatMedia.fromJson(Map<String, dynamic> json) =>
      _$ChatMediaFromJson(json);
  Map<String, dynamic> toJson() => _$ChatMediaToJson(this);

  ChatMedia copyWith({
    String? fileUrl,
    ChatMediaType? type,
  }) {
    return ChatMedia(
      fileUrl: fileUrl ?? this.fileUrl,
      type: type ?? this.type,
    );
  }
}

