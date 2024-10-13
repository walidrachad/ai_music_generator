import 'package:ai_music/app_routes.dart';
import 'package:ai_music/config/data.dart';
import 'package:ai_music/modules/auth_config.dart';
import 'package:ai_music/services/local_storage.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  InAppWebViewController? webViewController;
  final store = Get.find<LocalStorageService>();

  bool hasError = false;
  bool isLoading = false;

  setWebController(InAppWebViewController controller) {
    webViewController = controller;
    update();
  }

  refrech(bool value) {
    hasError = value;
    update();
  }

  Future<void> getCookies() async {
    CookieManager cookieManager = CookieManager.instance();
    await setCookie(cookieManager);
  }

  Future<void> setCookie(CookieManager cookieManager) async {
    List<AuthConfig> authConfigs = AppData.authConfigs;
    for (var authConfig in authConfigs) {
      List<Cookie> list =
          await cookieManager.getCookies(url: WebUri(authConfig.url));
      for (var cookies in authConfig.cookies) {
        for (var element in list) {
          if (element.name == cookies.name) {
            cookies.value = "${element.name}=${element.value};";
          }
        }
      }
    }
    bool isLogin =await concatValues(authConfigs);
    if(isLogin){
      Get.toNamed(AppRoutes.home);
    }
  }

  Future<bool> concatValues(List<AuthConfig> authConfigList) async{
    List<AuthCookies> allCookies = [];
    for (var authConfig in authConfigList) {
      allCookies.addAll(authConfig.cookies);
    }
    bool isLogin = hasEmptyValue(allCookies);
    if(isLogin){
      allCookies.sort((a, b) => a.index.compareTo(b.index));
      await store.setCookies(allCookies.map((cookie) => cookie.value).join());
    }
    return isLogin;
  }

  bool hasEmptyValue(List<AuthCookies> cookiesList) {
    for (var cookie in cookiesList) {
      if (cookie.value.isEmpty) {
        return false;
      }
    }
    return true;
  }

  Future<String> exportSidFromToken(String token) async {
    JWT jwtToken = JWT.decode(token);
    return jwtToken.payload['sid'];
  }

  void setIsLoading() {
    isLoading = true;
    update();
  }
}
