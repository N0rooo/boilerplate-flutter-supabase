import 'package:boilerplate_flutter/core/common/widgets/input.dart';
import 'package:boilerplate_flutter/core/theme/app_palette.dart';
import 'package:flutter/material.dart';

class ChatMessageInput extends StatelessWidget {
  final TextEditingController controller;
  final Function() onSend;
  const ChatMessageInput({
    super.key,
    required this.controller,
    required this.onSend,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 50.0,
        top: 10.0,
        left: 10.0,
        right: 10.0,
      ),
      child: Row(
        children: [
          Expanded(
            child: Input(
              controller: controller,
              hintText: 'Type a message...',
              maxLines: 2,
            ),
          ),
          const SizedBox(width: 10.0),
          Container(
            decoration: BoxDecoration(
              color: AppPalette.gradient2,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: AppPalette.gradient2.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 5,
                ),
              ],
            ),
            child: IconButton(
              icon: const Icon(Icons.send, size: 20.0),
              padding: EdgeInsets.all(8.0),
              onPressed: () {
                onSend();
              },
            ),
          ),
        ],
      ),
    );
  }
}
