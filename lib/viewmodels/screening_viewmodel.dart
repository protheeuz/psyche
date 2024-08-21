class ScreeningViewModel {
  int _score = 0;

  void updateScore(int value) {
    _score += value;
  }

  int getScore() {
    return _score;
  }

}
