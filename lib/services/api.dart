import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:ai_music/config/contant.dart';
import 'package:ai_music/controllers/home_controller.dart';
import 'package:ai_music/modules/auth_config.dart';
import 'package:ai_music/modules/setting_module.dart';
import 'package:ai_music/modules/song_module.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:random_x/random_x.dart';

class Api {
  var dio = Dio();
  static final Api _singleton = Api._internal();
  String token = "";
  String cookie = "";
  String sid = "";
  String ua = RndX.getRandomUA();

  factory Api() {
    return _singleton;
  }

  Api._internal();

  Future<void> applyCookie(String newCookie, String newSid) async {
    cookie = newCookie;
    sid = await getUserId();
  }

  Future<void> updateIfTokenExpired() async {
    if (token.isEmpty) {
      token = await renewToken();
      return;
    }
    JWT jwtToken = JWT.decode(token);
    int exp = jwtToken.payload['exp'];
    if (DateTime.now().millisecondsSinceEpoch ~/ 1000 > exp) {
      token = await renewToken();
    }
    return;
  }

  Future<String> renewToken() async {
    var headers = {
      'Cookie': cookie,
      'User-Agent': ua,
      'Accept': 'application/json',
      'content-type': "application/x-www-form-urlencoded",
      'origin': 'https://suno.com',
      'referer': 'https://suno.com/',
    };
    var response = await dio.request(
      "https://clerk.suno.com/v1/client/sessions/$sid/tokens?_clerk_js_version=5.26.0",
      options: Options(
        method: 'POST',
        headers: headers,
      ),
    );
    if (response.statusCode == 200) {
      token = response.data['jwt'];
      return token;
    } else {
      return '';
    }
  }

  Future<String> getUserId() async {
    var headers = {
      'Cookie': cookie,
      'User-Agent': ua,
      'Accept': 'application/json',
    };
    var response = await dio.request(
      "https://clerk.suno.com/v1/client?_clerk_js_version=5.26.0",
      options: Options(
        method: 'GET',
        headers: headers,
      ),
    );
    if (response.statusCode == 200) {
      return response.data['response']['sessions'][0]['id'];
    } else {
      return "";
    }
  }

  Future<List<SongModule>> getSongMetadata({
    int page = 0,
  }) async {
    List<SongModule> songs = [];
    await updateIfTokenExpired();
    var response = await dio.request(
      TRANDING,
      queryParameters: {"page": page},
      options: Options(
        method: 'GET',
        headers: {
          'Cookie': cookie,
          'User-Agent': ua,
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
      ),
    );
    var data = response.data["playlists"][0]["playlist_clips"] as List;
    songs = data
        .map((element) => SongModule(
              image: element["clip"]["image_url"],
              title: element["clip"]["display_name"],
              description: element["clip"]["title"],
              mp3: element["clip"]["audio_url"],
            ))
        .toList();
    return songs;
  }

  Future<int> getBillingInfo() async {
    await updateIfTokenExpired();
    var response = await dio.request(
      BILLING_INFO,
      options: Options(
        method: 'GET',
        headers: {
          'Cookie': cookie,
          'User-Agent': ua,
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
      ),
    );
    return response.data["total_credits_left"];
  }

  loginOut() async {
    sid = '';
    token = '';
  }

  Future<List<SongModule>> getMySongs({
    required int page,
  }) async {
    await updateIfTokenExpired();
    var response = await dio.request(
      "$MY_LIST?page=$page",
      options: Options(
        method: 'GET',
        headers: {
          'Cookie': cookie,
          'User-Agent': ua,
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
      ),
    );
    var data = response.data["clips"] as List;
    List<SongModule> songs = [];
    songs = data
        .map((element) => SongModule(
              image: element["image_url"],
              title: element["metadata"]["prompt"],
              description: element["display_name"],
              mp3: element["audio_url"],
            ))
        .toList();
    return songs;
  }

  Future<List<String>> getStyles() async {
    await updateIfTokenExpired();
    List<String> styles = [];
    var response = await dio.request(GET_RECOMMEND_STYLES,
        options: Options(method: 'GET', headers: {
          'Cookie': cookie,
          'User-Agent': ua,
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        }));
    var data = response.data["default_styles"] as List;
    for (var i = 0; i <= 25; i++) {
      styles.add(data[i]);
    }
    return styles;
  }

  Future<void> generateSong(String prompt, String style, SongType type) async {
    await updateIfTokenExpired();
    var requestData;
    if (type == SongType.description) {
      requestData = {
        "prompt": prompt,
        "generation_type": "TEXT",
        "gpt_description_prompt": prompt,
        "tags": style,
        "negative_tags": "",
        "mv": "chirp-v3-5",
        "title": "",
        "continue_clip_id": null,
        "continue_at": null,
        "infill_start_s": null,
        "infill_end_s": null
      };
    } else {
      requestData = {
        "prompt": prompt,
        "generation_type": "TEXT",
        "tags": style,
        "negative_tags": "",
        "mv": "chirp-v3-5",
        "title": "",
        "continue_clip_id": null,
        "continue_at": null,
        "infill_start_s": null,
        "infill_end_s": null
      };
    }
    var response = await dio.request(
      'https://studio-api.suno.ai/api/generate/v2/',
      data: requestData,
      options: Options(
        method: 'POST',
        headers: {
          'Cookie': cookie,
          'User-Agent': ua,
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
      ),
    );
    var data = response.data;
  }

  Future<void> downloadFile(String url) async {
    Directory? directory;
    if (Platform.isAndroid) {
      directory = await getExternalStorageDirectory();
    } else {
      directory = await getApplicationDocumentsDirectory();
    }
    await dio.download(
      url,
      "${directory!.path}/${url.split('/').last}",
    );
  }

  Future<SettingModule?> getSetting() async {
    var response =
        await dio.request(SETTING_URL, options: Options(method: 'GET'));
    return SettingModule.fromJson(response.data);
  }

  Future<List<AuthConfig>> getAuthConfig() async {
    var response =
        await dio.request(AUTH_CONFIG_URL, options: Options(method: 'GET'));
    List<dynamic> data = jsonDecode(response.data);
    return data.map((element) => AuthConfig.fromJson(element)).toList();
  }
}
