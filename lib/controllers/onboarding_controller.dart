import 'package:ai_music/app_routes.dart';
import 'package:ai_music/services/local_storage.dart';
import 'package:get/get.dart';

class OnboardingController extends GetxController {
  int index = 0;
  final store = Get.find<LocalStorageService>();

  @override
  void onInit() {
    super.onInit();
    checkIsFirst();
  }

  Future<void> checkIsFirst() async {
    await store.getIsFirst().then((value) async {
      if (value != null) {
        if (!value) {
          index = 3;
          update();
        }
      }
    });
  }

  onTap() async {
    switch (index) {
      case 0:
        index = 1;
      case 1:
        index = 2;
      case 2:
        index = 3;
      default:
        await store.saveFirst();
        checkCookies();
    }
    update();
  }

  checkCookies() {
    store.getUserSid().then((value) {
      if (value == null) {
        Get.toNamed(AppRoutes.auth);
      } else {
        Get.toNamed(AppRoutes.home);
      }
    });
  }
}
