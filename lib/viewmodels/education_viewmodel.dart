class EducationViewModel {
  // Example of managing state for education feature
  String selectedMethod = 'Text';

  void updateMethod(String method) {
    selectedMethod = method;
  }

  String getMethod() {
    return selectedMethod;
  }

  // Additional logic and interaction with repository
}
