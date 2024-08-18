import 'package:flutter/material.dart';
import '../core/constants/app_strings.dart';

class EducationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.selectEducationMethod),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Select a method for learning about depression:'),
            ElevatedButton(
              onPressed: () {
                // Navigate to video education
              },
              child: Text('Video'),
            ),
            ElevatedButton(
              onPressed: () {
                // Navigate to audio education
              },
              child: Text('Audio'),
            ),
            ElevatedButton(
              onPressed: () {
                // Navigate to text education
              },
              child: Text('Text'),
            ),
          ],
        ),
      ),
    );
  }
}