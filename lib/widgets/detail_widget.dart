import 'package:ai_music/config/theme/colors.dart';
import 'package:ai_music/config/theme/text_style.dart';
import 'package:ai_music/controllers/dialog_controller.dart';
import 'package:ai_music/modules/song_module.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';


class DetailDialog extends StatelessWidget {
  const DetailDialog({super.key, required this.song});
  final SongModule song;
  @override
  Widget build(BuildContext context) {
    return GetBuilder<DialogController>(
        init: DialogController(song.mp3!),
        builder: (controller) {
          return Container(
            height: 196
                + MediaQuery.of(context).padding.bottom,
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
                  color: Colors.white.withOpacity(0.3),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 0.0, right: 0),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 12,
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
                            controller.exist
                                ? InkWell(
                                    onTap: () {
                                      controller.open(song.mp3!);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 8.0, left: 12, bottom: 8),
                                      child: Row(
                                        children: [
                                          const SizedBox(
                                            height: 22,
                                            width: 22,
                                            child: Icon(
                                              Icons.play_arrow,
                                              size: 22,
                                              color: Colors.white,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 12,
                                          ),
                                          Text(
                                            "Open",
                                            style: AppTextStyle.labelStyle
                                                .copyWith(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 15),
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                : InkWell(
                                    onTap: () {
                                      controller.downloadFile(
                                          song.mp3!, context);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 8.0, left: 12, bottom: 8),
                                      child: Row(
                                        children: [
                                          controller.isDownloded
                                              ? const SizedBox(
                                                  height: 22,
                                                  width: 22,
                                                  child: LoadingIndicator(
                                                    indicatorType: Indicator
                                                        .ballSpinFadeLoader,
                                                    colors: [Colors.white],
                                                    strokeWidth: 1,
                                                  ),
                                                )
                                              : const SizedBox(
                                                  height: 22,
                                                  width: 22,
                                                  child: Icon(
                                                    Icons
                                                        .download_for_offline_rounded,
                                                    size: 22,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                          const SizedBox(
                                            width: 12,
                                          ),
                                          Text(
                                            "Download",
                                            style: AppTextStyle.labelStyle
                                                .copyWith(
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
                                      "Share You Songs",
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
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
