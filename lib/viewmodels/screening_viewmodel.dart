class ScreeningViewModel {
  // Example of managing state for screening feature
  int _score = 0;

  void updateScore(int value) {
    _score += value;
  }

  int getScore() {
    return _score;
  }

  // Additional logic and interaction with repository
}
