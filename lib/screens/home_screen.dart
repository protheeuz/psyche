import 'package:flutter/material.dart';
import '../routes/app_routes.dart';
import '../core/constants/app_strings.dart';
import '../core/widgets/custom_button.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.appTitle),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CustomButton(
              text: AppStrings.startScreening,
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.screening);
              },
            ),
            SizedBox(height: 20),
            CustomButton(
              text: AppStrings.education,
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.education);
              },
            ),
            SizedBox(height: 20),
            CustomButton(
              text: AppStrings.chatWithAI,
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.chatAI);
              },
            ),
            SizedBox(height: 20),
            CustomButton(
              text: AppStrings.writeNoted,
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.noted);
              },
            ),
          ],
        ),
      ),
    );
  }
}