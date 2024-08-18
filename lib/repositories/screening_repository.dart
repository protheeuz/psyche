class ScreeningRepository {
  Future<int> calculateScore(List<int> answers) async {
    int score = answers.reduce((a, b) => a + b);
    return score;
  }

  String interpretScore(int score) {
    if (score < 15) {
      return 'Mild Depression';
    } else if (score < 30) {
      return 'Moderate Depression';
    } else {
      return 'Severe Depression';
    }
  }
}
