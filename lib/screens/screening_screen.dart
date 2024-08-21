import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../repositories/screening_repository.dart';
import 'result_screen.dart';

class ScreeningScreen extends StatefulWidget {
  final int userId; // Tambahkan parameter userId

  const ScreeningScreen({super.key, required this.userId});

  @override
  _ScreeningScreenState createState() => _ScreeningScreenState();
}

class _ScreeningScreenState extends State<ScreeningScreen> {
  final List<int> _answers = List.filled(9, 0);
  final ScreeningRepository _screeningRepository = ScreeningRepository();
  final PageController _pageController = PageController();
  int _pageIndex = 0;

  final List<String> _questions = [
    'Merasa sedih, depresi, mudah tersinggung, atau putus asa?',
    'Sedikit minat atau kesenangan dalam melakukan sesuatu?',
    'Kesulitan tidur atau tidur terlalu banyak?',
    'Nafsu makan menurun atau makan terlalu banyak?',
    'Merasa lelah atau memiliki sedikit energi?',
    'Merasa buruk tentang diri sendiri atau merasa gagal atau mengecewakan diri sendiri atau keluarga?',
    'Kesulitan berkonsentrasi pada hal-hal seperti pekerjaan sekolah, membaca, atau menonton TV?',
    'Bergerak atau berbicara dengan sangat lambat sehingga orang lain mungkin menyadarinya? Atau sebaliknya, sangat gelisah atau cemas sehingga Anda banyak bergerak lebih dari biasanya?',
    'Pikiran bahwa Anda akan lebih baik mati atau menyakiti diri sendiri dengan cara tertentu?',
  ];

  final List<List<String>> _options = [
    [
      'Tidak Pernah',
      'Beberapa Hari',
      'Lebih dari Setengah Hari',
      'Hampir Setiap Hari'
    ],
    [
      'Tidak Pernah',
      'Beberapa Hari',
      'Lebih dari Setengah Hari',
      'Hampir Setiap Hari'
    ],
    [
      'Tidak Pernah',
      'Beberapa Hari',
      'Lebih dari Setengah Hari',
      'Hampir Setiap Hari'
    ],
    [
      'Tidak Pernah',
      'Beberapa Hari',
      'Lebih dari Setengah Hari',
      'Hampir Setiap Hari'
    ],
    [
      'Tidak Pernah',
      'Beberapa Hari',
      'Lebih dari Setengah Hari',
      'Hampir Setiap Hari'
    ],
    [
      'Tidak Pernah',
      'Beberapa Hari',
      'Lebih dari Setengah Hari',
      'Hampir Setiap Hari'
    ],
    [
      'Tidak Pernah',
      'Beberapa Hari',
      'Lebih dari Setengah Hari',
      'Hampir Setiap Hari'
    ],
    [
      'Tidak Pernah',
      'Beberapa Hari',
      'Lebih dari Setengah Hari',
      'Hampir Setiap Hari'
    ],
    [
      'Tidak Pernah',
      'Beberapa Hari',
      'Lebih dari Setengah Hari',
      'Hampir Setiap Hari'
    ],
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Screening'),
        backgroundColor: Colors.transparent,
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: _questions.length,
        onPageChanged: (index) {
          setState(() {
            _pageIndex = index;
          });
        },
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Pertanyaan dalam Question Box
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
                  child: Text(
                    '${index + 1}. ${_questions[index]}',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 20),
                ..._options[index].asMap().entries.map((option) {
                  return _buildOption(context, index, option.key, option.value);
                }).toList(),
                const Spacer(),
                Align(
                  alignment: Alignment.bottomRight,
                  child: SizedBox(
                    height: 55,
                    width: 55,
                    child: InkWell(
                      onTap: () {
                        if (_pageIndex == _questions.length - 1) {
                          _onSubmit();
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
                          gradient: AppColors.kGradient,
                        ),
                        child: const Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildOption(BuildContext context, int questionIndex, int optionIndex,
      String optionText) {
    bool isSelected = _answers[questionIndex] == optionIndex;
    return GestureDetector(
      onTap: () {
        setState(() {
          _answers[questionIndex] = optionIndex;
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF7C4DFF) : Colors.white,
          border: Border.all(
              color: isSelected ? const Color(0xFF7C4DFF) : Colors.grey,
              width: 1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              height: 25,
              width: 25,
              decoration: BoxDecoration(
                color: isSelected ? Colors.white : const Color(0xFF7C4DFF),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  String.fromCharCode(65 + optionIndex), // A, B, C, D, ...
                  style: TextStyle(
                    color: isSelected ? const Color(0xFF7C4DFF) : Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              optionText,
              style: TextStyle(
                color: isSelected
                    ? const Color.fromARGB(255, 87, 59, 59)
                    : const Color(0xFF7C4DFF),
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onSubmit() async {
    int totalScore = await _screeningRepository.calculateScore(_answers);
    String interpretation = _screeningRepository.interpretScore(totalScore);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResultScreen(
          score: totalScore,
          interpretation: interpretation,
          userId: widget.userId,
        ),
      ),
    ).then((value) {
      if (value == true) {
        Navigator.pop(
            context, true); // Mengirim sinyal ke HomeScreen untuk refresh data
      }
    });
  }
}
