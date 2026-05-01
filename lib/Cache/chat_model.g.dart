// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HiveChatModelAdapter extends TypeAdapter<HiveChatModel> {
  @override
  final int typeId = 2;

  @override
  HiveChatModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveChatModel(
      documentId: fields[0] as String,
      lastMessageTime: fields[1] as DateTime,
      lastMessage: fields[7] as String,
      lastMessageSenderId: fields[6] as String,
      participantNames: (fields[3] as Map).cast<String, dynamic>(),
      participants: (fields[2] as List).cast<String>(),
      recievername: fields[5] as String,
      senderName: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, HiveChatModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.documentId)
      ..writeByte(1)
      ..write(obj.lastMessageTime)
      ..writeByte(2)
      ..write(obj.participants)
      ..writeByte(3)
      ..write(obj.participantNames)
      ..writeByte(4)
      ..write(obj.senderName)
      ..writeByte(5)
      ..write(obj.recievername)
      ..writeByte(6)
      ..write(obj.lastMessageSenderId)
      ..writeByte(7)
      ..write(obj.lastMessage);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveChatModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
