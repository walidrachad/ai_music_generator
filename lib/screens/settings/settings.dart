import 'package:ai_music/config/data.dart';
import 'package:ai_music/config/theme/app_decoration.dart';
import 'package:ai_music/config/theme/colors.dart';
import 'package:ai_music/config/theme/text_style.dart';
import 'package:ai_music/controllers/home_controller.dart';
import 'package:ai_music/widgets/custom_publication.dart';
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
            child: _buildBody(context),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).padding.top + 80,
        ),
        Expanded(
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
                decoration: masterDecoration,
                child: Padding(
                  padding: const EdgeInsets.only(left: 0.0, right: 0),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 36, bottom: 16, left: 16.0, right: 16),
                        child: Row(
                          children: [
                            Text(
                              "Settings",
                              style: AppTextStyle.labelStyle.copyWith(
                                  fontWeight: FontWeight.bold, fontSize: 25),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width - 64,
                        decoration: ShapeDecoration(
                          color: Colors.white.withOpacity(0.3),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12),
                              bottomLeft: Radius.circular(12),
                              bottomRight: Radius.circular(12),
                            ),
                          ),
                        ),
                        child: Column(
                          children: [
                            InkWell(
                              onTap: () {
                                controller.launchInBrowser(
                                    AppData.settingModule.contact);
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 8.0, left: 12, bottom: 8),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      height: 22,
                                      width: 22,
                                      child: Image.asset(
                                          "assets/icons/contact.png"),
                                    ),
                                    const SizedBox(
                                      width: 12,
                                    ),
                                    Text(
                                      "Contact us",
                                      style: AppTextStyle.labelStyle.copyWith(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 15),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Divider(
                              thickness: 1,
                              color: Colors.white.withOpacity(0.3),
                            ),
                            InkWell(
                              onTap: () {
                                controller.shareApp();
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 8.0, left: 12, bottom: 8),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      height: 22,
                                      width: 22,
                                      child:
                                          Image.asset("assets/icons/share.png"),
                                    ),
                                    const SizedBox(
                                      width: 12,
                                    ),
                                    Text(
                                      "Tell Friends",
                                      style: AppTextStyle.labelStyle.copyWith(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 15),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Divider(
                              thickness: 1,
                              color: Colors.white.withOpacity(0.3),
                            ),
                            InkWell(
                              onTap: () {
                                controller.launchInBrowser(
                                    AppData.settingModule.privacyPolicy);
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 8.0, left: 12, bottom: 8),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      height: 22,
                                      width: 22,
                                      child: Image.asset(
                                          "assets/icons/privacy-policy.png"),
                                    ),
                                    const SizedBox(
                                      width: 12,
                                    ),
                                    Text(
                                      "Privacy Policy",
                                      style: AppTextStyle.labelStyle.copyWith(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 15),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Expanded(
                        child: SizedBox(),
                      ),
                      CustomPublication(
                        homeController: controller,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).padding.bottom,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
