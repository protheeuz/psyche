import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CustomLoading extends StatelessWidget {
  final bool isLoading;
  final String lottieAsset;
  final double size;

  const CustomLoading({
    super.key,
    required this.isLoading,
    this.lottieAsset = 'assets/animations/loading.json', // Sesuaikan dengan path Lottie Anda
    this.size = 30.0, // Ukuran animasi loading
  });

  @override
  Widget build(BuildContext context) {
    if (!isLoading) return const SizedBox.shrink();
    return Center(
      child: Lottie.asset(
        lottieAsset,
        width: size,
        height: size,
      ),
    );
  }
}