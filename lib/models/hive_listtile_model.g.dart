// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_listtile_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HiveListTileModelAdapter extends TypeAdapter<HiveListTileModel> {
  @override
  final int typeId = 0;

  @override
  HiveListTileModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveListTileModel(
      title: fields[0] as String?,
      subtitle: fields[1] as String?,
      page: fields[2] as String?,
      iconFontFamily: fields[4] as String?,
      iconFontPackage: fields[5] as String?,
    )
      ..iconCodePoint = fields[3] as int?
      ..bgColorValue = fields[8] as int?;
  }

  @override
  void write(BinaryWriter writer, HiveListTileModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.subtitle)
      ..writeByte(2)
      ..write(obj.page)
      ..writeByte(3)
      ..write(obj.iconCodePoint)
      ..writeByte(4)
      ..write(obj.iconFontFamily)
      ..writeByte(5)
      ..write(obj.iconFontPackage)
      ..writeByte(8)
      ..write(obj.bgColorValue);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveListTileModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
