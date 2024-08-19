import 'package:ai_music/modules/song_module.dart';
import 'package:ai_music/services/api.dart';
import 'package:ai_music/services/local_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

enum NavBarOption { trending, generate, songs, settings }

enum GenerateSongSteps { text, style, loading }

class HomeController extends GetxController {
  final store = Get.find<LocalStorageService>();
  final Api _api = Api();
  List<SongModule> trending = [];
  List<SongModule> mySongs = [];
  List<String> styles = [];
  String selectedStyle = '';
  NavBarOption option = NavBarOption.trending;
  GenerateSongSteps steps = GenerateSongSteps.text;
  TextEditingController textEditingController = TextEditingController();
  bool buttonState = false;
  @override
  void onInit() async {
    super.onInit();
    String? cookie = await store.getCookies();
    String? newSid = await store.getUserSid();
    _api.applyCookie(cookie!, newSid!);
    _api.getSongMetadata().then((value) {
      trending = value;
      update();
    });
    _api.getMySongs().then((value) {
      mySongs = value;
      update();
    });
    _api.getStyles().then((value) {
      styles = value;
      update();
    });
  }

  changeOption(NavBarOption navBarOption) {
    option = navBarOption;
    update();
  }

  changeStep(GenerateSongSteps newStep) {
    steps = newStep;
    update();
  }

  generate() async {
    steps = GenerateSongSteps.loading;
    await _api
        .generateSong(textEditingController.text, selectedStyle)
        .then((value) async {
      await _api.getMySongs().then((value) {
        mySongs = value;
        update();
      });
    });
    Future.delayed(const Duration(seconds: 3), () {
      option = NavBarOption.songs;
      steps = GenerateSongSteps.text;
      update();
    });
  }

  selectStyle(String style) {
    selectedStyle = style;
    update();
  }
}
