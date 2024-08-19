import 'package:ai_music/config/theme/colors.dart';
import 'package:ai_music/config/theme/text_style.dart';
import 'package:ai_music/controllers/home_controller.dart';
import 'package:ai_music/screens/generate/generate.dart';
import 'package:ai_music/screens/settings/settings.dart';
import 'package:ai_music/screens/songs/songs.dart';
import 'package:ai_music/screens/trending/trending_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
        init: HomeController(),
        builder: (controller) {
          return WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              body: Stack(
                children: [
                  _buildBody(controller),
                  SizedBox(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        const Spacer(),
                        if (controller.option == NavBarOption.trending)
                          _buildNavBar(context, controller)
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget _buildNavBar(BuildContext context, HomeController controller) {
    return Container(
      width: double.infinity,
      height: 80 + MediaQuery.of(context).padding.bottom,
      decoration: ShapeDecoration(
        color: AppColors.primary,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(36),
            topRight: Radius.circular(36),
          ),
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16, top: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  controller.changeOption(NavBarOption.trending);
                },
                child: Column(
                  children: [
                    Image.asset(
                      width: 40,
                      height: 40,
                      "assets/icons/home.png",
                    ),
                    Text(
                      "Home",
                      style: AppTextStyle.labelStyle.copyWith(
                        fontWeight: FontWeight.normal,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  controller.changeOption(NavBarOption.generate);
                },
                child: Column(
                  children: [
                    Image.asset(
                      width: 40,
                      height: 40,
                      "assets/icons/add.png",
                    ),
                    Text(
                      "Create",
                      style: AppTextStyle.labelStyle.copyWith(
                        fontWeight: FontWeight.normal,
                        fontSize: 10,
                      ),
                    )
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  controller.changeOption(NavBarOption.songs);
                },
                child: Column(
                  children: [
                    Image.asset(
                      width: 40,
                      height: 40,
                      "assets/icons/songs.png",
                    ),
                    Text(
                      "My Songs",
                      style: AppTextStyle.labelStyle.copyWith(
                        fontWeight: FontWeight.normal,
                        fontSize: 10,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody(HomeController controller) {
    switch (controller.option) {
      case NavBarOption.trending:
        return TrendingScreen(
          controller: controller,
        );
      case NavBarOption.generate:
        return GenerateSong(controller: controller);
      case NavBarOption.songs:
        return MySongs(controller: controller);
      case NavBarOption.settings:
        return SettingScreen(controller: controller);
    }
  }
}
