import 'package:dashboard_new/consts/consts.dart';
import 'package:flutter/material.dart';

Widget ourButton({onPress, color, textcolor, String? tit}) {
  return ElevatedButton(
      style: ElevatedButton.styleFrom(
          // ignore: deprecated_member_use
          backgroundColor: color,
          padding: const EdgeInsets.all(12)),
      onPressed: onPress,
      child: tit!.text.color(textcolor).fontFamily(bold).make());
}
