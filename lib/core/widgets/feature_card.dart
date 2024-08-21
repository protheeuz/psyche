import 'package:flutter/material.dart';

class FeatureCard extends StatelessWidget {
  final String iconPath;
  final String label; // Tambahkan label untuk teks
  final Gradient gradient;
  final VoidCallback onTap;

  const FeatureCard({
    super.key,
    required this.iconPath,
    required this.label, 
    required this.gradient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 55,
            height: 55,
            decoration: BoxDecoration(
              gradient: gradient,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Image.asset(
                iconPath,
                width: 24,
                height: 24,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 4), // Jarak kecil antara ikon dan teks
          Text(
            label, // Tampilkan label
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.black,
              fontFamily: 'OpenSans',
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}