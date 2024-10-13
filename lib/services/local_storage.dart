import 'package:ai_music/config/contant.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences? sharedPreferences;

class LocalStorageService extends GetxService {
  Future<LocalStorageService> init() async {
    sharedPreferences = await SharedPreferences.getInstance();
    return this;
  }

  Future<void> clean() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
  }
  Future<void> setCookies(String token) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString(TOKEN_KEY, token);
  }

  Future<String?> getCookies() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(TOKEN_KEY);
  }

  Future<String?> getUserSid() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(SID);
  }

  Future<void> setSid(String sid) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString(SID, sid);
  }

  saveFirst() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(IS_FIRST, false);
  }

  Future<bool?> getIsFirst() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(IS_FIRST);
  }

  saveCoins(int value, String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(key, value);
  }

  Future<int?> getCoins(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(key);
  }
}
