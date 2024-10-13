import 'package:ai_music/config/contant.dart';
import 'package:ai_music/config/data.dart';
import 'package:ai_music/config/extensions/color.dart';
import 'package:ai_music/config/theme/colors.dart';
import 'package:ai_music/config/theme/text_style.dart';
import 'package:ai_music/controllers/home_controller.dart';
import 'package:ai_music/screens/generate/generate.dart';
import 'package:ai_music/screens/settings/settings.dart';
import 'package:ai_music/screens/songs/songs.dart';
import 'package:ai_music/screens/trending/trending_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart' as ja;
import 'package:loading_indicator/loading_indicator.dart';
import 'package:percent_indicator/percent_indicator.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
        init: HomeController(),
        builder: (controller) {
          return WillPopScope(
            onWillPop: () async {
              controller.goBack();
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
                        _buildAppBar(controller, context),
                        const Spacer(),
                        if (!controller.isPlaying)
                          _buildNavBar(context, controller),
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
    if (controller.isPlaying) {
      return Column(
        children: [
          Container(
            width: double.infinity,
            height: 60 + MediaQuery.of(context).padding.bottom,
            decoration: ShapeDecoration(
              color: AppColors.primary,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(36),
                  topRight: Radius.circular(36),
                ),
              ),
            ),
            child: StreamBuilder<ja.PlayerState>(
              stream: controller.player.playerStateStream,
              builder: (context, snapshot) {
                final playerState = snapshot.data;
                if (playerState?.processingState != ja.ProcessingState.ready) {
                  return const Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 16, right: 15),
                        child: SizedBox(
                          width: 30,
                          height: 30,
                          child: LoadingIndicator(
                            indicatorType: Indicator.ballSpinFadeLoader,
                            colors: [Colors.white],
                            strokeWidth: 1,
                          ),
                        ),
                      ),
                    ],
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.only(left: 16, right: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              height: 36,
                              width: 36,
                              decoration: ShapeDecoration(
                                image: controller.song!.image!.isNotEmpty
                                    ? DecorationImage(
                                        image: NetworkImage(
                                            controller.song!.image!),
                                      )
                                    : const DecorationImage(
                                        fit: BoxFit.fill,
                                        image: AssetImage(
                                            "assets/image/background.png"),
                                      ),
                                shape: RoundedRectangleBorder(
                                  side: const BorderSide(
                                      width: 1, color: Colors.transparent),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 16, top: 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 100,
                                    child: Text(
                                      controller.song!.title ?? "--",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: AppTextStyle.labelStyle.copyWith(
                                          fontSize: 13,
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 100,
                                    child: Text(
                                      controller.song!.description ?? "--",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: AppTextStyle.labelStyle.copyWith(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w400,
                                          color: HexColor("#FFFFFF")),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            playerState?.playing == true
                                ? IconButton(
                                    icon: const Icon(Icons.pause),
                                    iconSize: 30.0,
                                    color: Colors.white,
                                    onPressed: controller.player.pause,
                                  )
                                : IconButton(
                                    icon: const Icon(Icons.play_arrow),
                                    iconSize: 30.0,
                                    color: Colors.white,
                                    onPressed: controller.player.play,
                                  ),
                            IconButton(
                              icon: const Icon(Icons.close),
                              iconSize: 30.0,
                              color: Colors.white,
                              onPressed: controller.closePlayer,
                            )
                          ],
                        )
                      ],
                    ),
                  );
                }
              },
            ),
          ),
          if (AppData.settingModule.hasPub &&
              (controller.option == NavBarOption.settings ||
                  controller.option == NavBarOption.songs ||
                  controller.option == NavBarOption.generate))
            const SizedBox(
              height: 100,
            )
        ],
      );
    }
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
            children: [
              Expanded(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
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
                ),
              ),
              Expanded(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
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
                ),
              ),
              Expanded(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
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
                          MY_SONGS,
                          style: AppTextStyle.labelStyle.copyWith(
                            fontWeight: FontWeight.normal,
                            fontSize: 10,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      controller.changeOption(NavBarOption.settings);
                    },
                    child: Column(
                      children: [
                        Image.asset(
                          width: 40,
                          height: 40,
                          "assets/icons/option.png",
                        ),
                        Text(
                          MY_SONGS,
                          style: AppTextStyle.labelStyle.copyWith(
                            fontWeight: FontWeight.normal,
                            fontSize: 10,
                          ),
                        )
                      ],
                    ),
                  ),
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

  Widget _buildAppBar(HomeController controller, BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 16,
        left: 16,
        right: 16,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              child: (controller.credit == 0)
                  ? LinearPercentIndicator(
                      width: 140,
                      barRadius: const Radius.circular(12),
                      lineHeight: 35,
                      percent: 0.99,
                      backgroundColor: Colors.black,
                      linearGradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          HexColor("#daf6f4"),
                          HexColor("#008575"),
                        ],
                      ),
                      center: Text("loading ...",
                          style: AppTextStyle.labelStyle.copyWith(
                              fontSize: 16, fontWeight: FontWeight.w500)),
                    )
                  : InkWell(
                      onTap: () {},
                      child: Container(
                        height: 35,
                        decoration: ShapeDecoration(
                          color: AppColors.primary,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12),
                              bottomLeft: Radius.circular(12),
                              bottomRight: Radius.circular(12),
                            ),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Row(
                            children: [
                              const SizedBox(
                                width: 4,
                              ),
                              if (controller.credit == 50)
                                Image.asset(
                                  width: 18,
                                  height: 18,
                                  "assets/icons/coins.png",
                                ),
                              if (controller.credit < 50)
                                Image.asset(
                                  width: 18,
                                  height: 18,
                                  "assets/icons/addition.png",
                                ),
                              const SizedBox(
                                width: 8,
                              ),
                              Text(
                                "${controller.credit} Credits",
                                style: AppTextStyle.labelStyle.copyWith(
                                    fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(
                                width: 4,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
            ),
          )
        ],
      ),
    );
  }
}
