import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:psyche/core/constants/app_colors.dart';
import 'package:psyche/core/widgets/custom_feature_card.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import '../core/widgets/feature_card.dart';
import '../main.dart';
import '../routes/app_routes.dart';
import '../repositories/screening_repository.dart';
import '../core/widgets/score_indicator.dart';
import '../services/api_service.dart';
import 'package:shimmer/shimmer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with RouteAware {
  final ScreeningRepository _screeningRepository = ScreeningRepository();
  final ApiService _apiService = ApiService();
  String _greetingMessage = "Selamat Datang";
  String _fullName = "Pengguna";
  String _depressionStatus = "Belum ada status saat ini";
  String _statusImage = '';
  int? _score;
  int? _userId;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('id_ID', null).then((_) {
      _loadUserData();
      _setGreetingMessage();
      _loadDepressionStatus();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route is PageRoute) {
      routeObserver.subscribe(this, route);
    }
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    print("didPopNext called - refreshing data");
    _refreshData();
  }

  Future<void> _refreshData() async {
    setState(() {
      _isLoading = true;
    });

    await _loadUserData();
    await _loadDepressionStatus();

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _fullName = prefs.getString('full_name') ?? "Pengguna";
      _userId = prefs.getInt('user_id');
    });

    if (_userId != null) {
      // Ambil data dari backend dan simpan di SharedPreferences
      final latestScreening = await _apiService.getLatestScreening(_userId!);
      if (latestScreening != null) {
        setState(() {
          _score = latestScreening['score'];
          _depressionStatus = _screeningRepository.interpretScore(_score!);
          _statusImage = _screeningRepository.getStatusImage(_score!);
        });

        // Simpan di SharedPreferences
        await prefs.setInt('depression_score', _score!);
        await prefs.setString('depression_result', _depressionStatus);
      }
    }
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
    int? score = prefs.getInt('depression_score');

    if (score != null) {
      setState(() {
        _score = score;
        _depressionStatus = _screeningRepository.interpretScore(score);
        _statusImage = _screeningRepository.getStatusImage(score);
      });
    } else {
      setState(() {
        _depressionStatus = "Belum ada status saat ini.";
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushReplacementNamed(context, AppRoutes.login);
  }

  Future<void> _viewHistory() async {
    Navigator.pushNamed(context, AppRoutes.history);
  }

  @override
  Widget build(BuildContext context) {
    final double gradientHeight = MediaQuery.of(context).size.height * 0.25;

    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Stack(
            children: [
              Container(
                height: gradientHeight,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color.fromARGB(255, 142, 14, 216).withOpacity(0.8),
                      const Color.fromARGB(255, 23, 77, 192).withOpacity(0.6),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    stops: const [0.0, 1.0],
                  ),
                ),
              ),
              SizedBox(
                height: gradientHeight,
                width: double.infinity,
                child: Image.asset(
                  'assets/images/header.png',
                  fit: BoxFit.cover,
                  color: Colors.white.withOpacity(0.2),
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
                        children: _isLoading
                            ? _buildShimmerWidgets()
                            : _buildContentWidgets(),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: SpeedDial(
        icon: Icons.add,
        activeIcon: Icons.close,
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        activeBackgroundColor: Colors.lightBlueAccent,
        activeForegroundColor: Colors.white,
        visible: true,
        closeManually: false,
        renderOverlay: false,
        overlayColor: Colors.black,
        overlayOpacity: 0.5,
        curve: Curves.easeIn,
        onOpen: () => print('FAB Opened'),
        onClose: () => print('FAB Closed'),
        elevation: 8.0,
        shape: const CircleBorder(),
        children: [
          SpeedDialChild(
            child: const Icon(Icons.history),
            backgroundColor: Colors.grey,
            label: 'Riwayat',
            labelStyle: const TextStyle(fontSize: 14.0),
            onTap: _viewHistory,
          ),
          SpeedDialChild(
            child: const Icon(Icons.logout),
            backgroundColor: Colors.red,
            label: 'Keluar',
            labelStyle: const TextStyle(fontSize: 14.0),
            onTap: _logout,
          ),
        ],
      ),
    );
  }

  List<Widget> _buildShimmerWidgets() {
    return [
      Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          elevation: 4,
          child: Container(
            padding: const EdgeInsets.all(16.0),
            height: 150,
            width: double.infinity,
          ),
        ),
      ),
      const SizedBox(height: 10),
      Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          height: 150,
          color: Colors.grey[300],
        ),
      ),
    ];
  }

  List<Widget> _buildContentWidgets() {
    return [
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
                                  _refreshData();
                                }
                              });
                            }
                          },
                          child: Text(
                            _score != null ? "Check Kembali" : "Check Sekarang",
                            style: const TextStyle(
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
              if (_userId != null) {
                Navigator.pushNamed(
                  context,
                  AppRoutes.screening,
                  arguments: _userId,
                ).then((value) {
                  if (value == true) {
                    _refreshData();
                  }
                });
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
        subtitle: 'Lakukan pengecekan kesehatan mental kamu, yuk!',
        buttonText: 'CEK',
        labelText: 'Hot!',
        iconPath: 'assets/icons/test.png',
        gradient: const LinearGradient(
          colors: [Color(0xFF5B86E5), Color(0xFF36D1DC)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        onButtonPressed: () {
          if (_userId != null) {
            Navigator.pushNamed(
              context,
              AppRoutes.screening,
              arguments: _userId,
            ).then((value) {
              if (value == true) {
                _refreshData();
              }
            });
          }
        },
      ),
      CustomFeatureCard(
        title: 'NGOBROL Yuk!',
        subtitle: 'Kamu bisa ngobrol dengan AI yang kami sediakan, lho!',
        buttonText: 'CHAT',
        labelText: 'Hot!',
        iconPath: 'assets/icons/chat.png',
        gradient: const LinearGradient(
          colors: [Color(0xFFFC5C7D), Color(0xFF6A82FB)],
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
          colors: [Color(0xFFFF9A9E), Color.fromARGB(255, 224, 229, 82)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        onButtonPressed: () {
          Navigator.pushNamed(context, AppRoutes.noted);
        },
      ),
    ];
  }
}