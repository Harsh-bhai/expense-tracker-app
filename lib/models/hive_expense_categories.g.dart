// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_expense_categories.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HiveExpenseCateogryAdapter extends TypeAdapter<HiveExpenseCateogry> {
  @override
  final int typeId = 1;

  @override
  HiveExpenseCateogry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveExpenseCateogry(
      key: fields[0] as String,
      categories: (fields[1] as List).cast<ListTileModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, HiveExpenseCateogry obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.key)
      ..writeByte(1)
      ..write(obj.categories);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveExpenseCateogryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
