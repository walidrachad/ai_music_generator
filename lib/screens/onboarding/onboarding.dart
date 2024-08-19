import 'package:ai_music/config/theme/colors.dart';
import 'package:ai_music/config/theme/text_style.dart';
import 'package:ai_music/controllers/onboarding_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class OnBoarding extends StatelessWidget {
  const OnBoarding({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OnboardingController>(
        init: OnboardingController(),
        builder: (controller) {
          if (controller.index == 3) {
            return _buildLastIntro(controller, context);
          }
          return Scaffold(
            backgroundColor: AppColors.background,
            body: Padding(
              padding:
                  EdgeInsets.only(top: MediaQuery.of(context).padding.top + 30),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildTitle(controller),
                    ],
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  _buildContent(controller, context),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 16, right: 16, top: 16, bottom: 16),
                    child: _buildLabel(controller),
                  ),
                  const Spacer(),
                  _buildBtn(controller, context)
                ],
              ),
            ),
          );
        });
  }

  Widget _buildTitle(OnboardingController controller) {
    switch (controller.index) {
      case 0:
        return Text(
          "Create beautiful music",
          textAlign: TextAlign.center,
          style: AppTextStyle.labelStyle
              .copyWith(fontWeight: FontWeight.bold, fontSize: 30),
        );
      case 1:
        return Text(
          "Customize Your Sound",
          textAlign: TextAlign.center,
          style: AppTextStyle.labelStyle
              .copyWith(fontWeight: FontWeight.bold, fontSize: 30),
        );
      case 2:
        return Text(
          "Download and Share",
          textAlign: TextAlign.center,
          style: AppTextStyle.labelStyle
              .copyWith(fontWeight: FontWeight.bold, fontSize: 30),
        );
      default:
        return Text(
          "Start Create music",
          textAlign: TextAlign.center,
          style: AppTextStyle.labelStyle
              .copyWith(fontWeight: FontWeight.bold, fontSize: 30),
        );
    }
  }

  Widget _buildBtn(OnboardingController controller, BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          left: 24,
          right: 24,
          bottom: MediaQuery.of(context).padding.bottom + 32),
      child: InkWell(
        onTap: controller.onTap,
        child: Container(
          width: double.infinity,
          alignment: Alignment.center,
          decoration: ShapeDecoration(
            color: AppColors.primary,
            shape: RoundedRectangleBorder(
              side: BorderSide(width: 1, color: AppColors.primary),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              getButtonText(controller),
              style: AppTextStyle.labelStyle.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(OnboardingController controller, BuildContext context) {
    switch (controller.index) {
      case 0:
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.4,
          child: Image.asset("assets/image/onboarding_1.png"),
        );
      case 1:
        return Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.4,
          ),
        );
      case 2:
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.4,
          child: Image.asset("assets/image/onboarding_2.png"),
        );
      default:
        return Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.4,
          ),
        );
    }
  }

  Widget _buildLabel(OnboardingController controller) {
    switch (controller.index) {
      case 0:
        return Text(
          "No need to be a music expert. Just choose your mood, genre, and let our AI handle the rest. Craft your perfect track in minutes!",
          textAlign: TextAlign.center,
          style: AppTextStyle.labelStyle,
        );
      case 1:
        return Text(
          "Save your favorite tracks and share them with friends or on social media. Let the world hear your amazing compositions!",
          textAlign: TextAlign.center,
          style: AppTextStyle.labelStyle,
        );
      case 2:
        return Text(
          "Adjust tempo, instruments, and more with our intuitive controls. Fine-tune your music to match your unique style.",
          textAlign: TextAlign.center,
          style: AppTextStyle.labelStyle,
        );
      default:
        return Text(
          "Enter the lyrics you’ve written or the words you want to feature in your song, and leave the rest to us. Our advanced AI will take your input and craft a unique, fully-realized track that captures the essence of your lyrics.",
          textAlign: TextAlign.center,
          style: AppTextStyle.labelStyle,
        );
    }
  }

  String getButtonText(OnboardingController controller) {
    switch (controller.index) {
      case 0:
        return "Get Started";
      case 1:
        return "Move On";
      case 2:
        return "let's get started";
      default:
        return "Start your journey";
    }
  }

  Widget _buildLastIntro(
      OnboardingController controller, BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/image/background.png"),
              fit: BoxFit.fill),
        ),
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).padding.top + 130,
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
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 24),
                          child: _buildTitle(controller),
                        ),
                        _buildContent(controller, context)
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Container(
              color: AppColors.background,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 16, right: 16, top: 16, bottom: 16),
                    child: _buildLabel(controller),
                  ),
                  _buildBtn(controller, context)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
