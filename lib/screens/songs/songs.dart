import 'package:ai_music/config/contant.dart';
import 'package:ai_music/config/extensions/color.dart';
import 'package:ai_music/config/theme/app_decoration.dart';
import 'package:ai_music/config/theme/colors.dart';
import 'package:ai_music/config/theme/text_style.dart';
import 'package:ai_music/controllers/home_controller.dart';
import 'package:ai_music/modules/song_module.dart';
import 'package:ai_music/widgets/button.dart';
import 'package:ai_music/widgets/custom_publication.dart';
import 'package:ai_music/widgets/detail_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class MySongs extends StatelessWidget {
  const MySongs({super.key, required this.controller});

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
              child: _buildBody(context)),
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
                            top: 36, bottom: 0, left: 16.0, right: 16),
                        child: Row(
                          children: [
                            Text(
                              MY_SONGS,
                              style: AppTextStyle.labelStyle.copyWith(
                                  fontWeight: FontWeight.bold, fontSize: 25),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16, right: 16),
                          child: RefreshIndicator(
                            onRefresh: () async =>
                                controller.pagingController.refresh(),
                            child: PagedListView<int, SongModule>.separated(
                              pagingController: controller.pagingController,
                              builderDelegate: PagedChildBuilderDelegate(
                                animateTransitions: true,
                                itemBuilder: (context, item, index) =>
                                    _buildItem(context, item),
                              ),
                              separatorBuilder: (context, index) =>
                                  const SizedBox(),
                            ),
                          ),
                        ),
                      ),
                      CustomPublication(
                        homeController: controller,
                      ),
                      const SizedBox(
                        height: 96,
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

  Widget _buildItem(BuildContext context, SongModule song) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Card(
        color: AppColors.primary,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () => controller.loadAudio(song),
                    child: Container(
                      height: 56,
                      width: 56,
                      decoration: ShapeDecoration(
                        image: song.image != null
                            ? DecorationImage(
                                image: NetworkImage(song.image!),
                              )
                            : const DecorationImage(
                                fit: BoxFit.fill,
                                image: AssetImage("assets/image/background.png"),
                              ),
                        shape: RoundedRectangleBorder(
                          side:
                              const BorderSide(width: 1, color: Colors.transparent),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () => controller.loadAudio(song),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16, top: 8),
                      child: (song.description != null)
                          ? Text(
                              "${song.description!.substring(0, 10)} ...",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyle.labelStyle.copyWith(
                                  fontSize: 13, fontWeight: FontWeight.normal),
                            )
                          : const SizedBox(),
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  const SizedBox(
                    width: 16,
                  ),
                  InkWell(
                    onTap: () => showDetail(context, song),
                    child: Container(
                      height: 18,
                      width: 18,
                      decoration: ShapeDecoration(
                        color: HexColor("#939394"),
                        image: const DecorationImage(
                          image: AssetImage("assets/icons/more.png"),
                        ),
                        shape: RoundedRectangleBorder(
                          side:
                              const BorderSide(width: 1, color: Colors.transparent),
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  showDetail(BuildContext context, SongModule song) {
    Get.bottomSheet(
      DetailDialog(
        song: song,
      ),
      enterBottomSheetDuration: 300.milliseconds,
      exitBottomSheetDuration: 300.milliseconds,
      backgroundColor: Colors.transparent,
      elevation: 1,
      isDismissible: true,
      ignoreSafeArea: false,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
    );
  }
}
