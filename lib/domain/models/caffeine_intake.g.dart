// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'caffeine_intake.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CaffeineIntakeAdapter extends TypeAdapter<CaffeineIntake> {
  @override
  final int typeId = 0;

  @override
  CaffeineIntake read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CaffeineIntake(
      id: fields[0] as String,
      productName: fields[1] as String,
      caffeineAmount: fields[2] as double,
      timestamp: fields[3] as DateTime,
      barcode: fields[4] as String?,
      quantity: fields[5] as double?,
    );
  }

  @override
  void write(BinaryWriter writer, CaffeineIntake obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.productName)
      ..writeByte(2)
      ..write(obj.caffeineAmount)
      ..writeByte(3)
      ..write(obj.timestamp)
      ..writeByte(4)
      ..write(obj.barcode)
      ..writeByte(5)
      ..write(obj.quantity);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CaffeineIntakeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
