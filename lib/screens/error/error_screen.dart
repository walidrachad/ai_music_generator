import 'dart:io';

import 'package:ai_music/config/theme/app_spacing.dart';
import 'package:ai_music/config/theme/text_style.dart';
import 'package:ai_music/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lordicon/lordicon.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildImage(),
              _buildMessage(),
              const Spacer(),
              _buildSubmitBtn()
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMessage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Oops!!\nA small error",
          style: AppTextStyle.title,
          textAlign: TextAlign.center,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "We are currently experiencing a technical issue. Please try again later.",
            style: AppTextStyle.label.copyWith(fontSize: 14),
            textAlign: TextAlign.center,
          ),
        )
      ],
    );
  }

  Widget _buildSubmitBtn() {
    return Padding(
      padding: EdgeInsets.only(bottom: Platform.isAndroid ? 16 : 37),
      child: const AppButton(
        label: 'back',
      ),
    );
  }

  Widget _buildImage() {
    var controller = IconController.assets(
      "assets/animation/outline_error.json",
    );

    controller.addStatusListener((status) {
      if (status == ControllerStatus.ready) {
        controller.playFromBeginning();
      }
    });
    return Padding(
      padding:
          EdgeInsets.only(top: AppSpacing.maxHeight * 0.2, left: 28, right: 28),
      child: SizedBox(
        height: AppSpacing.maxHeight * 0.32,
        child: Stack(
          alignment: Alignment.center,
          children: [
            SvgPicture.asset(
              width: double.infinity,
              height: double.infinity,
              "assets/image/error_background.svg",
            ),
            Container(
              width: AppSpacing.maxWidth * 0.32,
              height: AppSpacing.maxHeight * 0.15,
              margin: const EdgeInsets.only(top: 40),
              child: IconViewer(
                controller: controller,
                // colorize: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
