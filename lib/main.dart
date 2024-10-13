import 'package:ai_music/app_routes.dart';
import 'package:ai_music/bindings/auth_binding.dart';
import 'package:ai_music/config/data.dart';
import 'package:ai_music/services/api.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';


void main() async {
  Api api = Api();
  WidgetsFlutterBinding.ensureInitialized();
  await api.getSetting().then((value) async {
    AppData.settingModule = value!;
  });
  await api.getAuthConfig().then((value) async {
    AppData.authConfigs = value;
  });
  if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
    await InAppWebViewController.setWebContentsDebuggingEnabled(kDebugMode);
  }
  runApp(App(
    initialRoute: AppData.settingModule.cookies.isEmpty
        ? AppRoutes.onboarding
        : AppRoutes.home,
  ));
}

class App extends StatelessWidget {
  const App({super.key, required this.initialRoute});

  final String initialRoute;

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.focusedChild?.unfocus();
        }
      },
      child: GetMaterialApp(
        getPages: AppRoutes.pages,
        debugShowCheckedModeBanner: false,
        initialRoute: initialRoute,
        initialBinding: AuthBinding(),
        title: 'ai_music',
      ),
    );
  }
}
