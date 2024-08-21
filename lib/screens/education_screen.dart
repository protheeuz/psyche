import 'package:flutter/material.dart';
import '../core/constants/app_strings.dart';
import '../core/widgets/custom_feature_card.dart';
import '../core/constants/app_colors.dart'; // Jika Anda ingin menggunakan warna dari AppColors
import '../routes/app_routes.dart'; // Untuk navigasi rute

class EducationScreen extends StatelessWidget {
  const EducationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.selectEducationMethod),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Teks "Pilihan Edukasi" dengan font OpenSans
            const Text(
              'Pilihan Edukasi',
              style: TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 16), // Spasi di antara teks dan kartu

            // CustomFeatureCards untuk Video, Audio, dan Teks
            CustomFeatureCard(
              title: 'Video',
              subtitle: 'Tonton dan pelajari lebih lanjut tentang depresi.',
              buttonText: 'Pilih',
              onButtonPressed: () {
                Navigator.pushNamed(context, AppRoutes.educationVideo);
              },
              iconData: Icons.videocam, // Menggunakan IconData dari Flutter
              gradient: AppColors.kGradient,
            ),
            CustomFeatureCard(
              title: 'Audio',
              subtitle: 'Dengarkan materi tentang depresi.',
              buttonText: 'Pilih',
              onButtonPressed: () {
                Navigator.pushNamed(context, AppRoutes.educationAudio);
              },
              iconData: Icons.audiotrack, // Menggunakan IconData dari Flutter
              gradient: const LinearGradient(
                colors: [Color(0xFFFC5C7D), Color(0xFF6A82FB)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            CustomFeatureCard(
              title: 'Text',
              subtitle: 'Baca dan pahami tentang depresi melalui teks.',
              buttonText: 'Pilih',
              onButtonPressed: () {
                Navigator.pushNamed(context, AppRoutes.educationText);
              },
              iconData: Icons.article, // Menggunakan IconData dari Flutter
              gradient: const LinearGradient(
                colors: [Color(0xFFFF9A9E), Color(0xFFFFD2A5)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}