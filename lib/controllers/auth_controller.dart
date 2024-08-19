import 'package:ai_music/app_routes.dart';
import 'package:ai_music/services/local_storage.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  InAppWebViewController? webViewController;
  final store = Get.find<LocalStorageService>();

  setWebController(InAppWebViewController controller) {
    webViewController = controller;
    update();
  }

  Future<void> getCookies() async {
    CookieManager cookieManager = CookieManager.instance();
    await setCookie(cookieManager);
    await getSession(cookieManager);
  }

  Future<void> setCookie(CookieManager cookieManager) async {
    List<Cookie> cookies =
        await cookieManager.getCookies(url: WebUri("https://clerk.suno.com"));
    var client;
    var client_uat;
    var cfuvid;
    var cf_bm;
    for (var cookie in cookies) {
      if (cookie.name == "__client") {
        client = "${cookie.name}=${cookie.value};";
      }
      if (cookie.name == "__client_uat") {
        client_uat = "${cookie.name}=${cookie.value};";
      }
      if (cookie.name == "_cfuvid") {
        cfuvid = "${cookie.name}=${cookie.value};";
      }
      if (cookie.name == "__cf_bm") {
        cf_bm = "${cookie.name}=${cookie.value};";
      }
    }
    await store.setCookies("$cf_bm$cfuvid$client$client_uat");
  }

  Future<void> getSession(CookieManager cookieManager) async {
    List<Cookie> cookies =
        await cookieManager.getCookies(url: WebUri("https://suno.com/"));
    String session = "__session";
    for (var cookie in cookies) {
      if (cookie.name == session) {
        await store.setSid(await exportSidFromToken(cookie.value));
        Get.toNamed(AppRoutes.home);
      }
    }
  }

  Future<String> exportSidFromToken(String token) async {
    JWT jwtToken = JWT.decode(token);
    return jwtToken.payload['sid'];
  }
}
