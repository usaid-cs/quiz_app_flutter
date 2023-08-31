/* The best practice is to extract the duplicate widgets, becuase of limited time I did not focus on that. Due to LayoutBuilder you should
extract widgets and use them according to screen sizes */

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

  Icon showResultIcon(double size) {
    if (userScore == numberOfQuestions) {
      return Icon(
        Icons.star,
        color: starColor,
        size: size,
      );
    } else if (userScore >= numberOfQuestions - 2) {
      return Icon(
        Icons.thumb_up,
        color: textPurple,
        size: size,
      );
    }
    return Icon(
      Icons.heart_broken,
      color: textPurple,
      size: size,
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

    return LayoutBuilder(builder: (cntx, constraint) {
      final size = constraint.maxWidth;
      if (size < 600) {
        return Padding(
          padding: const EdgeInsets.all(12),
          child: questionsNotCompleted
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: size < 600 ? 80 : 40,
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
                        showResultIcon(80),
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
                    DetailedResult(
                      resultSummary: addToSummary(),
                      screenSize: size,
                    ),
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
      } else {
        return Padding(
          padding: const EdgeInsets.all(12.0),
          child: questionsNotCompleted
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 50,
                      child: Text(
                        questionText,
                        style: Theme.of(context).textTheme.displayMedium,
                      ),
                    ),
                    Expanded(
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 5,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                        ),
                        itemCount: options.length,
                        itemBuilder: (cntx, index) {
                          String optionText = options[index];
                          bool isCorrect =
                              optionText == answers[currentQuestionNumber];

                          return GestureDetector(
                            onTap: () {
                              if (onceClicked == false) {
                                setState(() {
                                  userAnswers.add(optionText);
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
                            child: Container(
                              height: 20,
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(40),
                                ),
                                color: cardColors[index],
                                child: ListTile(
                                  title: Text(optionText),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        showResultIcon(40),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          userScoreText,
                          style: Theme.of(context).textTheme.displayLarge,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    DetailedResult(
                      resultSummary: addToSummary(),
                      screenSize: size,
                    ),
                    const SizedBox(
                      height: 2,
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
    });
  }
}
