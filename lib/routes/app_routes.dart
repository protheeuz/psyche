import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../screens/screening_screen.dart';
import '../screens/education_screen.dart';
import '../screens/chat_ai_screen.dart';
import '../screens/noted_screen.dart';
import '../screens/login_screen.dart';
import '../screens/register_screen.dart';

class AppRoutes {
  static const String home = '/';
  static const String screening = '/screening';
  static const String education = '/education';
  static const String chatAI = '/chat-ai';
  static const String noted = '/noted';
  static const String login = '/login';
  static const String register = '/register';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      home: (context) => HomeScreen(),
      screening: (context) => const ScreeningScreen(),
      education: (context) => EducationScreen(),
      chatAI: (context) => ChatAiScreen(),
      noted: (context) => NotedScreen(),
      login: (context) => LoginScreen(),
      register: (context) => RegisterScreen(),
    };
  }
}