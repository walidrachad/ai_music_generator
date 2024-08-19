import 'package:ai_music/config/theme/colors.dart';
import 'package:ai_music/config/theme/text_style.dart';
import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  const AppButton({super.key, required this.label});
  final String label;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        decoration: ShapeDecoration(
          color: AppColors.primary,
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 1, color: Colors.transparent),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Container(
          alignment: Alignment.center,
          decoration: ShapeDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Colors.transparent,
                Colors.black.withOpacity(0.5),
              ],
            ),
            shape: RoundedRectangleBorder(
              side: const BorderSide(width: 1, color: Colors.transparent),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text(
              label,
              style: AppTextStyle.labelStyle.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
