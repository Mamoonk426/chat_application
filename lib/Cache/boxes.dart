import 'package:chat_application/Cache/chat_model.dart';
import 'package:hive/hive.dart';

class Boxes {
  Box<HiveChatModel> get chatsBox => Hive.box<HiveChatModel>('chats_box');
}
