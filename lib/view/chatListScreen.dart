import 'package:chat_application/components/chatTile.dart';
import 'package:chat_application/components/customFormField.dart';
import 'package:chat_application/providers/chatProvider.dart';
import 'package:chat_application/view/addChatScreen.dart';
import 'package:chat_application/view/chatScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Chatlistscreen extends StatefulWidget {
  const Chatlistscreen({super.key});

  @override
  State<Chatlistscreen> createState() => _ChatscreenState();
}

class _ChatscreenState extends State<Chatlistscreen> {
  bool _isLoaded = false;
  TextEditingController searchController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isLoaded) {
      final chat = Provider.of<Chatprovider>(context, listen: false);
      chat.chatListen();
      _isLoaded = true;
    }
  }

  /// Returns the display name of the other participant in the chat.
  String _otherUserName(Map<String, String> participantNames) {
    final currentUid = FirebaseAuth.instance.currentUser?.uid ?? '';
    for (final entry in participantNames.entries) {
      if (entry.key != currentUid) return entry.value;
    }
    return '';
  }

  /// Returns the UID of the other participant.
  String _otherUserId(List<String> participants) {
    final currentUid = FirebaseAuth.instance.currentUser?.uid ?? '';
    for (final uid in participants) {
      if (uid != currentUid) return uid;
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    final chat = Provider.of<Chatprovider>(context);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Addchatscreen()),
          );
        },
        child: Icon(Icons.add),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(left: 10, right: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Chats', style: Theme.of(context).textTheme.headlineLarge),
              SizedBox(height: 10),
              Customformfield(
                suffixImage: IconButton(
                  onPressed: () async {},
                  icon: ImageIcon(AssetImage('assets/icons/Magnifier.png')),
                ),
                title: 'Search Your Chats',
                controller: searchController,
              ),
              SizedBox(height: 10),
              Expanded(
                child: chat.chats.isEmpty
                    ? Center(child: Text('No Chat Found'))
                    : ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: chat.chats.length,
                        itemBuilder: (context, index) {
                          final chatItem = chat.chats[index];
                          final otherName = _otherUserName(
                            chatItem.participantNames,
                          );
                          final otherId = _otherUserId(chatItem.participants);
                          return ChatTile(
                            receiverName: otherName,
                            lastMessage: chatItem.lastMessage,
                            lastMessageTime: chatItem.lastMessageTime,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      Chatscreen(id: otherId, name: otherName),
                                ),
                              );
                            },
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
