import 'package:flutter/material.dart';
import 'package:psyche/core/constants/app_colors.dart';
import 'package:psyche/core/widgets/custom_feature_card.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/widgets/feature_card.dart';
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
  int? _score; // buat nullable
  int? _userId; // User ID untuk navigasi

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _setGreetingMessage();
    _loadDepressionStatus(); // Load status depresi pengguna
  }

  // Panggil ini ketika kembali ke home_screen untuk memperbarui data
  void _refreshData() async {
    await _loadUserData();
    await _loadDepressionStatus();
    setState(() {}); // Memastikan UI diperbarui setelah data di-refresh
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _fullName = prefs.getString('full_name') ?? "Pengguna";
      _userId = prefs.getInt('user_id');
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
    int? score = prefs.getInt('depression_score'); // Load score dari SharedPreferences

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
                  child: Column(
                    children: [
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        elevation: 4,
                        child: Container(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
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
                                              color: Colors.blue, 
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 7,
                                              horizontal: 12,
                                            ),
                                            minimumSize: const Size(0, 0),
                                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                          ),
                                          onPressed: () {
                                            if (_userId != null) {
                                              Navigator.pushNamed(
                                                context,
                                                AppRoutes.screening,
                                                arguments: _userId,
                                              ).then((value) {
                                                if (value == true) {
                                                  _refreshData(); // Refresh data setelah kembali dari screening
                                                }
                                              });
                                            }
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
                                    height: 50, 
                                    width: 1, 
                                    color: Colors.grey[400],
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 10.0),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
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
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black54,
                                                fontFamily: 'OpenSans',
                                              ),
                                              maxLines: 3,
                                              overflow: TextOverflow.ellipsis,
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
                                  thickness: 1, 
                                  indent: 0,
                                  endIndent: 0,
                                ),
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  ScoreIndicator(
                                    score: _score ?? 0,
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
                      ),
                      const SizedBox(height: 10),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Fitur Kami",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'OpenSans',
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FeatureCard(
                            iconPath: 'assets/icons/screening.png',
                            label: 'Screening',
                            gradient: AppColors.kGradient,
                            onTap: () {
                              // Pastikan userId tersedia saat menavigasi
                              if (_userId != null) {
                                Navigator.pushNamed(
                                  context,
                                  AppRoutes.screening,
                                  arguments: _userId,
                                );
                              }
                            },
                          ),
                          const SizedBox(width: 15),
                          FeatureCard(
                            iconPath: 'assets/icons/education.png',
                            label: 'Edukasi',
                            gradient: AppColors.kGradient,
                            onTap: () {
                              Navigator.pushNamed(context, AppRoutes.education);
                            },
                          ),
                          const SizedBox(width: 15),
                          FeatureCard(
                            iconPath: 'assets/icons/chats.png',
                            label: 'Chat AI',
                            gradient: AppColors.kGradient,
                            onTap: () {
                              Navigator.pushNamed(context, AppRoutes.chatAI);
                            },
                          ),
                          const SizedBox(width: 15),
                          FeatureCard(
                            iconPath: 'assets/icons/notes.png',
                            label: 'Notes',
                            gradient: AppColors.kGradient,
                            onTap: () {
                              Navigator.pushNamed(context, AppRoutes.noted);
                            },
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomFeatureCard(
                        title: 'CEK Sekarang',
                        subtitle:
                            'Lakukan pengecekan kesehatan mental kamu, yuk!',
                        buttonText: 'CEK',
                        labelText: 'Hot!',
                        iconPath: 'assets/icons/test.png',
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF5B86E5),
                            Color(0xFF36D1DC)
                          ], // Blue to cyan gradient
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        onButtonPressed: () {
                          if (_userId != null) {
                            Navigator.pushNamed(
                              context,
                              AppRoutes.screening,
                              arguments: _userId,
                            );
                          }
                        },
                      ),
                      CustomFeatureCard(
                        title: 'NGOBROL Yuk!',
                        subtitle:
                            'Kamu bisa ngobrol dengan AI yang kami sediakan, lho!',
                        buttonText: 'CHAT',
                        labelText: 'Hot!',
                        iconPath: 'assets/icons/chat.png',
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFFFC5C7D),
                            Color(0xFF6A82FB)
                          ], // Pink to purple gradient
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        onButtonPressed: () {
                          Navigator.pushNamed(context, AppRoutes.chatAI);
                        },
                      ),
                      CustomFeatureCard(
                        title: 'CERITA Aja!',
                        subtitle:
                            'Jangan malu untuk ekspresikan diri kamu, bisa melalui fitur notes, ya!',
                        buttonText: 'TULIS',
                        iconPath: 'assets/icons/noted.png',
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFFFF9A9E),
                            Color.fromARGB(255, 224, 229, 82)
                          ], // Pink to yellow gradient
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        onButtonPressed: () {
                          Navigator.pushNamed(context, AppRoutes.noted);
                        },
                      ),
                    ],
                  ),
                ),
              ),
              // const SizedBox(height: 20),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _refreshData(); // Memperbarui data ketika kembali ke home_screen
  }
}
