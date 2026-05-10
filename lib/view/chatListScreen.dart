import 'package:chat_application/components/Toasts.dart';
import 'package:chat_application/components/chatTile.dart';
import 'package:chat_application/components/customFormField.dart';
import 'package:chat_application/providers/chatProvider.dart';
import 'package:chat_application/providers/userProvider.dart';
import 'package:chat_application/themes/app_theme.dart';
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
  final TextEditingController searchController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isLoaded) {
      final chat = Provider.of<Chatprovider>(context, listen: false);
      chat.chatListen();
      Provider.of<Userprovider>(context, listen: false).setUserStatus();
      chat.listenToUnreadCounts();
      _isLoaded = true;
    }
  }

  String _otherUserName(Map<String, String> participantNames) {
    final currentUid =
        Provider.of<Userprovider>(context, listen: false).currentUser?.id ?? '';
    for (final entry in participantNames.entries) {
      if (entry.key != currentUid) return entry.value;
    }
    return '';
  }

  String _otherUserId(List<String> participants) {
    final currentUid =
        Provider.of<Userprovider>(context, listen: false).currentUser?.id ?? '';
    for (final uid in participants) {
      if (uid != currentUid) return uid;
    }
    return '';
  }

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
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await chatProvider.deleteChat(chatId);
      Toasts.successToast('Deleted Chat Successfully', context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final chat = Provider.of<Chatprovider>(context);
    return Scaffold(
      extendBody: true,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [colorScheme.surface, colorScheme.surface.withOpacity(0.8)],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Messages',
                          style: AppTextStyles.headlineLarge.copyWith(
                            color: colorScheme.onSurface,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          'Keep in touch with everyone',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: colorScheme.onSurface.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.add_rounded,
                          color: colorScheme.primary,
                          size: 28,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Addchatscreen(),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                child: Customformfield(
                  onChanged: (value) {
                    chat.setQuery(value ?? '');
                    chat.setChats();
                  },
                  prefix: const Icon(
                    Icons.search_rounded,
                    color: AppColors.grey400,
                  ),
                  title: 'Search your conversations...',
                  controller: searchController,
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: chat.ischatloading
                    ? Center(
                        child: CircularProgressIndicator(
                          color: colorScheme.primary,
                        ),
                      )
                    : chat.chats.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.chat_bubble_outline_rounded,
                              size: 80,
                              color: colorScheme.onSurface.withOpacity(0.1),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No conversations yet',
                              style: AppTextStyles.titleMedium.copyWith(
                                color: colorScheme.onSurface.withOpacity(0.4),
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(12, 0, 12, 100),
                        itemCount: chat.chats.length,
                        itemBuilder: (context, index) {
                          final chatItem = chat.chats[index];
                          final otherName = _otherUserName(
                            chatItem.participantNames,
                          );
                          final otherId = _otherUserId(chatItem.participants);

                          return ChatTile(
                            receiverId: otherId,
                            unreadCounts:
                                chat.chatsUnreadCounts[chatItem
                                    .documentId]?[chat.currentUserId],
                            onLongPress: () {
                              print(chat.currentUserId);
                              chat.listenToUnreadCounts();
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
