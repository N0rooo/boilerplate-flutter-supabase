import 'package:boilerplate_flutter/core/common/entities/user.dart';
import 'package:boilerplate_flutter/core/theme/app_palette.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatMessageBuble extends StatelessWidget {
  final String message;
  final bool isCurrentUser;
  final User user;
  final bool showUserName;

  const ChatMessageBuble({
    super.key,
    required this.message,
    required this.isCurrentUser,
    required this.user,
    this.showUserName = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
        alignment: isCurrentUser ? Alignment.topRight : Alignment.topLeft,
        child: Container(
          constraints: BoxConstraints(
            minWidth: 0,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isCurrentUser ? AppPallete.gradient2 : Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (showUserName && !isCurrentUser)
                Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: Text(
                    user.name,
                    style: TextStyle(
                      color: isCurrentUser ? Colors.white : Colors.black,
                      fontSize: 12,
                    ),
                  ),
                ),
              Text(
                message,
                style: TextStyle(
                  color: isCurrentUser ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
