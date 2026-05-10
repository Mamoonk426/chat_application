import 'package:chat_application/components/userStatusDot.dart';
import 'package:chat_application/view/userInfoScreen.dart';
import 'package:flutter/material.dart';

class Requesttile extends StatefulWidget {
  final String? leading;
  final String? title;
  final String? trailing;
  final String? userId; // Added userId
  final Function? confirmCall;
  final Function? cancelCall;
  final Function? startChat;
  final bool isAccepted;
  final bool isSentRequest;
  final String? statusLabel;
  const Requesttile({
    super.key,
    this.leading,
    this.title,
    this.trailing,
    this.userId, // Added userId
    this.cancelCall,
    this.confirmCall,
    this.isAccepted = false,
    this.startChat,
    this.isSentRequest = false,
    this.statusLabel,
  });

  @override
  State<Requesttile> createState() => _RequesttileState();
}

class _RequesttileState extends State<Requesttile> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 100),
            GestureDetector(
              onTap: () {
                if (widget.userId != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          Userinfoscreen(userId: widget.userId),
                    ),
                  );
                }
              },

              child: SizedBox(
                height: 80,
                width: 80,
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      child: Text(widget.leading.toString()),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.title.toString(),
                    style: Theme.of(context).textTheme.titleLarge,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Text(
                    widget.trailing.toString(),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.7),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8),
                  if (widget.isSentRequest)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: widget.statusLabel == 'Accepted'
                            ? Colors.green.withOpacity(0.15)
                            : Colors.amber.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            widget.statusLabel == 'Accepted'
                                ? Icons.check_circle_outline
                                : Icons.schedule,
                            size: 16,
                            color: widget.statusLabel == 'Accepted'
                                ? Colors.green
                                : Colors.amber.shade700,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            widget.statusLabel ?? 'Pending',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              color: widget.statusLabel == 'Accepted'
                                  ? Colors.green
                                  : Colors.amber.shade700,
                            ),
                          ),
                        ],
                      ),
                    )
                  else if (widget.isAccepted)
                    InkWell(
                      onTap: () => widget.startChat?.call(),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(
                            context,
                          ).colorScheme.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.chat,
                              color: Theme.of(context).colorScheme.primary,
                              size: 18,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Start Chat',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              widget.confirmCall!();
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 6,
                              ),
                              minimumSize: const Size(0, 35),
                            ),
                            child: const Text('Confirm'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => widget.cancelCall?.call(),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 6,
                              ),
                              minimumSize: const Size(0, 35),
                            ),
                            child: const Text('Cancel'),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
