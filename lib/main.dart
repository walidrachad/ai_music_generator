import 'package:ai_music/app_routes.dart';
import 'package:ai_music/bindings/auth_binding.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});
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
        initialRoute: AppRoutes.initialRoute,
        initialBinding: AuthBinding(),
        title: 'ai_music',
      ),
    );
  }
}
