import 'package:boilerplate_flutter/core/theme/app_palette.dart';
import 'package:flutter/material.dart';

class ChatMessageBuble extends StatelessWidget {
  final String message;
  final bool isCurrentUser;

  const ChatMessageBuble(
      {super.key, required this.message, required this.isCurrentUser});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
        alignment: isCurrentUser ? Alignment.topRight : Alignment.topLeft,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: isCurrentUser ? AppPallete.gradient1 : Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            message,
            style: TextStyle(
              color: isCurrentUser ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
