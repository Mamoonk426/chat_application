import 'dart:async';

import 'package:chat_application/Cache/failed_message_model.dart';
import 'package:chat_application/Cache/message_model.dart';
import 'package:chat_application/models/chatModel.dart';
import 'package:chat_application/models/messageModel.dart';
import 'package:chat_application/services/authServices.dart';
import 'package:chat_application/services/cacheservices.dart';
import 'package:chat_application/services/chatServices.dart';
import 'package:chat_application/services/notificationServices.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Chatprovider with ChangeNotifier {
  final dbInstance = FirebaseFirestore.instance;
  Chatservices chatservices = Chatservices();
  Authservices authservices = Authservices();
  Cacheservices cacheservices = Cacheservices();
  FocusNode focusNode = FocusNode();
  bool _isTyping = false;
  bool get isTyping => _isTyping;
  bool _isloading = false;
  bool get isloading => _isloading;
  bool _ischatloading = false;
  bool get ischatloading => _ischatloading;
  String? _searchQuery;
  String? get searchQuery => _searchQuery;
  StreamSubscription<bool>? listenToType;
  List<ChatModel> SyncedChats = [];

  Future<bool> deleteChat(String chatId) async {
    return chatservices.deleteChat(chatId);
  }

  void setQuery(String query) {
    _searchQuery = query;
    setChats();
    notifyListeners();
  }

  String extractRecieverName(
    Map<String, dynamic> participantsNameMap,
    List<String> participantsUids,
  ) {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid ?? "";
    final otherUserid = participantsUids.firstWhere((p) => p != currentUserId);
    final recieverName = participantsNameMap[otherUserid];
    return recieverName;
  }

  void setChats() {
    final userId = FirebaseAuth.instance.currentUser!.uid ?? '';
    if ((searchQuery ?? '').isEmpty) {
      chats = List.from(SyncedChats);
      notifyListeners();
      print(chats);
    } else {
      chats =
          SyncedChats.where((filterChats) {
            return extractRecieverName(
              filterChats.participantNames,
              filterChats.participants,
            ).toLowerCase().contains((searchQuery ?? '').toLowerCase());
          }).toList()..sort((a, b) {
            return b.lastMessageTime.compareTo(a.lastMessageTime);
          });
      notifyListeners();
    }
  }

  Future<void> deleteMessage(String receiverId, String messageId) async {
    final chatId = await chatservices.generateChatId(receiverId);
    await chatservices.deleteMessage(chatId, messageId);

    // Also remove from local _messages to reflect immediately if needed
    _messages.removeWhere((m) => m.documentId == messageId);
    notifyListeners();
  }

  bool isTypingrecieve = false;
  void listenToTyping(String uid) async {
    listenToType = authservices.listenToType(uid).listen((value) {
      isTypingrecieve = value;
      notifyListeners();
    });
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
        messageId = await _chatservices
            .sendMessage(receiverId: receiverId, message: messageText)
            .timeout(
              Duration(seconds: 10),
              onTimeout: () {
                cacheservices.cacheFailedMessages(
                  chatRoomid: chatId,
                  message: HiveFailedMessageModel.fromMessageModel(
                    message: optimisticMessage,
                    chatRoomId: chatId,
                    receiverId: receiverId,
                  ),
                );
                throw TimeoutException('Failed To Send Message ');
              },
            );
      } else {
        messageId = await _chatservices
            .startChat(receiverId, messageText)
            .timeout(
              Duration(seconds: 10),
              onTimeout: () {
                cacheservices.cacheFailedMessages(
                  chatRoomid: chatId,
                  message: HiveFailedMessageModel.fromMessageModel(
                    message: optimisticMessage,
                    chatRoomId: chatId,
                    receiverId: receiverId,
                  ),
                );
                throw TimeoutException('Failed to Send Message');
              },
            );
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

      await messagingservices.sendNotification(
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
    _ischatloading = true;
    notifyListeners();
    _chatStream = _chatservices
        .getChat(uid)
        .listen(
          (chatList) {
            SyncedChats = chatList;
            debugPrint('Provider: ${chats.length} chats synced from Firestore');
            SyncedChats.sort(
              (a, b) => b.lastMessageTime.compareTo(a.lastMessageTime),
            );
            setChats();
            _ischatloading = false;
            notifyListeners();
          },
          onError: (error) {
            debugPrint('Provider: Error loading chats: $error');
            _ischatloading = false;
            notifyListeners();
          },
        );
  }

  Future<void> listenToMessages(String receiverId) async {
    final chatId = await _chatservices.generateChatId(receiverId);
    await _messageStream?.cancel();
    _isloading = true;
    _messages = []; // Clear current messages when switching chats
    notifyListeners();
    await Future.delayed(Duration(seconds: 2));
    final cachemessages = await cacheservices.getmessages(chatId);
    if (cachemessages.isNotEmpty) {
      _messages = cachemessages
          .map(
            (m) => MessageModel(
              documentId: m.id,
              senderId: m.senderId,
              message: m.text,
              sentAt: m.timestamp,
              status: m.status,
            ),
          )
          .toList();
      chats.sort((a, b) {
        return a.lastMessageTime.compareTo(b.lastMessageTime);
      });
      debugPrint(
        'Loaded ${_messages.length} messages from cache for chat $chatId',
      );
    }

    _messageStream = _chatservices
        .getMessages(chatId)
        .listen(
          (newMessages) {
            _messages = newMessages;
            final cachedIds = _messages.map((m) => m.documentId).toSet();
            for (final msg in newMessages) {
              if (!cachedIds.contains(msg.documentId)) {
                cacheservices.cacheMessages(
                  chatId,
                  HiveMessageModel.fromchat(msg),
                );
              }
            }
            _isloading = false;
            notifyListeners();
            debugPrint(
              'Provider: ${_messages.length} messages synced for $chatId',
            );
            _isloading = false;
            notifyListeners();

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
