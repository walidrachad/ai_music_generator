import 'dart:io';

import 'package:ai_music/config/data.dart';
import 'package:ai_music/modules/song_module.dart';
import 'package:ai_music/services/api.dart';
//import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:get/get.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:path_provider/path_provider.dart';

class DialogController extends GetxController {
  final String url;
  bool isDownloded = false;
  final Api _api = Api();
  bool exist = false;
  DialogController(this.url);

  downloadFile(String url, BuildContext context) async {
    isDownloded = true;
    update();
    Directory? directory ;

    if(Platform.isAndroid){
      directory = await getExternalStorageDirectory();
    }else{
      directory=await getApplicationDocumentsDirectory();
    }
    await _api.downloadFile(url);
    isDownloded = false;
    update();
    checkIfExist(url).then((value) {
      exist = value;
      update();
    });
    if(Platform.isAndroid){
      await FlutterDownloader.enqueue(
          url: url,
          showNotification: false,
          requiresStorageNotLow: true,
          savedDir: directory!.path,
          saveInPublicStorage: true);
    }else{
       //await FileSaver.instance.saveAs(
                 //name: url.split('/').last,
                //ext: 'mp3',
                 //filePath:'${directory!.path}/${url.split('/').last}' ,
                 //mimeType: MimeType.mp3);
    }
    Get.showSnackbar(
      GetSnackBar(
        animationDuration: const Duration(milliseconds: 500),
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.green.withOpacity(0.3),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).padding.bottom + 16,
          left: 16,
          right: 16,
        ),
        messageText: InkWell(
          onTap: () {
            Get.closeCurrentSnackbar();
          },
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  "Your MP3 file has been successfully downloaded!",
                  style: TextStyle(
                    letterSpacing: 0.5,
                    color: Colors.white,
                    fontSize: 12,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        borderRadius: 8,
      ),
    );
  }


  Future<void> shareApp() async {
    await FlutterShare.share(
      title: AppData.settingModule.shareTitle,
      text: AppData.settingModule.shareText,
      linkUrl: AppData.settingModule.shareLinkUrl,
    );
  }

  Future<bool> checkIfExist(String url) async {
    Directory? directory ;
    if(Platform.isAndroid){
      directory = await getExternalStorageDirectory();
    }else{
      directory=await getApplicationDocumentsDirectory();
    }
    return await File("${directory!.path}/${url.split('/').last}").exists();
  }

  @override
  void onInit() {
    checkIfExist(url).then((value) {
      exist = value;
      update();
    });
    super.onInit();
  }

  void open(String s) async {
    Directory? directory ;
    if(Platform.isAndroid){
      directory = await getExternalStorageDirectory();
    }else{
      directory=await getApplicationDocumentsDirectory();
    }
    final result =
        await OpenFile.open("${directory!.path}/${s.split('/').last}");
  }

  downloadFileForShare(String url) async {
    Directory? directory ;
    if(Platform.isAndroid){
      directory = await getExternalStorageDirectory();
    }else{
      directory=await getApplicationDocumentsDirectory();
    }
    await _api.downloadFile(url);
    if(Platform.isAndroid){
      await FlutterDownloader.enqueue(
          url: url,
          showNotification: false,
          requiresStorageNotLow: true,
          savedDir: directory!.path,
          saveInPublicStorage: true);
    }else{
       //await FileSaver.instance.saveAs(
         //        name: url.split('/').last,
           //     ext: 'mp3',
             //    filePath:'${directory!.path}/${url.split('/').last}' ,
               //  mimeType: MimeType.mp3
       //);
    }
  }
}
