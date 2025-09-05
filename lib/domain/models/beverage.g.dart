// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'beverage.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BeverageAdapter extends TypeAdapter<Beverage> {
  @override
  final int typeId = 6;

  @override
  Beverage read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Beverage(
      id: fields[0] as String,
      name: fields[1] as String,
      volume: fields[2] as double,
      caffeineAmount: fields[3] as double,
      colorIndex: fields[4] as int,
      imageIndex: fields[5] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Beverage obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.volume)
      ..writeByte(3)
      ..write(obj.caffeineAmount)
      ..writeByte(4)
      ..write(obj.colorIndex)
      ..writeByte(5)
      ..write(obj.imageIndex);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BeverageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
