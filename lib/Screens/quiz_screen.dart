import 'package:flutter/material.dart';
import 'package:quizapp/Model%20and%20Data/questions_options.dart';
import 'package:quizapp/Customization/theme.dart';
import 'package:quizapp/Customization/widgets.dart';
import 'detailed_result.dart';

class QuizScreen extends StatefulWidget {
  QuizScreen({super.key, required this.changeScreen});

  final void Function(String newScreen) changeScreen;

  @override
  State<QuizScreen> createState() {
    return _QuizScreen();
  }
}

class _QuizScreen extends State<QuizScreen> {
  int userScore = 0;
  int numberOfQuestions = questionKeys.length;
  int currentQuestionNumber = 0;
  bool onceClicked = false;
  List<Color> cardColors = List.filled(4, cardColor);
  List<String> userAnswers = [];

  void resetCardColor() {
    cardColors = List.filled(4, cardColor);
  }

  void answerSuccessful() {
    if (currentQuestionNumber < numberOfQuestions) {
      currentQuestionNumber++;
    }
  }

  void resetAppData() {
    setState(() {
      userScore = 0;
      currentQuestionNumber = 0;
      userAnswers = [];
    });
  }

  Icon showResultIcon() {
    if (userScore == numberOfQuestions) {
      return Icon(
        Icons.star,
        color: starColor,
        size: 80,
      );
    } else if (userScore >= numberOfQuestions - 2) {
      return Icon(
        Icons.thumb_up,
        color: textPurple,
        size: 80,
      );
    }
    return Icon(
      Icons.heart_broken,
      color: textPurple,
      size: 80,
    );
  }

  List<Map<String, Object>> addToSummary() {
    List<Map<String, Object>> resultSummary = [];

    for (int i = 0; i < numberOfQuestions; i++) {
      resultSummary.add({
        "question_number": i,
        "user-answer": userAnswers[i],
        "correct-answer": answers[i],
      });
    }

    return resultSummary;
  }

  @override
  Widget build(BuildContext context) {
    bool questionsNotCompleted = currentQuestionNumber < numberOfQuestions;
    bool isLastQuestion = (currentQuestionNumber + 1) == numberOfQuestions;
    String questionText = questionsNotCompleted
        ? "Question# ${currentQuestionNumber + 1}: ${questionsList[currentQuestionNumber].question}"
        : "";
    List<String> options = questionsNotCompleted
        ? questionsList[currentQuestionNumber].options
        : [];
    String userScoreText =
        "You Scored : ${userScore / numberOfQuestions * 100}%";

    return Padding(
      padding: const EdgeInsets.all(12),
      child: questionsNotCompleted
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 80,
                  child: Text(
                    questionText,
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                ),
                Column(
                  children: options.asMap().entries.map((option) {
                    int index = option.key;
                    String optionText = option.value;
                    bool isCorrect =
                        optionText == answers[currentQuestionNumber];
                    return GestureDetector(
                      onTap: () {
                        if (onceClicked == false) {
                          setState(() {
                            userAnswers.add(option.value);
                            if (isCorrect) {
                              userScore++;
                            }
                            onceClicked = true;
                            cardColors[index] = isCorrect
                                ? correctAnswerColor
                                : wrongAnswerColor;
                          });
                        }
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                        color: cardColors[index],
                        child: ListTile(
                          title: Text(optionText),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(
                  height: 14,
                ),
                btn(
                  btnText: !isLastQuestion ? "Next" : "Show Result",
                  btnIcon: Icons.keyboard_arrow_right,
                  onClick: () {
                    if (onceClicked == true) {
                      setState(() {
                        answerSuccessful();
                        onceClicked = false;
                        resetCardColor();
                      });
                    }
                  },
                )
              ],
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    showResultIcon(),
                    const SizedBox(
                      width: 14,
                    ),
                    Text(
                      userScoreText,
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 18,
                ),
                DetailedResult(resultSummary: addToSummary()),
                const SizedBox(
                  height: 22,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    btn(
                      btnText: "Retake",
                      btnIcon: Icons.restart_alt,
                      onClick: resetAppData,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    btn(
                      btnText: "Menu",
                      btnIcon: Icons.home,
                      onClick: () {
                        resetAppData();
                        widget.changeScreen("start-screen");
                      },
                    ),
                  ],
                )
              ],
            ),
    );
  }
}
