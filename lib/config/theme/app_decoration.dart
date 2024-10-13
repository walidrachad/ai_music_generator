import 'package:ai_music/config/extensions/color.dart';
import 'package:flutter/material.dart';

Decoration masterDecoration = ShapeDecoration(
  gradient: LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      HexColor("#008575").withOpacity(0.5),
      Colors.black.withOpacity(0.5),
    ],
  ),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.only(
      topLeft: Radius.circular(16),
      topRight: Radius.circular(16),
    ),
  ),
);
