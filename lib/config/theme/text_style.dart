import 'package:ai_music/config/extensions/color.dart';
import 'package:ai_music/config/theme/colors.dart';
import 'package:flutter/material.dart';

class AppTextStyle {
  static TextStyle labelStyle = const TextStyle(
      color: Colors.white,
      fontFamily: "Inter",
      fontWeight: FontWeight.w400,
      fontSize: 20);
  static TextStyle title = const TextStyle(
    letterSpacing: 0.5,
    fontSize: 18,
    fontFamily: 'Inter',
    fontWeight: FontWeight.w600,
  );
  static TextStyle label = TextStyle(
    letterSpacing: 0.5,
    color: HexColor("#788691"),
    fontSize: 12,
    fontFamily: 'Inter',
    fontWeight: FontWeight.w400,
  );
}
