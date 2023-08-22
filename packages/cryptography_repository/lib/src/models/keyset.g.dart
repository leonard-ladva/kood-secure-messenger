// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'keyset.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class KeySetAdapter extends TypeAdapter<KeySet> {
  @override
  final int typeId = 0;

  @override
  KeySet read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return KeySet(
      publicKey: (fields[0] as Map).cast<String, dynamic>(),
      privateKey: (fields[1] as Map).cast<String, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, KeySet obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.publicKey)
      ..writeByte(1)
      ..write(obj.privateKey);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is KeySetAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
