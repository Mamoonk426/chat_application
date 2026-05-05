import 'package:chat_application/models/messageModel.dart';
import 'package:hive/hive.dart';
part 'message_model.g.dart';

@HiveType(typeId: 0)
class HiveMessageModel extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String senderId;
  @HiveField(2)
  final String text;
  @HiveField(3)
  final DateTime timestamp;
  @HiveField(4)
  String status;

  HiveMessageModel({
    required this.id,
    required this.senderId,
    required this.text,
    required this.timestamp,
    required this.status,
  });
  factory HiveMessageModel.fromchat(MessageModel message) {
    return HiveMessageModel(
      id: message.documentId,
      senderId: message.senderId,
      text: message.message,
      timestamp: message.sentAt,
      status: message.status,
    );
  }
}
