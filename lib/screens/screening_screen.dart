import 'package:flutter/material.dart';
import '../core/constants/app_strings.dart';
import '../core/widgets/custom_button.dart';

class ScreeningScreen extends StatefulWidget {
  const ScreeningScreen({super.key});

  @override
  _ScreeningScreenState createState() => _ScreeningScreenState();
}

class _ScreeningScreenState extends State<ScreeningScreen> {
  int _score = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.screeningQuestionnaire),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Text('Question 1: How often do you feel sad?'),
            Row(
              children: [
                Text('Never'),
                Radio(
                  value: 1,
                  groupValue: _score,
                  onChanged: (value) {
                    setState(() {
                      _score = value as int;
                    });
                  },
                ),
                Text('Always'),
                Radio(
                  value: 5,
                  groupValue: _score,
                  onChanged: (value) {
                    setState(() {
                      _score = value as int;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            CustomButton(
              text: 'Submit',
              onPressed: () {
                // Handle the result of the screening
              },
            ),
          ],
        ),
      ),
    );
  }
}
