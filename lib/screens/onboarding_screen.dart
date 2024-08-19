import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../routes/app_routes.dart'; // Import AppRoutes untuk navigasi
import '../core/constants/app_colors.dart'; // Import untuk kGradient

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  late PageController _pageController;
  int _pageIndex = 0;

  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // Fungsi yang dipanggil saat onboarding selesai
  void _onDone() {
    Navigator.pushReplacementNamed(context, AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: _onDone,
                  child: const Text(
                    'Lewati',
                    style: TextStyle(
                      color: Colors.greenAccent,
                      fontFamily: 'OpenSans',
                    ),
                  ),
                ),
              ),
              Expanded(
                child: PageView.builder(
                  itemCount: demoData.length,
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _pageIndex = index;
                    });
                  },
                  itemBuilder: (context, index) => OnBoardContent(
                    animation: demoData[index].animation,
                    title: demoData[index].title,
                    description: demoData[index].description,
                  ),
                ),
              ),
              Row(
                children: [
                  ...List.generate(
                    demoData.length,
                    (index) => Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: DotIndicator(
                        isActive: index == _pageIndex,
                      ),
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    height: 55,
                    width: 55,
                    child: InkWell(
                      onTap: () {
                        if (_pageIndex == demoData.length - 1) {
                          _onDone();
                        } else {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.ease,
                          );
                        }
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        height: 55,
                        width: 55,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: AppColors.kGradient, // Menggunakan kGradient dari app_colors.dart
                        ),
                        child: const Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DotIndicator extends StatelessWidget {
  const DotIndicator({
    super.key,
    this.isActive = false,
  });

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: isActive ? 12 : 4,
      width: 4,
      decoration: BoxDecoration(
        color: isActive
            ? Colors.greenAccent
            : Colors.greenAccent.withOpacity(0.4),
        borderRadius: const BorderRadius.all(
          Radius.circular(12),
        ),
      ),
    );
  }
}

class OnBoard {
  final String animation, title, description;

  OnBoard({
    required this.animation,
    required this.title,
    required this.description,
  });
}

final List<OnBoard> demoData = [
  OnBoard(
    animation: "assets/animations/animation2.json",
    title: "Hi, periksa kualitas gabah beras kamu dengan\nAplikasi kami",
    description:
        "Disini kamu bisa mendeteksi kualitas gabah beras kamu hanya dengan memasukkan foto saja, lho.",
  ),
  OnBoard(
    animation: "assets/animations/animation3.json",
    title: "Kamu dapat memeriksa \nsetiap kualitasnya",
    description:
        "Kalian hanya perlu memasukkan foto dan sistem kami akan mendeteksi kualitas gabah beras kamu",
  ),
  OnBoard(
    animation: "assets/animations/animation4.json",
    title: "Menggunakan teknologi \nArtificial Intelligence",
    description:
        "Sistem kami menggunakan Machine Learning untuk mendeteksi kualitas gahah beras dengan menggunakan arsitektur YOLOv9",
  ),
];

class OnBoardContent extends StatelessWidget {
  const OnBoardContent({
    super.key,
    required this.animation,
    required this.title,
    required this.description,
  });

  final String animation, title, description;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        Lottie.asset(
          animation,
          height: 280,
          width: 200,
        ),
        const SizedBox(height: 50),
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'OpenSans',
            fontSize: Theme.of(context).textTheme.headlineSmall?.fontSize,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        Text(
          description,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'OpenSans',
            fontSize: Theme.of(context).textTheme.bodyMedium?.fontSize,
          ),
        ),
        const SizedBox(height: 25),
      ],
    );
  }
}