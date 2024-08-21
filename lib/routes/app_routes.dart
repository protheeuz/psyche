import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../screens/screening_screen.dart';
import '../screens/education_screen.dart';
import '../screens/education_video_screen.dart'; // Tambahkan ini
import '../screens/education_audio_screen.dart'; // Tambahkan ini
import '../screens/education_text_screen.dart'; // Tambahkan ini
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
  static const String educationVideo = '/education/video'; // Tambahkan ini
  static const String educationAudio = '/education/audio'; // Tambahkan ini
  static const String educationText = '/education/text'; // Tambahkan ini
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
        final int userId = ModalRoute.of(context)!.settings.arguments as int;
        return ScreeningScreen(userId: userId);
      },
      education: (context) => const EducationScreen(),
      educationVideo: (context) => const EducationVideoScreen(), // Rute baru
      educationAudio: (context) => const EducationAudioScreen(), // Rute baru
      educationText: (context) => const EducationTextScreen(), // Rute baru
      chatAI: (context) => const ChatAiScreen(),
      noted: (context) => NotedScreen(),
      login: (context) => const LoginScreen(),
      register: (context) => const RegisterScreen(),
    };
  }
}