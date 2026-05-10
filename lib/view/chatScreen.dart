import 'package:chat_application/components/Toasts.dart';
import 'package:chat_application/components/sendButton.dart';
import 'package:chat_application/components/typingIndicator.dart';
import 'package:chat_application/providers/chatProvider.dart';
import 'package:chat_application/themes/app_theme.dart';
import 'package:chat_application/providers/userProvider.dart';
import 'package:chat_application/view/userInfoScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Chatscreen extends StatefulWidget {
  final String name;
  final String id;
  const Chatscreen({super.key, required this.id, required this.name});

  @override
  State<Chatscreen> createState() => _ChatscreenState();
}

class _ChatscreenState extends State<Chatscreen> {
  bool _isInitialized = false;
  final TextEditingController message = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool isTyping = false;
  late VoidCallback _onFocusChange;
  late VoidCallback _onTextChange;
  late Chatprovider _chatProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      _chatProvider = Provider.of<Chatprovider>(context, listen: false);
      _chatProvider.listenToMessages(widget.id);
      _chatProvider.listenToUnreadCounts();
      _chatProvider.setCurrentandOtherUser();
      _chatProvider.markAsRead(widget.id);
      _chatProvider.listenToUserStatus(widget.id);
      _onFocusChange = _chatProvider.onFocusChange;
      _onTextChange = () => _chatProvider.onTextChange(message.text);
      _chatProvider.focusNode.addListener(_onFocusChange);
      message.addListener(_onTextChange);
      _chatProvider.listenToTyping(widget.id);
      _isInitialized = true;
    }
  }

  @override
  void dispose() {
    _chatProvider.focusNode.removeListener(_onFocusChange);
    message.removeListener(_onTextChange);
    message.dispose();
    _scrollController.dispose();
    _chatProvider.stopListeningToMessages();
    super.dispose();
  }

  String _formatMessageTime(DateTime sentAt) {
    final hour = sentAt.hour % 12 == 0 ? 12 : sentAt.hour % 12;
    final minute = sentAt.minute.toString().padLeft(2, '0');
    final amPm = sentAt.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $amPm';
  }

  Future<void> _showDeleteMessageDialog(
    BuildContext context,
    Chatprovider chatProvider,
    String messageId,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Message'),
        content: const Text(
          'Are you sure you want to delete this message? This action cannot be undone.',
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
      await chatProvider.deleteMessage(widget.id, messageId);
      // Optional: show a toast or snackbar
      Toasts.successToast("Message Deleted Successfully", context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final chatTheme = Theme.of(context).extension<AppChatTheme>()!;
    final chatProvider = Provider.of<Chatprovider>(context);
    final colorScheme = Theme.of(context).colorScheme;
    final currentUserId = Provider.of<Userprovider>(
      context,
      listen: false,
    ).currentUser?.id;

    return Scaffold(
      extendBody: true,
      backgroundColor: chatTheme.chatBackground,
      body: Column(
        children: [
          // ── Header ──
          Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 8,
              left: 4,
              right: 12,
              bottom: 12,
            ),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
                  onPressed: () {
                    if (mounted) Navigator.pop(context);
                  },
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Userinfoscreen(userId: widget.id),
                      ),
                    );
                  },
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: colorScheme.primary.withOpacity(0.12),
                    child: Text(
                      widget.name.isNotEmpty
                          ? widget.name[0].toUpperCase()
                          : '?',
                      style: TextStyle(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.name,
                        style: AppTextStyles.titleMedium.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 1),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        transitionBuilder:
                            (Widget child, Animation<double> animation) {
                              return FadeTransition(
                                opacity: animation,
                                child: child,
                              );
                            },
                        child: Row(
                          key: ValueKey<bool>(chatProvider.isUserOnline),
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: chatProvider.isUserOnline
                                    ? Colors.green
                                    : colorScheme.onSurface.withValues(
                                        alpha: 0.3,
                                      ),
                                shape: BoxShape.circle,
                                boxShadow: chatProvider.isUserOnline
                                    ? [
                                        BoxShadow(
                                          color: Colors.green.withValues(
                                            alpha: 0.3,
                                          ),
                                          blurRadius: 4,
                                          spreadRadius: 1,
                                        ),
                                      ]
                                    : null,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              chatProvider.isUserOnline ? 'Online' : 'Offline',
                              style: Theme.of(context).textTheme.labelSmall
                                  ?.copyWith(
                                    color: chatProvider.isUserOnline
                                        ? AppColors.success
                                        : colorScheme.onSurface.withOpacity(
                                            0.5,
                                          ),
                                    fontWeight: chatProvider.isUserOnline
                                        ? FontWeight.w600
                                        : FontWeight.normal,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.call_outlined,
                    size: 20,
                    color: colorScheme.primary,
                  ),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(
                    Icons.videocam_outlined,
                    size: 22,
                    color: colorScheme.primary,
                  ),
                  onPressed: () {},
                ),
              ],
            ),
          ),

          // ── Body ──
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Column(
                children: [
                  // ── Messages List ──
                  Expanded(
                    child: chatProvider.isloading
                        ? Center(child: CircularProgressIndicator())
                        : chatProvider.messages.isEmpty
                        ? Center(
                            child: Text(
                              'No messages yet',
                              style: TextStyle(
                                color: colorScheme.onSurface.withValues(
                                  alpha: 0.4,
                                ),
                              ),
                            ),
                          )
                        : ListView.builder(
                            controller: _scrollController,
                            reverse: true, // Show latest at bottom
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 20,
                            ),
                            itemCount: chatProvider.messages.length,
                            itemBuilder: (context, index) {
                              final msg = chatProvider.messages[index];
                              final isMe = msg.senderId == currentUserId;

                              return GestureDetector(
                                onLongPress: () {
                                  _showDeleteMessageDialog(
                                    context,
                                    chatProvider,
                                    msg.documentId,
                                  );
                                },
                                child: Align(
                                  alignment: isMe
                                      ? Alignment.centerRight
                                      : Alignment.centerLeft,
                                  child: Container(
                                    margin: const EdgeInsets.only(bottom: 8),
                                    constraints: BoxConstraints(
                                      maxWidth:
                                          MediaQuery.of(context).size.width *
                                          0.75,
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      gradient: isMe
                                          ? LinearGradient(
                                              colors: [
                                                colorScheme.primary,
                                                colorScheme.primary.withOpacity(
                                                  0.8,
                                                ),
                                              ],
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                            )
                                          : null,
                                      color: isMe
                                          ? null
                                          : chatTheme.bubbleReceived,
                                      borderRadius: BorderRadius.only(
                                        topLeft: const Radius.circular(20),
                                        topRight: const Radius.circular(20),
                                        bottomLeft: isMe
                                            ? const Radius.circular(20)
                                            : const Radius.circular(4),
                                        bottomRight: isMe
                                            ? const Radius.circular(4)
                                            : const Radius.circular(20),
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: isMe
                                              ? colorScheme.primary.withOpacity(
                                                  0.2,
                                                )
                                              : Colors.black.withOpacity(0.03),
                                          blurRadius: 8,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          msg.message,
                                          style: TextStyle(
                                            color: isMe
                                                ? chatTheme.bubbleSentText
                                                : chatTheme.bubbleReceivedText,
                                            fontSize: 15,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        SizedBox(
                                          width: 63,
                                          child: Row(
                                            children: [
                                              Text(
                                                _formatMessageTime(msg.sentAt),
                                                style: TextStyle(
                                                  color:
                                                      (isMe
                                                              ? chatTheme
                                                                    .bubbleSentText
                                                              : chatTheme
                                                                    .bubbleReceivedText)
                                                          .withValues(
                                                            alpha: 0.6,
                                                          ),
                                                  fontSize: 10,
                                                ),
                                              ),
                                              SizedBox(width: 5),
                                              isMe
                                                  ? chatProvider
                                                        .buildStatusIcon(
                                                          msg.status.toString(),
                                                        )
                                                  : SizedBox.shrink(),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    transitionBuilder: (child, animation) {
                      return FadeTransition(
                        opacity: animation,
                        child: SlideTransition(
                          position:
                              Tween<Offset>(
                                begin: const Offset(0, 0.3),
                                end: Offset.zero,
                              ).animate(
                                CurvedAnimation(
                                  parent: animation,
                                  curve: Curves.easeOut,
                                ),
                              ),
                          child: child,
                        ),
                      );
                    },
                    child: chatProvider.isTypingrecieve
                        ? const Align(
                            key: ValueKey('typing'),
                            alignment: Alignment.bottomLeft,
                            child: Typingindicator(),
                          )
                        : const SizedBox.shrink(key: ValueKey('empty')),
                  ),

                  // ── Input Bar ──
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: colorScheme.surface,
                              borderRadius: BorderRadius.circular(25),
                              boxShadow: [
                                BoxShadow(
                                  color: colorScheme.shadow.withValues(
                                    alpha: 0.05,
                                  ),
                                  blurRadius: 10,
                                  offset: const Offset(0, -2),
                                ),
                              ],
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const SizedBox(width: 8),
                                IconButton(
                                  icon: Icon(
                                    Icons.emoji_emotions_outlined,
                                    color: colorScheme.primary,
                                  ),
                                  onPressed: () {},
                                ),
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: BorderRadiusGeometry.circular(
                                      15,
                                    ),
                                    child: TextField(
                                      focusNode: chatProvider.focusNode,
                                      controller: message,
                                      decoration: const InputDecoration(
                                        hintText: '     Type a message...',
                                        border: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        contentPadding: EdgeInsets.symmetric(
                                          vertical: 12,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.attach_file,
                                    color: colorScheme.primary,
                                  ),
                                  onPressed: () {},
                                ),
                                const SizedBox(width: 8),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: colorScheme.primary,
                            shape: BoxShape.circle,
                          ),
                          child: Sendbutton(
                            send: () async {
                              if (message.text.trim().isEmpty) return;

                              String messageText = message.text.trim();
                              // Clear immediately for optimistic experience
                              message.clear();
                              // Provider handles the optimistic update and background Firestore write
                              chatProvider.startChat(widget.id, messageText);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
