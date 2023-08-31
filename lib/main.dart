import 'package:flutter/material.dart';
import 'package:quizapp/Screens/quiz_screen.dart';
import 'package:quizapp/Customization/widgets.dart';
import 'package:quizapp/Customization/theme.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(QuizApp());
}

class QuizApp extends StatelessWidget {
  const QuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: GoogleFonts.quicksand().fontFamily,
        textTheme: TextTheme(
          displayLarge: TextStyle(
            fontSize: 20,
            color: textPurple,
          ),
          displayMedium: TextStyle(
            fontSize: 16,
            color: textPurple,
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String activeScreen = "start-screen";

  void changeScreen(String newScreen) {
    setState(() {
      activeScreen = newScreen;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget screenToDisplay = StartScreen(changeScreen: changeScreen);

    if (activeScreen == "start-screen") {
      screenToDisplay = StartScreen(changeScreen: changeScreen);
    }

    if (activeScreen == "quiz-screen") {
      screenToDisplay = QuizScreen(
        changeScreen: changeScreen,
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 99, 20, 227),
        title: const Text("Quiz App"),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 99, 20, 227),
              Color.fromARGB(255, 141, 75, 246),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(child: screenToDisplay),
      ),
    );
  }
}

class StartScreen extends StatefulWidget {
  const StartScreen({super.key, required this.changeScreen});

  final void Function(String newScreen) changeScreen;

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.width;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.calculate,
          color: Color.fromARGB(220, 255, 255, 255),
          size: size > 600 ? 100 : 240,
        ),
        const SizedBox(
          height: 14,
        ),
        Text(
          'A Fun Math Quiz!',
          style: TextStyle(
            fontSize: 16,
            color: textPurple,
          ),
        ),
        const SizedBox(
          height: 14,
        ),
        btn(
          btnText: "Start",
          btnIcon: Icons.play_arrow,
          onClick: () {
            setState(() {
              widget.changeScreen("quiz-screen");
            });
          },
        ),
      ],
    );
  }
}
