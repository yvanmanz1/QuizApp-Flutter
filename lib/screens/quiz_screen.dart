import 'package:flutter/material.dart';
import 'package:quizapp/models/question.dart';
import 'package:quizapp/services/quiz_result_storage.dart';
import 'package:quizapp/main.dart';

class QuizScreen extends StatefulWidget {
  final List<Question> questions;

  QuizScreen({required this.questions});

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int currentQuestionIndex = 0;
  int score = 0;
  final QuizResultStorage resultStorage = QuizResultStorage();
  Map<int, String> userSelectedAnswers = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Question ${currentQuestionIndex + 1}/${widget.questions.length}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            if (currentQuestionIndex < widget.questions.length)
              Text(
                widget.questions[currentQuestionIndex].text,
                style: TextStyle(fontSize: 16),
              ),
            SizedBox(height: 20),
            if (currentQuestionIndex < widget.questions.length)
              Column(
                children: widget.questions[currentQuestionIndex].options
                    .map((option) => ListTile(
                          title: Text(option),
                          onTap: () {
                            String selectedAnswer = option;
                            userSelectedAnswers[currentQuestionIndex] =
                                selectedAnswer;

                            setState(() {
                              if (currentQuestionIndex <
                                  widget.questions.length - 1) {
                                currentQuestionIndex++;
                              } else {
                                calculateAndDisplayScore();
                              }
                            });
                          },
                        ))
                    .toList(),
              ),
            if (currentQuestionIndex == widget.questions.length)
              Column(
                children: [
                  Text('Quiz Completed!'),
                  Text('Your Score: $score/${widget.questions.length}'),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MyApp(),
                        ),
                      );
                    },
                    child: Text('Finish'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  void calculateAndDisplayScore() async {
    int correctAnswers = 0;

    for (int i = 0; i < widget.questions.length; i++) {
      String selectedAnswer = userSelectedAnswers[i] ?? "";

      if (widget.questions[i].correctAnswer == selectedAnswer) {
        correctAnswers++;
      }
    }

    score = correctAnswers;

    await resultStorage.storeQuizResult('quiz_id', score);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Quiz Completed!'),
          content: Text('Your Score: $score/${widget.questions.length}'),
          actions: [
            ElevatedButton(
              onPressed: () {},
              child: Text('Finish'),
            ),
          ],
        );
      },
    );
  }
}
