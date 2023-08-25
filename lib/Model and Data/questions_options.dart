import 'package:quizapp/Model%20and%20Data/questions_model.dart';

// Add Questions as Keys and List of Options as Value
Map<String, List<String>> options = {
  "What is the result of 7 + 3?": ["10", "14", "15", "21"],
  "Which of the following is the largest number?": ["9", "15", "6", "20"],
  "If you have 4 apples and you give 2 to your friend, how many apples do you have left?":
      ["6", "2", "0", "3"],
  "What is 6 multiplied by 5?": ["11", "30", "25", "15"],
  "If a triangle has three sides, what is it called when all three sides have equal length?":
      [
    "Isosceles triangle",
    "Right triangle",
    "Equilateral triangle",
    "Scalene triangle"
  ],
};

// Add Correct Options to each questions to the list
List<String> answers = ["10", "20", "2", "30", "Equilateral triangle"];

List<String> questionKeys = options.keys.toList();

List<Questions> questionsList = [
  ...questionKeys.map((question) {
    return Questions(questionText: question, optionsList: options[question]!);
  })
];
