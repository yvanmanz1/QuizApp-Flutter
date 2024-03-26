import 'package:flutter/material.dart';
import 'package:quizapp/models/question.dart';
import 'package:quizapp/Database/sqlLite_db.dart';

class OfflineQuizScreen extends StatefulWidget {
  @override
  _OfflineQuizScreenState createState() => _OfflineQuizScreenState();
}

class _OfflineQuizScreenState extends State<OfflineQuizScreen> {
  late List<Question> _questions;
  int _currentQuestionIndex = 0;
  int _score = 0;

  @override
  void initState() {
    super.initState();
    _loadQuizData();
  }

  Future<void> _loadQuizData() async {
    DatabaseHelper databaseHelper = DatabaseHelper();
    final db = await databaseHelper.database;

    // List<Question> loadedQuestions = await databaseHelper.getQuestionsForQuiz(db, quizId: 1);
    // setState(() {
    //   _questions = loadedQuestions;
    // });
  }

  void _answerQuestion(int selectedOptionIndex) {
    setState(() {
      if (_questions[_currentQuestionIndex].options[selectedOptionIndex] ==
          _questions[_currentQuestionIndex].correctAnswer) {
        _score++;
      }

      if (_currentQuestionIndex < _questions.length - 1) {
        _currentQuestionIndex++;
      } else {
        _showScoreDialog();
      }
    });
  }

  Future<void> _showScoreDialog() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Quiz Completed'),
          content: Text('Your score: $_score / ${_questions.length}'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);

                setState(() {
                  _currentQuestionIndex = 0;
                  _score = 0;
                });
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Offline Quiz'),
      ),
      body: _questions != null && _questions.isNotEmpty
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Question ${_currentQuestionIndex + 1}/${_questions.length}',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  _questions[_currentQuestionIndex].text,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 20),
                ..._questions[_currentQuestionIndex]
                    .options
                    .asMap()
                    .entries
                    .map(
                      (entry) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: ElevatedButton(
                          onPressed: () => _answerQuestion(entry.key),
                          child: Text(entry.value),
                        ),
                      ),
                    )
                    .toList(),
              ],
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
