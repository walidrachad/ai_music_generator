import 'package:ai_music/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
        init: AuthController(),
        builder: (controller) {
          return Scaffold(
            body: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).padding.top,
                ),
                Expanded(child: _buildWebView(controller)),
              ],
            ),
          );
        });
  }

  Widget _buildWebView(AuthController authController) {
    return InAppWebView(
      initialUrlRequest: URLRequest(
          url: WebUri(
              "https://accounts.suno.com/sign-in?redirect_url=https%3A%2F%2Fsuno.com%2Fme")),
      initialSettings: InAppWebViewSettings(
          mediaPlaybackRequiresUserGesture: false,
          allowsInlineMediaPlayback: true,
          iframeAllowFullscreen: true,
          userAgent: "random"),
      onWebViewCreated: authController.setWebController,
      onPermissionRequest: (controller, request) async {
        return PermissionResponse(
          resources: request.resources,
          action: PermissionResponseAction.GRANT,
        );
      },
      onLoadStop: (controller, url) async {
        authController.getCookies();
      },
    );
  }
}
