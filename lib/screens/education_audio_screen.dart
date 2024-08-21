import 'package:flutter/material.dart';

class EducationAudioScreen extends StatelessWidget {
  const EducationAudioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edukasi Audio'),
      ),
      body: Center(
        child: const Text('Konten Audio Edukasi tentang Depresi'),
      ),
    );
  }
}
