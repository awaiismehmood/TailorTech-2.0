import 'package:dashboard_new/consts/consts.dart';
import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String messages;
  final bool isCurrentUser;
  const ChatBubble(
      {super.key, required this.isCurrentUser, required this.messages});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isCurrentUser ? redColor : Colors.grey.shade700,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 2.5, horizontal: 25),
      child: Text(
        messages,
        style: const TextStyle(
          color: whiteColor,
        ),
      ),
    );
  }
}
