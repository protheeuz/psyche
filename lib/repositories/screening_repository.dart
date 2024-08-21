class ScreeningRepository {
  Future<int> calculateScore(List<int> answers) async {
    int score = answers.reduce((a, b) => a + b);
    return score;
  }

  String interpretScore(int score) {
    if (score <= 4) {
      return 'Minimal atau tidak ada depresi';
    } else if (score <= 9) {
      return 'Depresi Ringan';
    } else if (score <= 14) {
      return 'Depresi Sedang';
    } else if (score <= 19) {
      return 'Depresi Sedang - Berat';
    } else {
      return 'Depresi Berat';
    }
  }

  String getStatusImage(int score) {
    if (score <= 4) {
      return 'assets/images/minim.png';
    } else if (score <= 9) {
      return 'assets/images/ringan.png';
    } else if (score <= 14) {
      return 'assets/images/sedang.png';
    } else if (score <= 19) {
      return 'assets/images/sedang-berat.png';
    } else {
      return 'assets/images/berat.png';
    }
  }
}