import 'package:flutter/material.dart';
import 'package:quizapp/Customization/theme.dart';

class DetailedResult extends StatelessWidget {
  const DetailedResult(
      {super.key, required this.resultSummary, required this.screenSize});

  final List<Map<String, Object>> resultSummary;
  final double screenSize;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: screenSize < 600 ? 300 : 150,
      child: Card(
        color: cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              children: resultSummary.map((entry) {
                String questionNumber =
                    ((entry["question_number"] as int) + 1).toString();
                String userAnswer = entry["user-answer"].toString();
                String correctAnswer = entry["correct-answer"].toString();
                bool isAnswerCorrect = userAnswer == correctAnswer;
                return Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 16),
                      alignment: Alignment.center,
                      width: 35,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isAnswerCorrect ? skyBlueColor : pinkColor,
                      ),
                      child: Text(questionNumber,
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium
                              ?.copyWith(color: textPurple)),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Your Answer: $userAnswer ",
                            style: Theme.of(context)
                                .textTheme
                                .displayMedium
                                ?.copyWith(color: Colors.black),
                          ),
                          Text(
                            "Correct Answer: $correctAnswer",
                            style: Theme.of(context)
                                .textTheme
                                .displayMedium
                                ?.copyWith(color: skyBlueColorDark),
                          ),
                          const SizedBox(
                            height: 14,
                          )
                        ],
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}
