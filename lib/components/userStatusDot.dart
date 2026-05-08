import 'package:chat_application/services/authServices.dart';
import 'package:chat_application/themes/app_theme.dart';
import 'package:flutter/material.dart';

class UserStatusDot extends StatelessWidget {
  final String userId;
  final double size;
  final Color? offlineColor;

  const UserStatusDot({
    super.key,
    required this.userId,
    this.size = 10,
    this.offlineColor,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Map<String, dynamic>?>(
      stream: Authservices().listenUserStatus(userId),
      builder: (context, snapshot) {
        final isOnline = snapshot.data?['status'] == 'Online';
        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: isOnline ? AppColors.secondary500 : (offlineColor ?? AppColors.grey400),
            shape: BoxShape.circle,
            boxShadow: isOnline
                ? [
                    BoxShadow(
                      color: AppColors.secondary500.withOpacity(0.3),
                      blurRadius: 4,
                      spreadRadius: 1,
                    ),
                  ]
                : null,
          ),
        );
      },
    );
  }
}
