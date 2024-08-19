import 'package:ai_music/config/extensions/color.dart';
import 'package:ai_music/config/theme/colors.dart';
import 'package:ai_music/config/theme/text_style.dart';
import 'package:ai_music/controllers/home_controller.dart';
import 'package:ai_music/modules/song_module.dart';
import 'package:ai_music/widgets/button.dart';
import 'package:flutter/material.dart';

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
              child: _buildList(context)),
        ],
      ),
    );
  }

  Widget _buildList(BuildContext context) {
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
                  padding: const EdgeInsets.only(left: 0.0, right: 0),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 16, bottom: 16, left: 16, right: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () {
                                controller.changeOption(NavBarOption.trending);
                              },
                              child: Container(
                                height: 26,
                                width: 26,
                                decoration: const BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage(
                                            "assets/icons/arrow_right.png"),
                                        fit: BoxFit.fill)),
                              ),
                            ),
                            Text(
                              "My Songs",
                              style: AppTextStyle.labelStyle.copyWith(
                                  fontWeight: FontWeight.normal, fontSize: 20),
                            ),
                            const SizedBox(
                              height: 26,
                              width: 26,
                            )
                          ],
                        ),
                      ),
                      Expanded(
                          child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16, right: 16),
                          child: Column(
                            children: [
                              ...controller.mySongs
                                  .map((e) => _buildItem(context, e)),
                            ],
                          ),
                        ),
                      )),
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0, bottom: 16),
                        child: SizedBox(
                            height: 38,
                            width: 253,
                            child: InkWell(
                                onTap: () {
                                  controller
                                      .changeOption(NavBarOption.generate);
                                },
                                child:
                                    const AppButton(label: "Generate Song"))),
                      ),
                      Container(
                        color: Colors.black,
                        child: Container(
                          height: 100,
                          decoration: ShapeDecoration(
                            color: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                  width: 1, color: Colors.transparent),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
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
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
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
                    SizedBox(
                      width: MediaQuery.of(context).size.width -
                          (64 + 16 + 56 + 18),
                      child: Text(
                        song.title ?? "--",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyle.labelStyle.copyWith(
                            fontSize: 13, fontWeight: FontWeight.normal),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width -
                          (64 + 16 + 56 + 18),
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
          Container(
            height: 18,
            width: 18,
            decoration: ShapeDecoration(
              color: HexColor("#939394"),
              image: const DecorationImage(
                image: AssetImage("assets/icons/more.png"),
              ),
              shape: RoundedRectangleBorder(
                side: const BorderSide(width: 1, color: Colors.transparent),
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          )
        ],
      ),
    );
  }
}
