// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'failed_message_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HiveFailedMessageModelAdapter
    extends TypeAdapter<HiveFailedMessageModel> {
  @override
  final int typeId = 3;

  @override
  HiveFailedMessageModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveFailedMessageModel(
      messageId: fields[0] as String,
      chatRoomId: fields[1] as String,
      senderId: fields[2] as String,
      receiverId: fields[3] as String,
      message: fields[4] as String,
      failedAt: fields[6] as DateTime,
      retryCount: fields[7] as int,
    );
  }

  @override
  void write(BinaryWriter writer, HiveFailedMessageModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.messageId)
      ..writeByte(1)
      ..write(obj.chatRoomId)
      ..writeByte(2)
      ..write(obj.senderId)
      ..writeByte(3)
      ..write(obj.receiverId)
      ..writeByte(4)
      ..write(obj.message)
      ..writeByte(6)
      ..write(obj.failedAt)
      ..writeByte(7)
      ..write(obj.retryCount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveFailedMessageModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
