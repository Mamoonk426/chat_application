import 'package:chat_application/components/Toasts.dart';
import 'package:chat_application/components/chatTile.dart';
import 'package:chat_application/components/customFormField.dart';
import 'package:chat_application/providers/chatProvider.dart';
import 'package:chat_application/providers/userProvider.dart';
import 'package:chat_application/view/addChatScreen.dart';
import 'package:chat_application/view/chatScreen.dart';
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
      Provider.of<Userprovider>(context, listen: false).setUserStatus();
      _isLoaded = true;
    }
  }

  /// Returns the display name of the other participant in the chat.
  String _otherUserName(Map<String, String> participantNames) {
    final currentUid =
        Provider.of<Userprovider>(context, listen: false).currentUser?.id ?? '';
    for (final entry in participantNames.entries) {
      if (entry.key != currentUid) return entry.value;
    }
    return '';
  }

  /// Returns the UID of the other participant.
  String _otherUserId(List<String> participants) {
    final currentUid =
        Provider.of<Userprovider>(context, listen: false).currentUser?.id ?? '';
    for (final uid in participants) {
      if (uid != currentUid) return uid;
    }
    return '';
  }

  /// Shows a confirmation dialog before deleting a chat.
  Future<void> _showDeleteConfirmationDialog(
    BuildContext context,
    Chatprovider chatProvider,
    String chatId,
    String otherName,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Chat'),
        content: Text(
          'Are you sure you want to delete your chat with $otherName? This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final success = await chatProvider.deleteChat(chatId);
      Toasts.successToast('Deleted Chat Successfully', context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final chat = Provider.of<Chatprovider>(context);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Messages',
                      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.5,
                          ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: Icon(Icons.edit_square, color: Theme.of(context).colorScheme.primary),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const Addchatscreen()),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
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
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/Images/emptychatlist.jpg',
                              height: 200,
                            ),
                            const SizedBox(height: 20),
                            Text(
                              'No Chats Found',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.only(bottom: 100),
                        itemCount: chat.chats.length,
                        itemBuilder: (context, index) {
                          final chatItem = chat.chats[index];
                          final otherName = _otherUserName(
                            chatItem.participantNames,
                          );
                          final otherId = _otherUserId(chatItem.participants);

                          return ChatTile(
                            onLongPress: () {
                              _showDeleteConfirmationDialog(
                                context,
                                chat,
                                chatItem.documentId,
                                otherName,
                              );
                            },
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
