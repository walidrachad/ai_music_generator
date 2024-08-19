import 'package:ai_music/bindings/auth_binding.dart';
import 'package:ai_music/bindings/home_binding.dart';
import 'package:ai_music/bindings/onboarding_binding.dart';
import 'package:ai_music/bindings/splash_binding.dart';
import 'package:ai_music/screens/auth/auth_screen.dart';
import 'package:ai_music/screens/home/home.dart';
import 'package:ai_music/screens/onboarding/onboarding.dart';
import 'package:ai_music/screens/splash/splash_screen.dart';
import 'package:get/get.dart';

abstract class AppRoutes {
  static const String initialRoute = "/";
  static const String auth = "/login";
  static const String onboarding = "/onboarding";
  static const String home = "/home";

  static final pages = [
    GetPage(
      name: initialRoute,
      page: () => const SplashScreen(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: auth,
      page: () => const AuthScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: onboarding,
      page: () => const OnBoarding(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: home,
      page: () => const HomeScreen(),
      binding: HomeBinding(),
    ),
  ];
}
