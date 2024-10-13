import 'package:ai_music/config/theme/colors.dart';
import 'package:ai_music/controllers/auth_controller.dart';
//import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
        init: AuthController(),
        builder: (controller) {
          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(
            backgroundColor: AppColors.primary,
             leading: IconButton(
               icon: const Icon(
                Icons.refresh,
                 color: Colors.white,
               ),
              onPressed: () {
                if (controller.webViewController != null) {
                  controller.webViewController!.reload();
                }
               },
             ),
             title: const Text(
               "if the login page doesn't appear click here",
               style: TextStyle(fontSize: 15, color: Colors.white),
             ),
           ),
            body: Column(
              children: [
                SizedBox(height: MediaQuery.of(context).padding.top,),
                Expanded(child: _buildWebView(controller, context)),
              ],
            ),
          );
        });
  }

  Widget _buildWebView(AuthController authController, BuildContext context) {
    return Stack(
      children: [
        InAppWebView(
          initialUrlRequest: URLRequest(
              url: WebUri(
                  "https://accounts.suno.com/sign-in?redirect_url=https%3A%2F%2Fsuno.com%2Fme")),
          initialSettings: InAppWebViewSettings(
            mediaPlaybackRequiresUserGesture: false,
            allowsInlineMediaPlayback: true,
            iframeAllowFullscreen: true,
            userAgent: "random",
          ),
          onWebViewCreated: authController.setWebController,
          onPermissionRequest: (controller, request) async {
            return PermissionResponse(
              resources: request.resources,
              action: PermissionResponseAction.GRANT,
            );
          },
          onUpdateVisitedHistory: (controller, url, androidIsReload) {
            if (url.toString().contains("suno.com/me")) {
              authController.setIsLoading();
            }
          },
          onLoadStop: (controller, url) async {
            authController.getCookies();
          },
        ),
        if (authController.isLoading)
          Container(
            color: Colors.black,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child:  const Center(
              child: SizedBox(
                height: 50,
                width: 50,
                child: LoadingIndicator(
                  indicatorType: Indicator.ballSpinFadeLoader,
                  colors: [Colors.white],
                  strokeWidth: 1,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
