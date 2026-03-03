import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Usertile extends StatelessWidget {
  final String leading;
  final String title;
  final bool? status;
  final VoidCallback onPressed;
  final String actionLabel;
  final IconData actionIcon;

  const Usertile({
    super.key,
    required this.title,
    required this.leading,
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
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Stack(
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
                    child: Icon(
                      size: 10,
                      Icons.circle,
                      color: isOnline ? Colors.green : Colors.grey,
                    ),
                  ),
                ],
              ),
              SizedBox(width: 30),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Text(title, overflow: TextOverflow.ellipsis)],
                ),
              ),
              const SizedBox(width: 12),
              InkWell(
                onTap: () => onPressed(),
                child: Container(
                  height: 30,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Theme.of(context).colorScheme.secondary,
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
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
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
