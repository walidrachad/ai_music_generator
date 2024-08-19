import 'dart:async';

import 'package:ai_music/config/contant.dart';
import 'package:ai_music/modules/song_module.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:dio/dio.dart';
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

  void applyCookie(String newCookie, String newSid) {
    cookie = newCookie;
    sid = newSid;
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
      "https://clerk.suno.com/v1/client/sessions/$sid/tokens?_clerk_js_version=4.73.4",
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

  Future getLimitLeft() async {
    var response =
        await dio.request('https://studio-api.suno.ai/api/billing/info/',
            options: Options(method: 'GET', headers: {
              'Cookie': cookie,
              'User-Agent': ua,
              'Accept': 'application/json',
              'Authorization': 'Bearer $token'
            }));
    return response.data['total_credits_left'];
  }

  Future<List<SongModule>> getSongMetadata({
    int page = 0,
  }) async {
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
    var data = response.data["playlists"] as List;
    List<SongModule> songs = [];
    songs = data
        .map((element) => SongModule(
              image: element["playlist_clips"][0]["clip"]["image_url"],
              title: element["playlist_clips"][0]["clip"]["display_name"],
              description: element["playlist_clips"][0]["clip"]["title"],
              mp3: element["playlist_clips"][0]["clip"]["audio_url"],
            ))
        .toList();
    return songs;
  }

  loginOut() async {
    sid = '';
    token = '';
  }

  Future<List<SongModule>> getMySongs({
    int page = 0,
  }) async {
    await updateIfTokenExpired();
    var response = await dio.request(MY_LIST,
        options: Options(method: 'GET', headers: {
          'Cookie': cookie,
          'User-Agent': ua,
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        }));
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

  Future<void> generateSong(String prompt, String style) async {
    await updateIfTokenExpired();
    var requestData = {
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
}
