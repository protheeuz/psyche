class ScreeningRepository {
  Future<int> calculateScore(List<int> answers) async {
    // Menjumlahkan nilai dari semua jawaban
    int score = answers.reduce((a, b) => a + b);
    
    // Pastikan skor tidak melebihi 27, karena itu skor maksimal
    return score > 27 ? 27 : score;
  }

  String interpretScore(int score) {
    if (score <= 10) {
      return 'Normal';
    } else if (score <= 16) {
      return 'Depresi Ringan';
    } else if (score <= 21) {
      return 'Depresi Sedang';
    } else {
      return 'Depresi Berat';
    }
  }

  String getStatusImage(int score) {
    if (score <= 10) {
      return 'assets/images/minim.png';
    } else if (score <= 16) {
      return 'assets/images/ringan.png';
    } else if (score <= 21) {
      return 'assets/images/sedang.png';
    } else {
      return 'assets/images/berat.png';
    }
  }
}