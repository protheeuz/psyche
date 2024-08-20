import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../routes/app_routes.dart';
import 'dart:async';
import '../repositories/screening_repository.dart'; // Import repository
import '../core/widgets/score_indicator.dart'; // Import ScoreIndicator widget

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScreeningRepository _screeningRepository = ScreeningRepository();
  String _greetingMessage = "Selamat Datang";
  String _fullName = "Pengguna";
  String _depressionStatus = "Belum ada status saat ini"; // Default status
  String _statusImage = ''; // No image by default
  int? _score; // Membuatnya nullable

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _setGreetingMessage();
    _loadDepressionStatus(); // Load status depresi pengguna
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _fullName = prefs.getString('full_name') ?? "Pengguna";
    });
  }

  void _setGreetingMessage() {
    final hour = DateTime.now().hour;
    if (hour >= 0 && hour < 11) {
      _greetingMessage = "Selamat Pagi";
    } else if (hour >= 11 && hour < 14) {
      _greetingMessage = "Selamat Siang";
    } else if (hour >= 14 && hour < 18) {
      _greetingMessage = "Selamat Sore";
    } else {
      _greetingMessage = "Selamat Malam";
    }
  }

  Future<void> _loadDepressionStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? score =
        prefs.getInt('depression_score'); // Load score dari SharedPreferences

    setState(() {
      _score = score;
      if (_score != null) {
        _depressionStatus = _screeningRepository.interpretScore(_score!);
        _statusImage = _screeningRepository.getStatusImage(_score!);
      } else {
        _depressionStatus = "Kamu belum mendapatkan skor dari pengecekan.";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final double gradientHeight = MediaQuery.of(context).size.height * 0.25;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
            height: gradientHeight,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color.fromARGB(255, 142, 14, 216)
                      .withOpacity(0.8), // Warna ungu lebih tebal
                  const Color.fromARGB(255, 23, 77, 192)
                      .withOpacity(0.6), // Warna biru transparan
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: const [
                  0.0,
                  1.0
                ], // Ungu di kiri atas, biru di kanan bawah
              ),
            ),
          ),
          SizedBox(
            height: gradientHeight,
            width: double.infinity,
            child: Image.asset(
              'assets/images/header.png', // Ganti dengan path gambar Anda
              fit: BoxFit.cover,
              color: Colors.white.withOpacity(0.2), // Mengurangi opacity gambar
              colorBlendMode: BlendMode.dstATop,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: gradientHeight,
                padding: const EdgeInsets.only(
                    left: 20, top: 35, right: 20, bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Halo, $_greetingMessage',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                        color: Colors.white,
                        fontFamily: 'OpenSans',
                      ),
                    ),
                    Text(
                      _fullName.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'OpenSans',
                      ),
                    ),
                  ],
                ),
              ),
              Transform.translate(
                offset: const Offset(0, -80),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    elevation: 4,
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "Aktivitas",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'OpenSans',
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        OutlinedButton(
                                          style: OutlinedButton.styleFrom(
                                            side: const BorderSide(
                                              color:
                                                  Colors.blue, // Border color
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 7,
                                              horizontal: 12,
                                            ),
                                            minimumSize: const Size(0, 0),
                                            tapTargetSize: MaterialTapTargetSize
                                                .shrinkWrap,
                                          ),
                                          onPressed: () {
                                            Navigator.pushNamed(
                                                context, AppRoutes.screening);
                                          },
                                          child: const Text(
                                            "Check Sekarang",
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.blue,
                                              fontFamily: 'OpenSans',
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: 50, // Height of the divider
                                    width: 1, // Thickness of the divider
                                    color: Colors.grey[400],
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(left: 10.0),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          if (_statusImage.isNotEmpty)
                                            Image.asset(
                                              _statusImage,
                                              width: 40,
                                              height: 40,
                                            ),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Text(
                                              _depressionStatus,
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black54,
                                                fontFamily: 'OpenSans',
                                              ),
                                              maxLines: 3, // Max 3 lines
                                              overflow: TextOverflow
                                                  .ellipsis, // Handle overflow
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 15),
                              SizedBox(
                                width: double.infinity,
                                child: Divider(
                                  color: Colors.grey[400],
                                  thickness: 1, // Thicker horizontal divider
                                  indent: 0,
                                  endIndent: 0,
                                ),
                              ),
                              Row(
                                children: [
                                  ScoreIndicator(
                                    score: _score ??
                                        0, // Jika skor belum ada, gunakan skor 0
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    _score != null ? '$_score' : '-',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontFamily: 'OpenSans',
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'Skor kamu saat ini',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                      fontFamily: 'OpenSans',
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      children: [
                        GridView(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                          ),
                          children: [
                            _buildFeatureIcon(context, Icons.assignment,
                                "Screening", AppRoutes.screening),
                            _buildFeatureIcon(context, Icons.school,
                                "Education", AppRoutes.education),
                            _buildFeatureIcon(context, Icons.chat, "Chat AI",
                                AppRoutes.chatAI),
                            _buildFeatureIcon(
                                context, Icons.note, "Noted", AppRoutes.noted),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: Colors.deepPurpleAccent,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Reminder",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'OpenSans',
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    "Check your mood daily",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'OpenSans',
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  // Implement the action for this button
                                },
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.deepPurpleAccent,
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                                child: const Text(
                                  "BUAT",
                                  style: TextStyle(
                                    fontFamily: 'OpenSans',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Screening',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Education',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat AI',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Akun',
          ),
        ],
        onTap: (index) {
          // Handle the bottom navigation bar tap
        },
      ),
    );
  }

  Widget _buildFeatureIcon(
      BuildContext context, IconData icon, String label, String route) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, route);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            backgroundColor: Colors.blueAccent,
            radius: 25,
            child: Icon(icon, size: 30, color: Colors.white),
          ),
          const SizedBox(height: 8),
          Flexible(
            // Wrap the Text widget in Flexible
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                fontFamily: 'OpenSans',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
