import 'package:hive/hive.dart';

part 'keyset.g.dart';

@HiveType(typeId: 0)
class KeySet extends HiveObject {
  KeySet({
    required this.publicKey,
    required this.privateKey,
  });

  @HiveField(0)
  final Map<String, dynamic> publicKey;
  @HiveField(1)
  final Map<String, dynamic> privateKey;
}
