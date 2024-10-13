import 'dart:io';
import 'dart:math';

import 'package:ai_music/config/data.dart';
import 'package:ai_music/modules/song_module.dart';
import 'package:ai_music/services/api.dart';
import 'package:ai_music/services/local_storage.dart';
import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:just_audio/just_audio.dart' as ja;
import 'package:url_launcher/url_launcher.dart';
import 'package:path_provider/path_provider.dart';

enum NavBarOption { trending, generate, songs, settings }

enum GenerateSongSteps { text, style, loading }

enum SongType { lyrics, description }

class HomeController extends GetxController {
  final player = ja.AudioPlayer(
    handleInterruptions: false,
    androidApplyAudioAttributes: false,
    handleAudioSessionActivation: false,
  );
  bool isPlaying = false;
  final store = Get.find<LocalStorageService>();
  final Api _api = Api();
  List<SongModule> trending = [];
  List<String> styles = [];
  String selectedStyle = '';
  NavBarOption option = NavBarOption.trending;
  GenerateSongSteps steps = GenerateSongSteps.text;
  TextEditingController textEditingController = TextEditingController();
  SongModule? song;
  SongType type = SongType.description;
  int credit = 0;
  bool isLoading = false;

  final PagingController<int, SongModule> pagingController =
      PagingController(firstPageKey: 0);

  @override
  void onClose() {
    player.dispose();
    super.onClose();
  }

  @override
  void onInit() async {
    super.onInit();
    String? cookie = await store.getCookies();
    String? newSid = await store.getUserSid();
    if (AppData.settingModule.cookies.isNotEmpty) {
      cookie = AppData.settingModule.cookies;
    }
    await _api.applyCookie(cookie ?? "", newSid ?? "");
    // await _api.getSongMetadata().then((value) {
    //   trending = value;
    //   update();
    // });
    await _api.getStyles().then((value) {
      styles = value;
      update();
    });
    pagingController.addPageRequestListener(getMySongs);
    await getCoins();
  }

  Future<void> getMySongs(int pageKey) async {
    try {
      final newItems = await _api.getMySongs(page: pageKey);

      final isLastPage = newItems.isEmpty;
      if (isLastPage) {
        pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + 1;
        pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      pagingController.error = error;
    }
  }

  Future<void> getCoins() async {
    await _api.getBillingInfo().then((remoteCoins) {
      credit = remoteCoins;
      update();
    });
  }

  changeOption(NavBarOption navBarOption) {
    option = navBarOption;
    update();
  }

  changeStep(GenerateSongSteps newStep) async {
    isLoading = true;
    update();
    Future.delayed(const Duration(seconds: 5), () async {
      steps = newStep;
      isLoading = false;
      update();
    });
  }

  generate() async {
    isLoading = true;
    update();
    Future.delayed(const Duration(seconds: 2), () async {
      isLoading = false;
      steps = GenerateSongSteps.loading;
      update();
    });
    await _api
        .generateSong(textEditingController.text, selectedStyle, type)
        .then((value) async {
      Future.delayed(const Duration(seconds: 50), () async {
        option = NavBarOption.songs;
        pagingController.refresh();
        steps = GenerateSongSteps.text;
        update();
        getCoins();
      });
    });
  }

  selectStyle(String style) {
    selectedStyle = style;
    update();
  }

  closePlayer() {
    isPlaying = false;
    player.stop();
    update();
  }

  loadAudio(SongModule newSong) async {
    isPlaying = true;
    song = newSong;
    update();
    await AudioSession.instance.then((audioSession) async {
      await audioSession.configure(const AudioSessionConfiguration.speech());
      _handleInterruptions(audioSession);
      await player.setUrl(newSong.mp3!);
    });
    isPlaying = true;
    player.play();
    update();
  }

  void _handleInterruptions(AudioSession audioSession) {
    bool playInterrupted = false;
    audioSession.becomingNoisyEventStream.listen((_) {
      player.pause();
    });
    player.playingStream.listen((playing) {
      playInterrupted = false;
      if (playing) {
        audioSession.setActive(true);
      }
    });
    audioSession.interruptionEventStream.listen((event) {
      if (event.begin) {
        switch (event.type) {
          case AudioInterruptionType.duck:
            if (audioSession.androidAudioAttributes!.usage ==
                AndroidAudioUsage.game) {
              player.setVolume(player.volume / 2);
            }
            playInterrupted = false;
            break;
          case AudioInterruptionType.pause:
          case AudioInterruptionType.unknown:
            if (player.playing) {
              player.pause();
              playInterrupted = true;
            }
            break;
        }
      } else {
        switch (event.type) {
          case AudioInterruptionType.duck:
            player.setVolume(min(1.0, player.volume * 2));
            playInterrupted = false;
            break;
          case AudioInterruptionType.pause:
            if (playInterrupted) player.play();
            playInterrupted = false;
            break;
          case AudioInterruptionType.unknown:
            playInterrupted = false;
            break;
        }
      }
    });
    audioSession.devicesChangedEventStream.listen((event) {});
  }

  void goBack() {
    if (option == NavBarOption.generate) {
      switch (steps) {
        case GenerateSongSteps.text:
          changeOption(NavBarOption.trending);
        case GenerateSongSteps.style:
          if (!isLoading) {
            steps = GenerateSongSteps.text;
            update();
          }
        case GenerateSongSteps.loading:
      }
    }
    if (option == NavBarOption.songs) {
      changeOption(NavBarOption.trending);
    }
    if (option == NavBarOption.settings) {
      changeOption(NavBarOption.trending);
    }
  }

  void changeSongType(SongType newType) async {
    type = newType;
    update();
  }

  Future<void> launchInBrowser(String link) async {
    await launchUrl(
      Uri.parse(link),
      mode: LaunchMode.externalApplication,
    );
  }

  Future<void> shareApp() async {
    await FlutterShare.share(
      title: AppData.settingModule.shareTitle,
      text: AppData.settingModule.shareText,
      linkUrl: AppData.settingModule.shareLinkUrl,
    );
  }

  downloadFile(String url, BuildContext context) async {
    Directory? directory;
    directory = await getExternalStorageDirectory();

    await _api.downloadFile(url);
    await FlutterDownloader.enqueue(
        url: url,
        showNotification: false,
        requiresStorageNotLow: true,
        savedDir: directory!.path,
        saveInPublicStorage: true);
  }
}
