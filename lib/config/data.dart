import 'package:ai_music/modules/ads_module.dart';
import 'package:ai_music/modules/auth_config.dart';
import 'package:ai_music/modules/setting_module.dart';

class AppData {
  static SettingModule settingModule = SettingModule(
    shareTitle: "",
    adsModule: AdsModule(
      admobId: "admobId",
      fanId: "a77955ee-3304-4635-be65-81029b0f5201",
      state: "state",
      admobInterstitial: "ca-app-pub-3940256099942544/1033173712",
      admobRewarded: "ca-app-pub-3940256099942544/5224354917",
      admobNative: "/6499/example/native",
      fanInterstitial: "IMG_16_9_APP_INSTALL#2312433698835503_2650502525028617",
      fanRewarded: "YOUR_PLACEMENT_ID",
      fanNative: "IMG_16_9_APP_INSTALL#2312433698835503_2964953543583512",
      isActive: true,
      provider: 'fan',
      appOpenAd: '', //admob // fan // admob_fan
    ),
    shareText: "",
    shareLinkUrl: "",
    taskLink: "",
    contact: "",
    privacyPolicy: "",
    hasPub: true,
    pubImage: "https://picsum.photos/200/300",
    onesignalKey: "24d2051d-2f6d-43e6-a08b-f4f7f276252a",
    pupLink: 'https://picsum.photos/200/300',
    cookies: '',
  );

  static List<AuthConfig> authConfigs = [
    AuthConfig(
      url: '',
      cookies: [
        AuthCookies(
          index: 0,
          name: '',
          value: '',
        ),
      ],
    )
  ];
}
