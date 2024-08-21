class EducationViewModel {
  String selectedMethod = 'Text';

  void updateMethod(String method) {
    selectedMethod = method;
  }

  String getMethod() {
    return selectedMethod;
  }

}
