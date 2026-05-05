import 'package:chat_application/models/chatModel.dart';
import 'package:chat_application/models/messageModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Chatservices {
  final dbInstance = FirebaseFirestore.instance;

  Future<String> generateChatId(String recieverId) async {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    if (currentUserId == null) return '';

    if (recieverId.toLowerCase().compareTo(currentUserId.toLowerCase()) > 0) {
      return '${recieverId}_$currentUserId';
    } else {
      return '${currentUserId}_$recieverId';
    }
  }

  Future<String> sendMessage({
    required String receiverId,
    required String message,
  }) async {
    final chatId = await generateChatId(receiverId);
    final senderId = FirebaseAuth.instance.currentUser!.uid.toString();

    final chatRef = dbInstance.collection('ChatRoom').doc(chatId);
    final messageRef = chatRef.collection('Messages');

    final newMessage = MessageModel(
      documentId: '',
      senderId: senderId,
      message: message,
      sentAt: DateTime.now(),
      status: 'pending',
    );

    final batch = dbInstance.batch();
    final messageDoc = messageRef.doc();

    batch.set(chatRef, {
      'lastMessage': newMessage.toMap(),
      'lastMessageTime': Timestamp.fromDate(newMessage.sentAt),
      'lastMessageSenderId': newMessage.senderId,
      'participants': FieldValue.arrayUnion([receiverId, senderId]),
    }, SetOptions(merge: true));

    batch.set(messageDoc, newMessage.toMap());

    await batch.commit();
    return messageDoc.id;
  }

  Future<String> startChat(String recieverId, String message) async {
    final chatId = await generateChatId(recieverId);
    final senderId = FirebaseAuth.instance.currentUser!.uid.toString();

    // Fetch display names only when starting a new chat or ensuring they exist
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
      status: 'pending',
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
    return messageDoc.id;
  }

  Future<void> updateMessageStatus(
    String chatId,
    String messageId,
    String status,
  ) async {
    await dbInstance
        .collection('ChatRoom')
        .doc(chatId)
        .collection('Messages')
        .doc(messageId)
        .update({'status': status});
  }

  Future<void> markMessagesAsRead(String chatId, String currentUserId) async {
    if (currentUserId.isEmpty) return;

    final messages = await dbInstance
        .collection('ChatRoom')
        .doc(chatId)
        .collection('Messages')
        .where('status', isNotEqualTo: 'read')
        .get();

    if (messages.docs.isEmpty) return;

    final batch = dbInstance.batch();
    bool hasUpdate = false;

    print(
      "DEBUG: Processing ${messages.docs.length} unread messages for $chatId",
    );
    print("DEBUG: currentUserId: '$currentUserId'");

    for (var doc in messages.docs) {
      final msgData = doc.data();
      final senderId = msgData['senderId']?.toString() ?? '';

      // LOGIC: Only mark as read if WE are the receiver (sender is NOT currentUserId)
      if (senderId != currentUserId) {
        batch.update(doc.reference, {'status': 'read'});
        hasUpdate = true;
        print("DEBUG: Marking message ${doc.id} as read. (Sender: $senderId)");
      } else {
        print(
          "DEBUG: Skipping message ${doc.id} as it was sent by current user ($senderId)",
        );
      }
    }

    if (hasUpdate) {
      await batch.commit();
      print("DEBUG: MARKED AS READ batch committed");
    }
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

  Future<bool> deleteChat(String chatId) async {
    final chatRef = dbInstance.collection('ChatRoom').doc(chatId);
    final messagesRef = chatRef.collection('Messages');
    // 1. Fetch all messages in the sub-collection
    final messages = await messagesRef.get();
    final batch = dbInstance.batch();
    // 2. Delete each message document
    for (var doc in messages.docs) {
      batch.delete(doc.reference);
    }
    // 3. Delete the parent ChatRoom document
    batch.delete(chatRef);
    // 4. Commit the batch
    await batch.commit();
    return true;
  }

  Future<void> deleteMessage(String chatId, String messageId) async {
    await dbInstance
        .collection('ChatRoom')
        .doc(chatId)
        .collection('Messages')
        .doc(messageId)
        .delete();
  }
}
