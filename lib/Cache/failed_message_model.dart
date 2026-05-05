import 'package:chat_application/models/messageModel.dart';
import 'package:chat_application/providers/chatProvider.dart';
import 'package:hive/hive.dart';
part 'failed_message_model.g.dart';

@HiveType(typeId: 3)
class HiveFailedMessageModel extends HiveObject {
  @HiveField(0)
  final String messageId;

  @HiveField(1)
  final String chatRoomId;

  @HiveField(2)
  final String senderId;

  @HiveField(3)
  final String receiverId;

  @HiveField(4)
  final String message;

  @HiveField(5)
  final DateTime failedAt;

  @HiveField(6)
  final int retryCount;

  HiveFailedMessageModel({
    required this.messageId,
    required this.chatRoomId,
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.failedAt,
    required this.retryCount,
  });

  // ✅ Convert from MessageModel when a send fails
  factory HiveFailedMessageModel.fromMessageModel({
    required MessageModel message,
    required String chatRoomId,
    required String receiverId,
    int retryCount = 0,
  }) {
    return HiveFailedMessageModel(
      messageId: message.documentId,
      chatRoomId: chatRoomId,
      senderId: message.senderId,
      receiverId: receiverId,
      message: message.message,
      failedAt: DateTime.now(),
      retryCount: retryCount,
    );
  }

  // ✅ Reverse: rebuild a MessageModel for retry
  MessageModel toMessageModel() {
    return MessageModel(
      documentId: messageId,
      senderId: senderId,
      message: message,
      sentAt: failedAt,
      status: MessageStatus.pending.toString(),
    );
  }

  // ✅ Copy with incremented retry count
  HiveFailedMessageModel incrementRetry() {
    return HiveFailedMessageModel(
      messageId: messageId,
      chatRoomId: chatRoomId,
      senderId: senderId,
      receiverId: receiverId,
      message: message,
      failedAt: failedAt,
      retryCount: retryCount + 1,
    );
  }
}
