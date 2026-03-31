import 'dart:async';

import 'package:chat_application/models/chatModel.dart';
import 'package:chat_application/models/messageModel.dart';
import 'package:chat_application/services/authServices.dart';
import 'package:chat_application/services/chatServices.dart';
import 'package:chat_application/services/notificationServices.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class Chatprovider with ChangeNotifier {
  final dbInstance = FirebaseFirestore.instance;
  Chatservices chatservices = Chatservices();
  Authservices authservices = Authservices();
  FocusNode focusNode = FocusNode();
  bool _isTyping = false;
  bool get isTyping => _isTyping;
  String? _typingReceiverId;
  StreamSubscription<bool>? listenToType;

  Future<bool> deleteChat(String chatId) async {
    return chatservices.deleteChat(chatId);
  }

  bool isTypingrecieve = false;
  void listenToTyping(String uid) async {
    listenToType = authservices.listenToType(uid).listen((value) {
      isTypingrecieve = value;
      notifyListeners();
    });
  }

  void setTyping(String receiverId) {
    _typingReceiverId = receiverId;
  }

  set isTyping(bool value) {
    if (_isTyping == value) {
      return;
    } else {
      _isTyping = value;
      notifyListeners();
      final uid = FirebaseAuth.instance.currentUser?.uid ?? '';
      if (uid.isNotEmpty) {
        // Update our own typing status under our UID
        authservices.setToType(uid, isTyping);
      }
    }
  }

  void onFocusChange() {
    if (!focusNode.hasFocus && _isTyping) {
      isTyping = false; // use setter → triggers setToType in Firebase
    }
  }

  void onTextChange(String text) {
    final shouldBeTyping = text.trim().isNotEmpty;
    if (_isTyping != shouldBeTyping) {
      isTyping = shouldBeTyping; // use setter → triggers setToType in Firebase
    }
  }

  Map<String, dynamic>? status;
  StreamSubscription? statusStream;

  void listenToUserStatus(String otherUserid) {
    statusStream?.cancel();
    statusStream = authservices
        .listenUserStatus(otherUserid)
        .listen(
          (statuses) {
            status = statuses;
            if (status != null) {
              try {
                // Added safe print, because if user node doesn't exist it would crash on !
                print("USER STATUS  : ${status!['status']}");
              } catch (e) {
                print(e.toString());
              }
            }
            notifyListeners();
          },
          onError: (error) {
            print("Realtime DB Stream Error: $error");
            status = null;
            notifyListeners();
          },
        );
  }

  bool get isUserOnline {
    if (status == null) return false;
    // The Realtime DB node returns the user's fields directly.
    return status!['status'] == 'Online';
  }

  Widget buildStatusIcon(String statusString) {
    switch (statusString) {
      case 'pending':
        return Icon(Icons.schedule, size: 16, color: Colors.grey);
      case 'sent':
        return Icon(Icons.check, size: 14, color: Colors.grey);
      case 'delivered':
        return Icon(Icons.done_all, size: 14, color: Colors.grey);
      case 'read':
        return Icon(Icons.done_all, size: 14, color: Colors.blue);
      case 'failed':
        return Icon(Icons.error, size: 14, color: Colors.red);
      default:
        return SizedBox();
    }
  }

  DocumentSnapshot? doc;
  String? senderNames;
  String? receiverToken;

  Chatprovider() {
    _init();
  }

  void _init() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        _chatStream?.cancel();
        _messageStream?.cancel();
        chats = [];
        _messages = [];
        senderNames = null;
        receiverToken = null;
        notifyListeners();
      }
    });
  }

  Future<void> setCurrentandOtherUser() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    doc = await FirebaseFirestore.instance.collection('Users').doc(uid).get();
    Map data = doc!.data() as Map<String, dynamic>;
    senderNames = data['name'];
  }

  Messagingservices messagingservices = Messagingservices();
  List<ChatModel> chats = [];
  List<MessageModel> _messages = [];

  List<MessageModel> get messages => _messages;

  final Chatservices _chatservices = Chatservices();
  StreamSubscription<List<ChatModel>>? _chatStream;
  StreamSubscription<List<MessageModel>>? _messageStream;

  Future<void> startChat(String receiverId, String messageText) async {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    if (currentUserId == null) return;

    final chatId = await _chatservices.generateChatId(receiverId);

    // 1. Create temporary optimistic message
    final optimisticMessage = MessageModel(
      documentId: 'temp_${DateTime.now().millisecondsSinceEpoch}',
      senderId: currentUserId,
      message: messageText,
      sentAt: DateTime.now(),
      status: 'pending',
    );

    _messages.insert(0, optimisticMessage);
    notifyListeners();

    try {
      // Check if we already have this chat in our list to decide between startChat and sendMessage
      bool chatExists = chats.any((c) => c.documentId == chatId);

      String messageId;
      if (chatExists) {
        messageId = await _chatservices.sendMessage(
          receiverId: receiverId,
          message: messageText,
        );
      } else {
        messageId = await _chatservices.startChat(receiverId, messageText);
      }

      // 2. Update status based on notification success
      final notificationSent = await sendNotification(messageText, receiverId);
      if (notificationSent) {
        await _chatservices.updateMessageStatus(chatId, messageId, 'delivered');
        print('Delivered BY FCM AND RAILWAY');
      } else {
        await _chatservices.updateMessageStatus(chatId, messageId, 'sent');
      }
    } catch (e) {
      debugPrint("Error sending message: $e");
      // Optionally handle failure status here
    } finally {
      // Remove optimistic message - the stream listener will bring in the real one
      _messages.removeWhere(
        (m) => m.documentId == optimisticMessage.documentId,
      );
      notifyListeners();
    }
  }

  Future<void> markAsRead(String receiverId) async {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    if (currentUserId == null) return;
    final chatId = await _chatservices.generateChatId(receiverId);
    await _chatservices.markMessagesAsRead(chatId, currentUserId);
    print('MARKED AS READ CALLED');
  }

  Future<bool> sendNotification(String message, String receiverId) async {
    try {
      String senderName = senderNames ?? "New Message";
      String chatId = await _chatservices.generateChatId(receiverId);

      String? receiverToken;
      final doc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(receiverId)
          .get();
      if (doc.exists) {
        receiverToken = doc.data()?['token'];
        print("Reciever Token: $receiverToken");
      }

      if (receiverToken == null || receiverToken.isEmpty) {
        debugPrint("Receiver token not found");
        return false;
      }

      final response = await messagingservices.sendNotification(
        chatId: chatId,
        receiverId: FirebaseAuth.instance.currentUser?.uid ?? '',
        message: message,
        senderName: senderName,
        receiverToken: receiverToken,
      );
      return true;
    } catch (e) {
      debugPrint("Error sending notification: $e");
      return false;
    }
  }

  Future<void> chatListen() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    await _chatStream?.cancel();
    _chatStream = _chatservices
        .getChat(uid)
        .listen(
          (chatList) {
            chats = chatList;
            debugPrint('Provider: ${chats.length} chats synced from Firestore');
            chats.sort(
              (a, b) => b.lastMessageTime.compareTo(a.lastMessageTime),
            );
            for (var c in chats) {
              debugPrint('Chat: ${c.lastMessage} | Time: ${c.lastMessageTime}');
            }

            notifyListeners();
          },
          onError: (error) {
            debugPrint('Provider: Error loading chats: $error');
          },
        );
  }

  Future<void> listenToMessages(String receiverId) async {
    final chatId = await _chatservices.generateChatId(receiverId);
    await _messageStream?.cancel();
    _messages = []; // Clear current messages when switching chats
    _messageStream = _chatservices
        .getMessages(chatId)
        .listen(
          (newMessages) {
            _messages = newMessages;
            debugPrint(
              'Provider: ${_messages.length} messages synced for $chatId',
            );

            // Auto mark as read if the current message is from the other user and not yet read
            final hasUnread = _messages.any(
              (m) =>
                  m.senderId != FirebaseAuth.instance.currentUser?.uid &&
                  m.status != 'read',
            );
            if (hasUnread) {
              _chatservices.markMessagesAsRead(
                chatId,
                FirebaseAuth.instance.currentUser?.uid ?? '',
              );
            }

            notifyListeners();
          },
          onError: (error) {
            debugPrint('Provider: Error loading messages: $error');
          },
        );
  }

  void stopListeningToMessages() {
    _messageStream?.cancel();
    statusStream?.cancel();
    listenToType?.cancel();
    statusStream = null;
    _messageStream = null;
    listenToType = null;
    _messages = [];
    status = null;
    isTypingrecieve = false;
  }

  @override
  void dispose() {
    focusNode.dispose();
    _chatStream?.cancel();
    _messageStream?.cancel();
    super.dispose();
  }

  void clear() {
    _chatStream?.cancel();
    _messageStream?.cancel();
    _chatStream = null;
    _messageStream = null;
    chats = [];
    _messages = [];
    senderNames = null;
    receiverToken = null;
    notifyListeners();
  }
}

enum MessageStatus {
  pending, // value 1
  delivered, // value 2
  failed, // value 3
  read, // value 4
}
