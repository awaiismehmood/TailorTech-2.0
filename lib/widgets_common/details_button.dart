import 'package:dashboard_new/consts/consts.dart';
import 'package:flutter/material.dart';

Widget detailCard(width, String? count, String? title) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      "00".text.fontFamily(bold).size(16).color(darkFontGrey).make(),
      "in your cart".text.color(darkFontGrey).make(),
    ],
  ).box.white.rounded.padding(const EdgeInsets.all(4)).width(width).height(68).make();
}
