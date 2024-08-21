import 'package:flutter/material.dart';

class EducationVideoScreen extends StatelessWidget {
  const EducationVideoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edukasi Video'),
      ),
      body: Center(
        child: const Text('Konten Video Edukasi tentang Depresi'),
      ),
    );
  }
}
