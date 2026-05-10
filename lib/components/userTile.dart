import 'package:chat_application/components/userStatusDot.dart';
import 'package:chat_application/view/userInfoScreen.dart';
import 'package:flutter/material.dart';

class Usertile extends StatelessWidget {
  final String leading;
  final String title;
  final String? userId; // Added userId
  final bool? status;
  final VoidCallback onPressed;
  final String actionLabel;
  final IconData actionIcon;

  const Usertile({
    super.key,
    required this.title,
    required this.leading,
    this.userId, // Added userId
    required this.status,
    required this.onPressed,
    this.actionLabel = 'Add',
    this.actionIcon = Icons.add,
  });

  @override
  Widget build(BuildContext context) {
    final isOnline = status == true;
    return Card(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border(
            left: BorderSide(
              width: 5,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        height: 75,
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  if (userId != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Userinfoscreen(userId: userId),
                      ),
                    );
                  }
                },
                child: Stack(
                  children: [
                    Container(
                      height: 55,
                      width: 55,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Theme.of(context).primaryColor,
                            Theme.of(context).colorScheme.inversePrimary,
                          ],
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: Center(child: Text(leading)),
                    ),
                    Positioned(
                      top: 40,
                      right: 2,
                      child: userId != null
                          ? UserStatusDot(userId: userId!, size: 12)
                          : Icon(
                              size: 10,
                              Icons.circle,
                              color: isOnline ? Colors.green : Colors.grey,
                            ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              InkWell(
                onTap: () => onPressed(),
                child: Container(
                  height: 30,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Center(
                          child: Text(
                            actionLabel,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(fontWeight: FontWeight.bold)
                                .copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.inverseSurface,
                                ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Icon(actionIcon, color: Colors.black),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
