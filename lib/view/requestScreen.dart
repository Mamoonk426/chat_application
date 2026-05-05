import 'package:chat_application/components/requestTile.dart';
import 'package:chat_application/themes/app_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chat_application/providers/addChatProvider.dart';
import 'package:chat_application/providers/requestProvider.dart';
import 'package:chat_application/view/chatScreen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Requestscreen extends StatefulWidget {
  const Requestscreen({super.key});

  @override
  State<Requestscreen> createState() => _RequestscreenState();
}

class _RequestscreenState extends State<Requestscreen> {
  bool _isLoaded = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isLoaded) {
      _isLoaded = true;
      final requestProvider = Provider.of<Requestprovider>(
        context,
        listen: false,
      );
      requestProvider.listenTorecieveRequest();
    }
  }

  String _formatTime(DateTime? dateTime) {
    if (dateTime == null) return '';
    return DateFormat('MMM d, h:mm a').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    final request = Provider.of<Requestprovider>(context);
    final chat = Provider.of<addChatprovider>(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              colorScheme.surface,
              colorScheme.surface.withOpacity(0.8),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                // ── Header ──
                Text(
                  'Social',
                  style: AppTextStyles.headlineLarge.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  'Manage your connections',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
                const SizedBox(height: 24),

                // ── Main Section Toggle ──
                SizedBox(
                  width: double.infinity,
                  child: SegmentedButton<bool>(
                    style: SegmentedButton.styleFrom(
                      backgroundColor: colorScheme.surfaceContainerHighest.withOpacity(0.5),
                      selectedBackgroundColor: colorScheme.primary,
                      selectedForegroundColor: colorScheme.onPrimary,
                      side: BorderSide.none,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    segments: const [
                      ButtonSegment<bool>(
                        value: false,
                        label: Text('Requests'),
                        icon: Icon(Icons.people_outline_rounded, size: 18),
                      ),
                      ButtonSegment<bool>(
                        value: true,
                        label: Text('Friends'),
                        icon: Icon(Icons.person_rounded, size: 18),
                      ),
                    ],
                    selected: {request.isFriendsTab},
                    onSelectionChanged: (selected) {
                      request.toggleMainTab(selected.first);
                    },
                  ),
                ),
                const SizedBox(height: 24),

                // ── Content ──
                Expanded(
                  child: request.isFriendsTab
                      ? _buildFriendsList(request, chat, colorScheme)
                      : _buildRequestsSection(request, chat, colorScheme),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRequestsSection(
    Requestprovider request,
    addChatprovider chat,
    ColorScheme colorScheme,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          children: List.generate(request.chips.length, (index) {
            final chip = request.chips.toList()[index];
            final isSelected = request.selectedchips.contains(chip);
            return FilterChip(
              selected: isSelected,
              selectedColor: colorScheme.primaryContainer,
              checkmarkColor: colorScheme.primary,
              label: Text(chip),
              onSelected: (c) {
                if (!isSelected) {
                  request.toggleChip(chip);
                }
              },
            );
          }),
        ),
        const SizedBox(height: 8),
        const Divider(),
        Expanded(
          child: Builder(
            builder: (context) {
              final data = request.getFilteredRequests();
              if (data.isEmpty) {
                return _buildEmptyState(
                  icon: request.isSentSelected
                      ? Icons.send_rounded
                      : Icons.inbox_rounded,
                  label: request.isSentSelected
                      ? 'No sent requests'
                      : 'No requests received',
                  colorScheme: colorScheme,
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.only(top: 8),
                itemCount: data.length,
                itemBuilder: (context, index) {
                  final item = data[index];
                  final otherId = request.isSentSelected
                      ? item.receiverId
                      : item.senderId;
                  final displayName =
                      request.currentNamesMap[otherId] ??
                      (request.isSentSelected
                          ? item.receiverName
                          : item.senderName);

                  return Requesttile(
                    isSentRequest: request.isSentSelected,
                    statusLabel: item.status,
                    isAccepted: item.status == 'Accepted',
                    startChat: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              Chatscreen(id: otherId, name: displayName),
                        ),
                      );
                    },
                    confirmCall: () async {
                      await request.acceptRequest(item.requestId, context);
                    },
                    title: displayName,
                    trailing: _formatTime(item.createdAt),
                    leading: chat.extracting(displayName),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFriendsList(
    Requestprovider request,
    addChatprovider chat,
    ColorScheme colorScheme,
  ) {
    final friends = request.friends;
    if (friends.isEmpty) {
      return _buildEmptyState(
        icon: Icons.person_off_outlined,
        label: 'No friends yet',
        colorScheme: colorScheme,
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.only(top: 8),
      itemCount: friends.length,
      itemBuilder: (context, index) {
        final friend = friends[index];
        final friendName = friend['name'] as String? ?? 'Friend';
        final friendId = friend['id'] as String;

        return Requesttile(
          isAccepted: true, // Shows "Start Chat" button
          startChat: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    Chatscreen(id: friendId, name: friendName),
              ),
            );
          },
          title: friendName,
          trailing: friend['addedAt'] != null
              ? 'Added ${_formatTime((friend['addedAt'] as Timestamp).toDate())}'
              : '',
          leading: chat.extracting(friendName),
        );
      },
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String label,
    required ColorScheme colorScheme,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 16),
          Text(
            label,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.4),
            ),
          ),
        ],
      ),
    );
  }
}
