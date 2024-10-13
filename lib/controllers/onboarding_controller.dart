import 'package:ai_music/app_routes.dart';
import 'package:ai_music/config/contant.dart';
import 'package:ai_music/config/data.dart';
import 'package:ai_music/services/local_storage.dart';
import 'package:get/get.dart';

class OnboardingController extends GetxController {
  int index = 0;
  final store = Get.find<LocalStorageService>();
  bool isLoading = false;
  @override
  void onInit() async {
    super.onInit();
    store.clean();
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
    isLoading = true;
    update();
    switch (index) {
      case 0:
        Future.delayed(Duration(seconds: onboardingClickTime), () async {
          index = 1;
          isLoading = false;
          update();
        });
      case 1:
        Future.delayed(Duration(seconds: onboardingClickTime), () async {
          isLoading = false;
          index = 2;
          update();
        });
      case 2:
        Future.delayed(Duration(seconds: onboardingClickTime), () async {
          isLoading = false;
          index = 3;
          update();
        });
      default:
        await store.saveFirst();
        checkCookies();
    }
    update();
  }

  checkCookies() async{
    if(AppData.settingModule.cookies.isNotEmpty){
      await store.setCookies(AppData.settingModule.cookies);
      Future.delayed(Duration(seconds: onboardingClickTime), () async {
        isLoading = false;
        Get.toNamed(AppRoutes.home);
        update();
      });
      return ;
    }
    store.getCookies().then((value) async {
      if (value == null) {
        Future.delayed(Duration(seconds: onboardingClickTime), () async {
          isLoading = false;
          Get.toNamed(AppRoutes.auth);
          update();
        });
      } else {
        Future.delayed(Duration(seconds: onboardingClickTime), () async {
          isLoading = false;
          Get.toNamed(AppRoutes.home);
          update();
        });
      }
    });
  }
}
