import 'package:chat_application/models/chatModel.dart';
import 'package:chat_application/models/messageModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Chatservices {
  final dbInstance = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser;
  Future<String> generateChatId(String recieverId) async {
    String currentUserId = user!.uid.toString();
    if (recieverId.toLowerCase().compareTo(currentUserId.toLowerCase()) > 0) {
      return '${recieverId}_$currentUserId';
    } else {
      return '${currentUserId}_$recieverId';
    }
  }

  Future<void> startChat(String recieverId, String message) async {
    final chatId = await generateChatId(recieverId);
    final senderId = FirebaseAuth.instance.currentUser!.uid.toString();

    // Fetch display names for both participants
    final senderDoc = await dbInstance.collection('Users').doc(senderId).get();
    final receiverDoc = await dbInstance
        .collection('Users')
        .doc(recieverId)
        .get();
    final senderName = senderDoc.data()?['name'] as String? ?? '';
    final receiverName = receiverDoc.data()?['name'] as String? ?? '';

    final chatRef = dbInstance.collection('ChatRoom').doc(chatId);
    final messageRef = chatRef.collection('Messages');
    final newMessage = MessageModel(
      documentId: '',
      senderId: senderId,
      message: message,
      sentAt: DateTime.now(),
      isRead: false,
    );
    final batch = dbInstance.batch();
    final messageDoc = messageRef.doc();
    batch.set(chatRef, {
      'lastMessage': newMessage.toMap(),
      'lastMessageTime': Timestamp.fromDate(newMessage.sentAt),
      'lastMessageSenderId': newMessage.senderId,
      'participants': [recieverId, senderId],
      'participantNames': {senderId: senderName, recieverId: receiverName},
    }, SetOptions(merge: true));
    batch.set(messageDoc, newMessage.toMap());

    await batch.commit();
  }

  Stream<List<ChatModel>> getChat(String uid) {
    return dbInstance
        .collection('ChatRoom')
        .where('participants', arrayContains: uid)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => ChatModel.fromMap(doc)).toList(),
        );
  }

  Stream<List<MessageModel>> getMessages(String chatId) {
    return dbInstance
        .collection('ChatRoom')
        .doc(chatId)
        .collection('Messages')
        .orderBy('sentAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) => MessageModel.fromMap(doc)).toList();
        });
  }
}
