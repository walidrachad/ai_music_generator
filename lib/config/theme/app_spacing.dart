import 'package:flutter/material.dart';

class AppSpacing {
  static double maxWidth = 0;
  static double maxHeight = 0;
  static double paddingBottom = 0;
  static double paddingTop = 0;
  static double portraitPaddingBottom = 0;
  static double portraitPaddingTop = 0;
  static EdgeInsets defaultPadding = const EdgeInsets.only(left: 16, right: 16);
  static EdgeInsets getPadding() => EdgeInsets.only(
    left: maxWidth < 512 ? 16 : maxWidth * 0.2,
    right: maxWidth < 512 ? 16 : maxWidth * 0.2,
  );
  static EdgeInsets getIpadPadding(double max) => EdgeInsets.only(
    left: max < 512 ? 0 : max * 0.2,
    right: max < 512 ? 0 : max * 0.2,
  );
  static double getBackground(Size size) =>
      size.width < 512 ? size.height * 0.25 : size.height;
  static bool isLarge() => maxWidth > 512;

  static double getSize(double size) {
    return maxHeight * (size / maxHeight);
  }
}
