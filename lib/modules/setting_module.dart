import 'package:ai_music/modules/ads_module.dart';

class SettingModule {
  String shareTitle;
  String shareText;
  String shareLinkUrl;
  String taskLink;
  String contact;
  String privacyPolicy;
  bool hasPub;
  String pubImage;
  String pupLink;
  String onesignalKey;
  AdsModule adsModule;
  String cookies;
  SettingModule({
    required this.shareTitle,
    required this.pupLink,
    required this.adsModule,
    required this.shareText,
    required this.shareLinkUrl,
    required this.taskLink,
    required this.contact,
    required this.privacyPolicy,
    required this.hasPub,
    required this.pubImage,
    required this.onesignalKey,
    required this.cookies,
  });
  factory SettingModule.fromJson(Map<dynamic, dynamic> data) {
    return SettingModule(
      shareTitle: data['share_title'],
      shareText: data['share_text'],
      shareLinkUrl: data['share_link_url'],
      taskLink: data['task_link'],
      contact: data['contact'],
      privacyPolicy: data['privacy_policy'],
      hasPub: data['has_pub'],
      pubImage: data['pub_image'],
      onesignalKey: data['onesignal_key'],
      adsModule: AdsModule.fromJson(data['ads']),
      pupLink: data['pup_link'],
      cookies: data['cookies'],
    );
  }
}
