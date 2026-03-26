import 'dart:async';

import 'package:chat_application/models/chatModel.dart';
import 'package:chat_application/models/messageModel.dart';
import 'package:chat_application/services/chatServices.dart';
import 'package:chat_application/services/notificationServices.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Chatprovider with ChangeNotifier {
  Messagingservices messagingservices = Messagingservices();
  List<ChatModel> chats = [];
  List<MessageModel> _messages = [];

  List<MessageModel> get messages => _messages;

  final Chatservices _chatservices = Chatservices();
  StreamSubscription<List<ChatModel>>? _chatStream;
  StreamSubscription<List<MessageModel>>? _messageStream;

  Future<void> startChat(String receiverId, String message) async {
    try {
      await _chatservices.startChat(receiverId, message);
    } catch (e) {
      debugPrint('Error starting chat: $e');
    }
  }

  Future<void> sendNotification(
    String chatId,
    String message,
    String senderName,
    String receiverToken,
    String receiverId,
  ) async {
    await messagingservices.sendNotification(
      chatId: chatId,
      receiverId: receiverId,
      message: message,
      senderName: senderName,
      receiverToken: receiverToken,
    );
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
            notifyListeners();
          },
          onError: (error) {
            debugPrint('Provider: Error loading messages: $error');
          },
        );
  }

  @override
  void dispose() {
    _chatStream?.cancel();
    _messageStream?.cancel();
    super.dispose();
  }
}
