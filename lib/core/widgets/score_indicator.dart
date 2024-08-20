import 'package:flutter/material.dart';
import 'dart:math';

class ScoreIndicator extends StatelessWidget {
  final int score;

  const ScoreIndicator({super.key, required this.score});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(90, 35), // Ukuran lebih kecil dan lebih rendah
      painter: ScoreIndicatorPainter(score: score),
    );
  }
}

class ScoreIndicatorPainter extends CustomPainter {
  final int score;
  final double maxScore = 27; // Diatur secara default ke 27 sesuai skala PHQ-9

  ScoreIndicatorPainter({required this.score});

  @override
  void paint(Canvas canvas, Size size) {
    // Menurunkan posisi center ke bagian bawah dari canvas
    Offset center = Offset(size.width / 2, size.height);
    double radius = size.width / 2 - 17;

    // Warna untuk setiap bagian dari gauge berdasarkan tingkatan skor
    List<Color> colors = [
      Colors.green,    // 0-4: Minimal atau tidak ada depresi
      Colors.yellow,   // 5-9: Depresi ringan
      Colors.orange,   // 10-14: Depresi sedang
      Colors.orangeAccent, // 15-19: Depresi sedang - berat
      Colors.red,      // 20-27: Depresi berat
    ];

    // Setiap bagian arc menggambarkan bagian yang sesuai dengan tingkatan skor
    List<int> scoreRanges = [4, 9, 14, 19, maxScore.toInt()];
    double startAngle = pi;

    for (int i = 0; i < colors.length; i++) {
      double sweepAngle = (scoreRanges[i] / maxScore) * pi - (i > 0 ? (scoreRanges[i - 1] / maxScore) * pi : 0);
      Paint arcPaint = Paint()
        ..color = colors[i]
        ..style = PaintingStyle.stroke
        ..strokeWidth = 12 // Stroke lebih kecil
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        arcPaint,
      );
      startAngle += sweepAngle;
    }

    // Menghitung sudut jarum berdasarkan skor dan maxScore 27
    double angle = pi + (score / maxScore) * pi;

    // Menggambar jarum
    Paint needlePaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3; // Jarum lebih kecil

    double needleX = center.dx + radius * cos(angle);
    double needleY = center.dy + radius * sin(angle);
    canvas.drawLine(center, Offset(needleX, needleY), needlePaint);

    // Menggambar titik pusat untuk jarum
    Paint dotPaint = Paint()..color = Colors.black;
    canvas.drawCircle(center, 4, dotPaint); // Titik pusat lebih kecil
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
