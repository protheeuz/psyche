import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'services/local_notification_service.dart'; // Import the service
import 'routes/app_routes.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();
final LocalNotificationService _localNotificationService = LocalNotificationService();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await dotenv.load(fileName: ".env");
  await _localNotificationService.initialize(); 

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Psyche - Kesehatan Mental',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'OpenSans',
        textTheme: Theme.of(context).textTheme.apply(
          fontFamily: 'OpenSans',
        ),
      ),
      initialRoute: AppRoutes.splash,
      routes: AppRoutes.getRoutes(),
      navigatorObservers: [routeObserver],
    );
  }
}