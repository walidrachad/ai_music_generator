import 'package:ai_music/app_routes.dart';
import 'package:ai_music/config/contant.dart';
import 'package:ai_music/config/data.dart';
import 'package:ai_music/services/api.dart';
import 'package:ai_music/services/local_storage.dart';
import 'package:gdpr_dialog/gdpr_dialog.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  final store = Get.find<LocalStorageService>();
  final Api api = Api();

  @override
  void onReady() async {
    super.onReady();
    store.clean();
    GdprDialog.instance.resetDecision();
    GdprDialog.instance.showDialog();
    await api.getSetting().then((value) async {
      AppData.settingModule = value!;
      Future.delayed(Duration(seconds: onboardingClickTime), () async {
        Get.toNamed(AppRoutes.onboarding);
      });
    });
  }
}
