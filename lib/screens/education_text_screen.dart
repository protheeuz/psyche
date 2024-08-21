import 'package:flutter/material.dart';

class EducationTextScreen extends StatelessWidget {
  const EducationTextScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edukasi Teks'),
      ),
      body: Center(
        child: const Text('Konten Teks Edukasi tentang Depresi'),
      ),
    );
  }
}
