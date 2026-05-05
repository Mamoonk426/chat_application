import 'package:chat_application/models/chatModel.dart';
import 'package:hive/hive.dart';
part 'chat_model.g.dart';

@HiveType(typeId: 2)
class HiveChatModel extends HiveObject {
  @HiveField(0)
  final String documentId;
  @HiveField(1)
  final DateTime lastMessageTime;
  @HiveField(2)
  final List<String> participants;
  @HiveField(3)
  final Map<String, dynamic> participantNames;
  @HiveField(4)
  final String senderName;
  @HiveField(5)
  final String recievername;
  @HiveField(6)
  final String lastMessageSenderId;
  @HiveField(7)
  final String lastMessage;
  HiveChatModel({
    required this.documentId,
    required this.lastMessageTime,
    required this.lastMessage,
    required this.lastMessageSenderId,
    required this.participantNames,
    required this.participants,
    required this.recievername,
    required this.senderName,
  });
  factory HiveChatModel.fromChatModel(ChatModel chat) {
    return HiveChatModel(
      documentId: chat.documentId,
      lastMessageTime: chat.lastMessageTime,
      lastMessage: chat.lastMessage,
      lastMessageSenderId: chat.lastMessageSenderId,
      participantNames: chat.participantNames,
      participants: chat.participants,
      recievername: chat.receiverName,
      senderName: chat.senderName,
    );
  }

  // ✅ Reverse: convert back to ChatModel when reading from cache
  ChatModel toChatModel() {
    return ChatModel(
      documentId: documentId,
      lastMessageTime: lastMessageTime,
      lastMessage: lastMessage,
      lastMessageSenderId: lastMessageSenderId,
      participantNames: participantNames as Map<String, String>,
      participants: participants,
      receiverName: recievername,
      senderName: senderName,
    );
  }
}
