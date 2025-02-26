import 'package:flutter/cupertino.dart';

class ChatSearchBar extends StatelessWidget {
  final String placeholder;
  final TextEditingController controller;
  final Function(String) onChanged;
  final FocusNode? focusNode;
  const ChatSearchBar({
    super.key,
    this.placeholder = 'Search name',
    required this.controller,
    required this.onChanged,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoSearchTextField(
      placeholder: placeholder,
      controller: controller,
      onChanged: onChanged,
      focusNode: focusNode,
    );
  }
}
