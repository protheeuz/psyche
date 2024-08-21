import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../screens/screening_screen.dart';
import '../screens/education_screen.dart';
import '../screens/chat_ai_screen.dart';
import '../screens/noted_screen.dart';
import '../screens/login_screen.dart';
import '../screens/register_screen.dart';
import '../screens/splash_screen.dart';
import '../screens/onboarding_screen.dart'; // Import onboarding screen

class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String home = '/home';
  static const String screening = '/screening';
  static const String education = '/education';
  static const String chatAI = '/chat-ai';
  static const String noted = '/noted';
  static const String login = '/login';
  static const String register = '/register';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      splash: (context) => const SplashScreen(),
      onboarding: (context) => const OnBoardingScreen(),
      home: (context) => const HomeScreen(),
      screening: (context) {
        // Mendapatkan userId dari SharedPreferences atau dari argumen
        final int userId = ModalRoute.of(context)!.settings.arguments as int;
        return ScreeningScreen(userId: userId);
      },
      education: (context) => EducationScreen(),
      chatAI: (context) => const ChatAiScreen(),
      noted: (context) => NotedScreen(),
      login: (context) => const LoginScreen(),
      register: (context) => const RegisterScreen(),
    };
  }
}
