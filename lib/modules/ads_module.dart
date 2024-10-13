class AdsModule {
  bool isActive;
  String provider;
  String admobId;
  String fanId;
  String state;
  String admobInterstitial;
  String admobRewarded;
  String admobNative;
  String fanInterstitial;
  String fanRewarded;
  String fanNative;
  String appOpenAd;

  AdsModule({
    required this.provider,
    required this.isActive,
    required this.admobId,
    required this.fanId,
    required this.state,
    required this.admobInterstitial,
    required this.admobRewarded,
    required this.admobNative,
    required this.fanInterstitial,
    required this.fanRewarded,
    required this.fanNative,
    required this.appOpenAd,
  });

  factory AdsModule.fromJson(Map<dynamic, dynamic> data) {
    return AdsModule(
      isActive: data["is_active"],
      admobId: data["admob_id"],
      fanId: data["fan_id"],
      state: data["state"] ?? "",
      admobInterstitial: data["admob_interstitial"],
      admobRewarded: data["admob_rewarded"],
      admobNative: data["admob_native"],
      fanInterstitial: data["fan_interstitial"],
      fanRewarded: data["fan_rewarded"],
      fanNative: data["fan_native"],
      provider: data["provider"] ?? "admob",
      appOpenAd: data['app_open_Ad'],
    );
  }
}
