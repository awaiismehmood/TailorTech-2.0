import 'package:flutter/cupertino.dart';

import '../consts/consts.dart';

Widget applogoWidget() {
  //using Velocity X
  return Image.asset(T_logo)
      .box
      .color(const Color.fromARGB(255, 255, 255, 255))
      .size(77, 77)
      .padding(const EdgeInsets.all(8))
      .rounded
      .make();
}
