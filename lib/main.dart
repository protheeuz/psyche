import 'package:flutter/material.dart';
import 'services/api_service.dart';
import 'routes/app_routes.dart';

void main() {
  final apiService = ApiService(baseUrl: 'http://127.0.0.1:8000'); // Ganti dengan baseUrl Anda

  runApp(MyApp(apiService: apiService));
}

class MyApp extends StatelessWidget {
  final ApiService apiService;

  MyApp({required this.apiService});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Psyche App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: AppRoutes.home,
      routes: AppRoutes.getRoutes(),
    );
  }
}
