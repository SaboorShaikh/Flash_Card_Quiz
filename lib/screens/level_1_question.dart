import 'package:flashcard_quiz1/components/cross_icon.dart';
import 'package:flutter/material.dart';
import 'package:flashcard_quiz1/components/options.dart';
import 'package:flashcard_quiz1/components/db_helper.dart';
import 'dart:async';

class level_1_question extends StatefulWidget {
  const level_1_question({super.key});

  @override
  State<level_1_question> createState() => _level_1_questionState();
}

class _level_1_questionState extends State<level_1_question> {
  List<Map<String, dynamic>> questions = [];
  int currentQuestionIndex = 0;
  String? selectedAnswer;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    List<Map<String, dynamic>> fetchedQuestions =
    await DatabaseHelper.getQuestionsByLevel(1);
    setState(() {
      questions = fetchedQuestions;
    });
  }

  void checkAnswer(String answer) {
    setState(() {
      selectedAnswer = answer;
    });

    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        if (currentQuestionIndex < questions.length - 1) {
          currentQuestionIndex++;
          selectedAnswer = null;
        } else {
          Navigator.pop(context);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    if (questions.isEmpty) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    var currentQuestion = questions[currentQuestionIndex];

    return Scaffold(
      body: Container(
        width: screenWidth,
        height: screenHeight,
        padding: EdgeInsets.only(
          top: screenHeight * 0.08,
          left: screenWidth * 0.05,
          right: screenWidth * 0.05,
        ),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFEF729E), Color(0xFFED896D)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Row with Back Button, Question Counter, and Heart
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const cross_icon(),
                  ),
                  Container(
                    padding: EdgeInsets.all(screenWidth * 0.025),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 2.0),
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      "${currentQuestionIndex + 1}",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: screenWidth * 0.05,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(screenWidth * 0.02),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white60),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.favorite, color: Colors.white),
                        SizedBox(width: 10.0),
                        Text(
                          "3",
                          style: TextStyle(
                            color: Color(0xFFFFFFE6),
                            fontSize: 20.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20.0),

              // Image (Ensures it scales properly)
              Center(
                child: Image.asset(
                  "images/starting.png",
                  width: screenWidth * 0.6,
                ),
              ),

              const SizedBox(height: 20.0),

              // Question Number
              Text(
                "Question ${currentQuestionIndex + 1} of ${questions.length}",
                style: TextStyle(
                  color: const Color(0xFFFFFFE6),
                  fontSize: screenWidth * 0.05,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 20.0),

              // Question Text
              Text(
                "Q: ${currentQuestion['question']}",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: screenWidth * 0.07,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 30.0),

              // Options List
              ...['option1', 'option2', 'option3'].map<Widget>((option) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: Options(
                    optionText: currentQuestion[option],
                    color: selectedAnswer == currentQuestion[option]
                        ? (currentQuestion['correctOption'] == option
                        ? Colors.green
                        : Colors.red)
                        : Colors.transparent, // Keeps consistent design
                    onTap: () => checkAnswer(currentQuestion[option]),
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }
}
