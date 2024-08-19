import 'package:ai_music/services/local_storage.dart';
import 'package:get/get.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(LocalStorageService(), permanent: true);
  }
}
