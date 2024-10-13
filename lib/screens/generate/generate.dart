import 'package:ai_music/config/extensions/color.dart';
import 'package:ai_music/config/theme/app_decoration.dart';
import 'package:ai_music/config/theme/colors.dart';
import 'package:ai_music/config/theme/text_style.dart';
import 'package:ai_music/controllers/home_controller.dart';
import 'package:ai_music/widgets/button.dart';
import 'package:ai_music/widgets/custom_publication.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';

class GenerateSong extends StatelessWidget {
  const GenerateSong({super.key, required this.controller});
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
          height: MediaQuery.of(context).padding.top +
              (controller.steps == GenerateSongSteps.loading ? 80 : 150),
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
              child: _buildStep(context),
            ),
          ),
        ),
        Container(
          color: Colors.black,
          child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: CustomPublication(
              homeController: controller,
            ),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).padding.bottom,
        )
      ],
    );
  }

  Widget _buildStep(BuildContext context) {
    switch (controller.steps) {
      case GenerateSongSteps.text:
        return _buildTextStep(context);
      case GenerateSongSteps.style:
        return _buildStyleStep();
      case GenerateSongSteps.loading:
        return _buildLoadingStep(context);
    }
  }

  Widget _buildLoadingStep(BuildContext context) {
    return Container(
      width: double.infinity,
      alignment: Alignment.center,
      decoration: masterDecoration,
      child: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 16, bottom: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Please wait, Your music is\nbeing prepared now.",
                    textAlign: TextAlign.center,
                    style: AppTextStyle.labelStyle
                        .copyWith(fontWeight: FontWeight.normal, fontSize: 20),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.4,
            ),
            const Padding(
              padding: EdgeInsets.only(top: 24),
              child: SizedBox(
                height: 54,
                width: 54,
                child: LoadingIndicator(
                  indicatorType: Indicator.ballSpinFadeLoader,
                  colors: [Colors.white],
                  strokeWidth: 1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStyleStep() {
    return Container(
      width: double.infinity,
      alignment: Alignment.center,
      decoration: masterDecoration,
      child: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 16, bottom: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Choose mods",
                    style: AppTextStyle.labelStyle
                        .copyWith(fontWeight: FontWeight.normal, fontSize: 25),
                  ),
                ],
              ),
            ),
            Wrap(
              children: controller.styles
                  .map((style) => Padding(
                        padding: const EdgeInsets.only(right: 8.0, bottom: 8),
                        child: InkWell(
                          onTap: () => controller.selectStyle(style),
                          child: Container(
                            decoration: BoxDecoration(
                                color: controller.selectedStyle != style
                                    ? HexColor("#252020")
                                    : Colors.blue,
                                border: Border.all(
                                    color: controller.selectedStyle != style
                                        ? HexColor("#9E9795")
                                        : Colors.white),
                                borderRadius: BorderRadius.circular(5)),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 8, right: 8, top: 4, bottom: 4),
                              child: Text(
                                style,
                                style: AppTextStyle.labelStyle.copyWith(
                                    color: controller.selectedStyle != style
                                        ? HexColor("#9E9795")
                                        : Colors.white,
                                    fontSize: 15),
                              ),
                            ),
                          ),
                        ),
                      ))
                  .toList(),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 24),
              child: !controller.isLoading
                  ? Material(
                      color: Colors.transparent,
                      child: InkWell(
                          onTap: () => controller.generate(),
                          child: const AppButton(label: "Next Step")),
                    )
                  : _buildLoadingButton(),
            ),
            const SizedBox(
              height: 100,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTextStep(BuildContext context) {
    return Container(
      width: double.infinity,
      alignment: Alignment.center,
      decoration: masterDecoration,
      child: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 16, bottom: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Song description or Lyrics",
                    style: AppTextStyle.labelStyle
                        .copyWith(fontWeight: FontWeight.normal, fontSize: 25),
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  color: HexColor("#252020"),
                  border: Border.all(color: AppColors.primary),
                  borderRadius: BorderRadius.circular(5)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            controller.changeSongType(SongType.description);
                          },
                          child: Container(
                            height: 40,
                            width: (MediaQuery.of(context).size.width - 66) / 2,
                            decoration: BoxDecoration(
                              color: controller.type == SongType.description
                                  ? AppColors.primary
                                  : HexColor("#252020"),
                              border: Border.all(color: AppColors.primary),
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(0),
                                bottomRight: Radius.circular(0),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                "Song description",
                                style: AppTextStyle.labelStyle.copyWith(
                                    fontSize: 12, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          controller.changeSongType(SongType.lyrics);
                        },
                        child: Container(
                          height: 40,
                          width: (MediaQuery.of(context).size.width - 66) / 2,
                          decoration: BoxDecoration(
                            color: controller.type == SongType.lyrics
                                ? AppColors.primary
                                : HexColor("#252020"),
                            border: Border.all(color: AppColors.primary),
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(0),
                              bottomRight: Radius.circular(0),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              "Lyrics",
                              style: AppTextStyle.labelStyle.copyWith(
                                  fontSize: 12, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: TextFormField(
                      controller: controller.textEditingController,
                      decoration: InputDecoration(
                        hintStyle:
                            TextStyle(color: HexColor("#9E9795"), fontSize: 15),
                        border: InputBorder.none,
                        hintText: controller.type == SongType.description
                            ? "a groovy pop song about writing a face melting guitar solo"
                            : "Enter Your Own Lyrics",
                      ),
                      style:
                          TextStyle(color: HexColor("#9E9795"), fontSize: 15),
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.done,
                      minLines: 7,
                      maxLines: 7,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 24),
              child: !controller.isLoading
                  ? Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          if (controller.textEditingController.text.isEmpty) {
                            Get.showSnackbar(
                              GetSnackBar(
                                animationDuration:
                                    const Duration(milliseconds: 500),
                                duration: const Duration(seconds: 3),
                                backgroundColor: Colors.red.withOpacity(0.3),
                                margin: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).padding.bottom +
                                          16,
                                  left: 16,
                                  right: 16,
                                ),
                                messageText: InkWell(
                                  onTap: () {
                                    Get.closeCurrentSnackbar();
                                  },
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          controller.type ==
                                                  SongType.description
                                              ? "Please Insert Your Music Description"
                                              : "Please Insert Your Lyrics",
                                          style: const TextStyle(
                                            letterSpacing: 0.5,
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                borderRadius: 8,
                              ),
                            );
                            return;
                          }

                          controller.changeStep(GenerateSongSteps.style);
                        },
                        child: const AppButton(label: "Next Step"),
                      ),
                    )
                  : _buildLoadingButton(),
            ),
            const SizedBox(
              height: 100,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingButton() {
    return Container(
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
        child: const Padding(
          padding: EdgeInsets.all(4.0),
          child: SizedBox(
            height: 30,
            width: 30,
            child: LoadingIndicator(
              indicatorType: Indicator.ballSpinFadeLoader,
              colors: [Colors.white],
              strokeWidth: 1,
            ),
          ),
        ),
      ),
    );
  }
}
