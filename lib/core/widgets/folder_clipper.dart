import 'package:flutter/material.dart';

class FolderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    double curveHeight = size.height * 0.2;
    double curveWidth = size.width * 0.4;

    // Bagian atas folder dengan lengkungan
    path.moveTo(0, curveHeight);
    path.lineTo(curveWidth, curveHeight);
    path.quadraticBezierTo(
        curveWidth + 10, curveHeight - 20, curveWidth + 40, curveHeight - 20);
    path.lineTo(size.width - 20, curveHeight - 20);
    path.quadraticBezierTo(size.width, curveHeight - 20, size.width, curveHeight);
    
    // Sisi kanan dan bawah folder
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);

    // Tutup path
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
