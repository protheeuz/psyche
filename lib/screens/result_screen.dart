import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';
import '../core/constants/app_colors.dart';
import '../services/local_notification_service.dart';

class ResultScreen extends StatelessWidget {
  final int score;
  final String interpretation;
  final int userId;

  const ResultScreen({
    super.key,
    required this.score,
    required this.interpretation,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    // Mengirim hasil screening ke backend
    _submitScreeningResult();

    // Kirim notifikasi berdasarkan hasil screening
    _sendLocalNotificationWithImage();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hasil Screening'),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 100,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: const LinearGradient(
                        colors: [
                          Colors.green,
                          Colors.lightGreen,
                          Colors.yellow,
                          Colors.orange,
                          Colors.red,
                        ],
                        stops: [0.0, 0.25, 0.5, 0.75, 1.0],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 50,
                    left: (score / 27) * MediaQuery.of(context).size.width - 20,
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 7, horizontal: 11),
                          decoration: BoxDecoration(
                            color: Colors.teal,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '$score',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        CustomPaint(
                          size: const Size(15, 9),
                          painter: TrianglePainter(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text:
                          'Berdasarkan hasil screening yang kamu lakukan sebelumnya, hasil dari screening kamu adalah ',
                      style: const TextStyle(fontSize: 18, color: Colors.black),
                      children: <TextSpan>[
                        TextSpan(
                          text: interpretation,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const TextSpan(
                          text: '.',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context,
                          true); // Mengirim sinyal ke HomeScreen untuk refresh data
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Kembali ke Halaman Utama',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submitScreeningResult() async {
    ApiService apiService = ApiService();
    final response =
        await apiService.submitScreeningResult(score, interpretation, userId);

    if (response.statusCode == 200) {
      print('Screening result submitted successfully');

      SharedPreferences prefs = await SharedPreferences.getInstance();

      // Simpan hasil terbaru, menggantikan hasil sebelumnya
      await prefs.setInt('depression_score', score);
      await prefs.setString('depression_result', interpretation);

      print(
          'Saved score: $score and interpretation: $interpretation to SharedPreferences');
    } else {
      print('Failed to submit screening result: ${response.body}');
    }
  }

  void _sendLocalNotificationWithImage() {
    final LocalNotificationService notificationService = LocalNotificationService();
    String notificationTitle = 'Hasil Screening';
    String notificationBody;
    String imagePath;

    if (score <= 10) {
      notificationBody = 'Yeay!💯Pertahankan kesehatanmu mentalmu terus, ya!';
      imagePath = 'assets/images/minim.png'; 
    } else if (score <= 16) {
      notificationBody = 'Duh!😐Sepertinya kamu ada gejala Depresi Ringan, deh..';
      imagePath = 'assets/images/ringan.png'; 
    } else if (score <= 21) {
      notificationBody = 'Wah!😓 Gawat nih, kamu mencapai Depresi Sedang';
      imagePath = 'assets/images/sedang.png'; 
    } else {
      notificationBody = 'Bahaya!🥵 Kamu mencapai Depresi Berat. Yuk, segera konsultasi ya.';
      imagePath = 'assets/images/berat.png'; 
    }

    notificationService.showNotificationWithImage(
      id: 0,
      title: notificationTitle,
      body: notificationBody,
      imagePath: imagePath,
    );
  }
}

class TrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.teal
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(size.width / 2, size.height)
      ..lineTo(size.width, 0)
      ..lineTo(0, 0)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}