import 'package:ai_music/config/data.dart';
import 'package:ai_music/config/theme/colors.dart';
import 'package:ai_music/controllers/home_controller.dart';
import 'package:flutter/material.dart';

class CustomPublication extends StatelessWidget {
  const CustomPublication({super.key, required this.homeController});
  final HomeController homeController;
  @override
  Widget build(BuildContext context) {
    if (AppData.settingModule.hasPub) {
      return InkWell(
        onTap: () {
          homeController.launchInBrowser(AppData.settingModule.pupLink);
        },
        child: Container(
          color: Colors.black,
          child: Container(
            height: 100,
            decoration: ShapeDecoration(
              color: AppColors.primary,
              image: DecorationImage(
                  image: NetworkImage(AppData.settingModule.pubImage),
                  fit: BoxFit.fill),
              shape: RoundedRectangleBorder(
                side: const BorderSide(width: 1, color: Colors.transparent),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      );
    }
    return const SizedBox();
  }
}
