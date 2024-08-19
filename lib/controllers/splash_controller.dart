import 'package:ai_music/app_routes.dart';
import 'package:ai_music/services/local_storage.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  final store = Get.find<LocalStorageService>();

  @override
  void onReady() {
    super.onReady();
    Future.delayed(const Duration(seconds: 3), () {
      Get.toNamed(AppRoutes.onboarding);
    });
  }
}
