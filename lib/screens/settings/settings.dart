import 'package:ai_music/config/extensions/color.dart';
import 'package:ai_music/config/theme/colors.dart';
import 'package:ai_music/config/theme/text_style.dart';
import 'package:ai_music/controllers/home_controller.dart';
import 'package:ai_music/modules/song_module.dart';
import 'package:ai_music/widgets/button.dart';
import 'package:flutter/material.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key, required this.controller});
  final HomeController controller;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage("assets/image/background.png"), fit: BoxFit.fill),
      ),
      child: Stack(
        children: [
          SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: _buildList(context)),
          _buildTitle(context),
        ],
      ),
    );
  }

  Widget _buildList(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).padding.top + 100,
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    AppColors.background,
                  ],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  decoration: ShapeDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.5),
                        AppColors.background,
                      ],
                    ),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16.0, right: 16),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 36, bottom: 16),
                          child: Row(
                            children: [
                              Text(
                                "Setting",
                                style: AppTextStyle.labelStyle.copyWith(
                                    fontWeight: FontWeight.bold, fontSize: 25),
                              ),
                            ],
                          ),
                        ),
                        ...controller.trending
                            .map((e) => _buildItem(context, e)),
                        const SizedBox(
                          height: 96,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 80,
      ),
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(),
              SizedBox(
                  height: 38, width: 253, child: AppButton(label: "Setting")),
              SizedBox(),
            ],
          ),
          const Spacer(),
          _buildNavBar(context),
        ],
      ),
    );
  }

  Widget _buildNavBar(BuildContext context) {
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
              Column(
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
              Column(
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
              Column(
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItem(BuildContext context, SongModule song) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 56,
            width: 56,
            decoration: ShapeDecoration(
              image: DecorationImage(
                image: NetworkImage(song.image!),
              ),
              shape: RoundedRectangleBorder(
                side: const BorderSide(width: 1, color: Colors.transparent),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  song.title ?? "--",
                  style: AppTextStyle.labelStyle
                      .copyWith(fontSize: 13, fontWeight: FontWeight.normal),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width - (64 + 16 + 56),
                  child: Text(
                    song.description ?? "--",
                    maxLines: 2,
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
    );
  }
}
