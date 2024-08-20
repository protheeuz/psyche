import 'package:flutter/material.dart';
import 'dart:math';

class ScoreIndicator extends StatelessWidget {
  final int score;
  final Color arcColor;
  final Color needleColor;
  final Color dotColor;

  const ScoreIndicator({
    super.key,
    required this.score,
    this.arcColor = Colors.grey,
    this.needleColor = Colors.red,
    this.dotColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(100, 50),
      painter: ScoreIndicatorPainter(
          score: score,
          arcColor: arcColor,
          needleColor: needleColor,
          dotColor: dotColor),
    );
  }
}

class ScoreIndicatorPainter extends CustomPainter {
  final int score;
  final double maxScore = 27;

  final Color arcColor;
  final Color needleColor;
  final Color dotColor;

  ScoreIndicatorPainter({
    required this.score,
    this.arcColor = Colors.grey,
    this.needleColor = Colors.red,
    this.dotColor = Colors.black,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint arcPaint = Paint()
      ..color = arcColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8.0
      ..strokeCap = StrokeCap.round;

    Paint needlePaint = Paint()
      ..color = needleColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;

    double centerX = size.width / 2;
    double centerY = size.height;
    double radius = min(size.width / 2, size.height) - 10;

    // Menggambar setengah lingkaran (arc)
    Rect rect = Rect.fromCircle(center: Offset(centerX, centerY), radius: radius);
    canvas.drawArc(rect, pi, pi, false, arcPaint);

    // Menghitung sudut jarum berdasarkan skor
    double angle = pi + (score / maxScore) * pi;

    // Menggambar jarum
    double needleX = centerX + radius * cos(angle);
    double needleY = centerY + radius * sin(angle);
    canvas.drawLine(Offset(centerX, centerY), Offset(needleX, needleY), needlePaint);

    // Menggambar titik pusat
    Paint dotPaint = Paint()..color = dotColor;
    canvas.drawCircle(Offset(centerX, centerY), 5, dotPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}