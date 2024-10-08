import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CustomFeatureCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String buttonText;
  final VoidCallback onButtonPressed;
  final String? labelText;
  final String? iconPath; // Optional icon path
  final IconData? iconData; // Optional IconData
  final Gradient gradient;

  const CustomFeatureCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.buttonText,
    required this.onButtonPressed,
    required this.gradient,
    this.iconPath, // Optional
    this.iconData, // Optional
    this.labelText = 'Baru!', // Default label text
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 15),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Left Icon: either from Image.asset or IconData
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: iconPath != null
                ? Image.asset(
                    iconPath!,
                    width: 30,
                    height: 30,
                    fit: BoxFit.cover,
                  )
                : Icon(
                    iconData,
                    color: Colors.white,
                    size: 30,
                  ),
          ),
          const SizedBox(width: 10),

          // Title and Subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'OpenSans',
                      ),
                    ),
                    const SizedBox(width: 5),
                    Stack(
                      children: [
                        Shimmer.fromColors(
                          baseColor: Colors.orange,
                          highlightColor: Colors.yellowAccent,
                          child: Container(
                            width: 30,
                            height: 15,
                            decoration: BoxDecoration(
                              color: Colors.orange,
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ),
                        Positioned.fill(
                          child: Center(
                            child: Text(
                              labelText!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontFamily: 'OpenSans',
                  ),
                ),
              ],
            ),
          ),

          OutlinedButton(
            onPressed: onButtonPressed,
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              side: const BorderSide(
                color: Colors.white,
                width: 1.5,
                style: BorderStyle.solid,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(7),
              ),
              fixedSize: const Size(65, 35),
            ),
            child: Text(
              buttonText,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}