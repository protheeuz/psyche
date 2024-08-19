import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF6200EA);
  static const Color secondary = Color(0xFF03DAC6);
  static const Color background = Color(0xFFF6F6F6);
  static const Color textPrimary = Color(0xFF000000);
  static const Color textSecondary = Color(0xFF757575);

  // Warna Gradient
  static const Color gradientStart = Color(0xFFFFFFFF); // Putih
  static const Color gradientEnd = Color(0xFF6200EA); // Ungu
  static const Color gradientMiddle = Color(0xFF03A9F4); // Biru
  
  // Tambahkan LinearGradient di sini
  static const LinearGradient kGradient = LinearGradient(
    colors: [Color(0xFF5B86E5), Color(0xFF36D1DC)], // Biru ke Ungu
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}