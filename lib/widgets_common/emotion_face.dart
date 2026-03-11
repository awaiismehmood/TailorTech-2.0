import 'package:dashboard_new/consts/colors.dart';
import 'package:flutter/material.dart';

class EmotionFace extends StatelessWidget {
  final String emotionFace;

  const EmotionFace({super.key, required this.emotionFace});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: redColor,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(12),
      child: Center(
        child: Text(emotionFace, style: const TextStyle(fontSize: 28)),
      ),
    );
  }
}
