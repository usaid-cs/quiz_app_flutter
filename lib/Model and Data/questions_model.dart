class Questions {
  Questions({required this.questionText, required this.optionsList});

  final String questionText;
  final List<String> optionsList;

  String get question => questionText;
  List<String> get options => optionsList;
}
