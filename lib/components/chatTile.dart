import 'package:flutter/material.dart';

class ChatTile extends StatelessWidget {
  final String receiverName;
  final String lastMessage;
  final DateTime lastMessageTime;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  int? unreadCounts;

  ChatTile({
    super.key,
    required this.receiverName,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.onTap,
    required this.unreadCounts,
    required this.onLongPress,
  });

  /// Extracts the first two letters from the name for the avatar.
  String _initials(String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return '??';
    final parts = trimmed.split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return trimmed.length >= 2
        ? trimmed.substring(0, 2).toUpperCase()
        : trimmed[0].toUpperCase();
  }

  /// Formats the time like WhatsApp: "Today 2:30 PM", "Yesterday", or "Mar 15".
  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final messageDay = DateTime(time.year, time.month, time.day);
    final diff = today.difference(messageDay).inDays;

    final hour = time.hour % 12 == 0 ? 12 : time.hour % 12;
    final minute = time.minute.toString().padLeft(2, '0');
    final amPm = time.hour >= 12 ? 'PM' : 'AM';
    final timeStr = '$hour:$minute $amPm';

    if (diff == 0) return timeStr;
    if (diff == 1) return 'Yesterday';

    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[time.month - 1]} ${time.day}';
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.04),
            blurRadius: 15,
            spreadRadius: 2,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          onLongPress: onLongPress,
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              children: [
                // ── Avatar with initials ──
                Container(
                  height: 56,
                  width: 56,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        colorScheme.primary,
                        colorScheme.primary.withValues(alpha: 0.6),
                      ],
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: colorScheme.primary.withValues(alpha: 0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      _initials(receiverName),
                      style: textTheme.titleMedium?.copyWith(
                        color: colorScheme.onPrimary,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 16),

                // ── Name + last message ──
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        receiverName.isNotEmpty ? receiverName : 'Unknown',
                        style: textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        lastMessage,
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurface.withValues(alpha: 0.6),
                          fontSize: 13,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 12),

                // ── Time & potentially unread badges ──
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _formatTime(lastMessageTime),
                      style: textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.4),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Just a placeholder for unseen message indicator styling
                    (unreadCounts ?? 0) == 0
                        ? SizedBox.shrink()
                        : Container(
                            width: 30,
                            height: 30,
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: colorScheme.secondary,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                (unreadCounts ?? 0) > 99
                                    ? '99+'
                                    : unreadCounts.toString(),
                                style: TextStyle(
                                  color: colorScheme.inverseSurface,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
