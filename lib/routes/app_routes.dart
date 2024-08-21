import 'package:flutter/material.dart';
import 'package:psyche/screens/history_screen.dart';
import '../screens/home_screen.dart';
import '../screens/screening_screen.dart';
import '../screens/education_screen.dart';
import '../screens/education_video_screen.dart'; 
import '../screens/education_audio_screen.dart'; 
import '../screens/education_text_screen.dart'; 
import '../screens/chat_ai_screen.dart';
import '../screens/noted_screen.dart';
import '../screens/login_screen.dart';
import '../screens/register_screen.dart';
import '../screens/splash_screen.dart';
import '../screens/onboarding_screen.dart';
import '../screens/add_note_screen.dart'; // Import AddNoteScreen

class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String home = '/home';
  static const String screening = '/screening';
  static const String education = '/education';
  static const String educationVideo = '/education/video'; 
  static const String educationAudio = '/education/audio'; 
  static const String educationText = '/education/text'; 
  static const String chatAI = '/chat-ai';
  static const String noted = '/noted';
  static const String login = '/login';
  static const String register = '/register';
  static const String addNote = '/add-note'; 
  static const String history = '/history';

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
      educationVideo: (context) => const EducationVideoScreen(), 
      educationAudio: (context) => const EducationAudioScreen(), 
      educationText: (context) => const EducationTextScreen(), 
      chatAI: (context) => const ChatAiScreen(),
      noted: (context) => const NotedScreen(),
      login: (context) => const LoginScreen(),
      register: (context) => const RegisterScreen(),
      addNote: (context) {
        final Map<String, String>? note = ModalRoute.of(context)?.settings.arguments as Map<String, String>?;
        return AddNoteScreen(note: note);
      }, 
      history: (context) => const HistoryScreen()
    };
  }
}
