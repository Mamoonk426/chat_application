import 'package:chat_application/Cache/boxes.dart';
import 'package:chat_application/Cache/chat_model.dart';
import 'package:chat_application/Cache/failed_message_model.dart';
import 'package:chat_application/Cache/message_model.dart';
import 'package:chat_application/models/messageModel.dart';
import 'package:chat_application/services/chatServices.dart';
import 'package:chat_application/services/notificationServices.dart';
import 'package:hive/hive.dart';

class Cacheservices {
  static const String _failedMessagesBox = 'failedMessages';
  static const String _boxPrefix = 'box';
  static const String _messageboxPrefix = 'messages_';
  Future<Box<HiveChatModel>> openBox(String boxname) async {
    if (Hive.isBoxOpen(boxname)) {
      print("Box is Already Opened");
      return Hive.box<HiveChatModel>(boxname);
    } else {
      print("Opened Box");
      return await Hive.openBox<HiveChatModel>(boxname);
    }
  }

  Future<Box<HiveMessageModel>> _msgbox(String chatRoomid) async {
    final name = '$chatRoomid$_messageboxPrefix';

    if (Hive.isBoxOpen(name)) {
      return Hive.box<HiveMessageModel>(name);
    }
    return await Hive.openBox<HiveMessageModel>(name);
  }

  Future<void> cacheChatDoc(HiveChatModel chat) async {
    final box = await openBox('chats_box');
    await box.put(chat.documentId, chat);
  }

  Future<void> cacheMessages(
    String chatRoomid,
    HiveMessageModel messages,
  ) async {
    final box = await _msgbox(chatRoomid);
    await box.put(messages.id, messages);
  }

  Future<List<HiveChatModel>> getAllchats() async {
    final box = await openBox('chats_box');
    final chats = box.values.toList();
    chats.sort((a, b) => a.lastMessageTime.compareTo(b.lastMessageTime));
    return chats;
  }

  Future<List<HiveMessageModel>> getmessages(String chatRoomid) async {
    final box = await _msgbox(chatRoomid);
    final messages = box.values.toList();
    messages.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    return messages;
  }

  Future<void> cacheFailedMessages({
    required String chatRoomid,
    required HiveFailedMessageModel message,
  }) async {
    final box = await Hive.openBox<HiveFailedMessageModel>('failedMessages');
    await box.putAll({chatRoomid: message});
    print("Failed Message Cached");
  }

  Future<void> deleteFailedMessages(String chatRoomId) async {
    final box = await Hive.openBox<HiveFailedMessageModel>(_failedMessagesBox);
    await box.delete(chatRoomId);
  }

  Future<void> deletemessage(String chatRoomid, String messageId) async {
    final box = await _msgbox(chatRoomid);
    await box.delete(messageId);
  }

  Future<List<HiveFailedMessageModel>> getFailedMessages() async {
    final box = await Hive.openBox<HiveFailedMessageModel>(_failedMessagesBox);
    final msges = box.values.toList();
    return msges;
  }

  Future<void> updateStatus(
    String status,
    String chatRoomid,
    String messageId,
  ) async {
    final box = await _msgbox(chatRoomid);
    final msg = box.get(messageId);
    if (msg != null) {
      msg.status = status;
    } else {
      return;
    }
  }

  Future<void> deleteChat(String chatRoomid) async {
    final box = await _msgbox(chatRoomid);
    await box.deleteFromDisk();
  }

  Future<void> closeBox(String chatRoomid) async {
    final name = _messageboxPrefix + chatRoomid;
    if (Hive.isBoxOpen(name)) {
      await Hive.box<MessageModel>(name).close();
    }
  }
}
