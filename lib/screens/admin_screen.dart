import 'package:flutter/material.dart';
import 'package:quizapp/models/question.dart';
import 'package:quizapp/models/db.connection.dart';
import 'package:quizapp/screens/quiz_screen.dart';
import 'package:connectivity/connectivity.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CreateQuizScreen extends StatefulWidget {
  @override
  _CreateQuizScreenState createState() => _CreateQuizScreenState();
}

class _CreateQuizScreenState extends State<CreateQuizScreen> {
  TextEditingController _quizTitleController = TextEditingController();
  List<Question> _questions = [];
  final DBconnect _dbConnect = DBconnect();
  final url = Uri.parse(
      'https://quizapp-f0e03-default-rtdb.firebaseio.com/questions.json');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Quiz'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quiz Title',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: _quizTitleController,
              decoration: InputDecoration(labelText: 'Enter Quiz Title'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _showQuestions,
              child: Text('Show Questions'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _questions.length,
                itemBuilder: (context, index) => ListTile(
                  title: Text(_questions[index].text),
                  subtitle: Text(
                      'Correct Answer: ${_questions[index].correctAnswer}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () async {
                          await _dbConnect.deleteQuestion(_questions[index].id);

                          setState(() {
                            _questions.removeAt(index);
                          });
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _addQuestion();
              },
              child: Text('Add Question'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _saveQuiz();
              },
              child: Text('Save Quiz'),
            ),
          ],
        ),
      ),
    );
  }

  void _showQuestions() async {
    List<Question> questions = await fetchQuestionsFromBackend();
    setState(() {
      _questions = questions;
    });
  }

  void _addQuestion() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController _questionController = TextEditingController();
        TextEditingController _option1Controller = TextEditingController();
        TextEditingController _option2Controller = TextEditingController();
        TextEditingController _option3Controller = TextEditingController();
        String _correctAnswer = 'Option 1';
        return AlertDialog(
          title: Text('Add Question'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _questionController,
                  decoration: InputDecoration(labelText: 'Enter Question'),
                ),
                TextField(
                  controller: _option1Controller,
                  decoration: InputDecoration(labelText: 'Option 1'),
                ),
                TextField(
                  controller: _option2Controller,
                  decoration: InputDecoration(labelText: 'Option 2'),
                ),
                TextField(
                  controller: _option3Controller,
                  decoration: InputDecoration(labelText: 'Option 3'),
                ),
                DropdownButtonFormField<String>(
                  value: _correctAnswer,
                  onChanged: (value) {
                    setState(() {
                      _correctAnswer = value!;
                    });
                  },
                  items: ['Option 1', 'Option 2', 'Option 3']
                      .map<DropdownMenuItem<String>>((String option) {
                    return DropdownMenuItem<String>(
                      value: option,
                      child: Text(option),
                    );
                  }).toList(),
                  decoration: InputDecoration(labelText: 'Correct Answer'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _questions.add(Question(
                    id: _questions.length + 1,
                    text: _questionController.text,
                    options: [
                      _option1Controller.text,
                      _option2Controller.text,
                      _option3Controller.text,
                    ],
                    correctAnswer: _correctAnswer,
                  ));
                });
                Navigator.pop(context);
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _saveQuiz() async {
    String quizTitle = _quizTitleController.text;

    _questions.forEach((question) async {
      await _dbConnect.addQuestion(question);
    });

    Navigator.pop(context);
  }

  Future<bool> isInternetConnected() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi;
  }

  Future<List<Question>> fetchQuestionsFromBackend() async {
    if (await isInternetConnected()) {
      List<Question> questions = [];
      await http.get(url).then((response) {
        if (response.statusCode == 200) {
          var data = json.decode(response.body);
          data.forEach((key, value) {
            var question = Question(
              id: value['id'],
              text: value['question'],
              options: List<String>.from(value['options']),
              correctAnswer: value['answer'],
            );
            questions.add(question);
          });
        } else {
          throw Exception('Failed to load questions');
        }
      }).catchError((error) {
        throw Exception('Error fetching questions: $error');
      });
      return questions;
    } else {
      return [
        Question(
            id: 1,
            text: "What is 2 + 2?",
            options: ["3", "4", "5"],
            correctAnswer: "4"),
        Question(
            id: 2,
            text: "What is the capital of France?",
            options: ["London", "Paris", "Rome"],
            correctAnswer: "Paris"),
        Question(
            id: 3,
            text: "What is the largest country in the world?",
            options: ["Brazil", "China", "Russia", "Australia"],
            correctAnswer: "Russia"),
        Question(
            id: 4,
            text: "Who painted the Mona Lisa?",
            options: ["Picasso", "Van Gogh", "Mozart", "Einstein"],
            correctAnswer: "Van Gogh"),
        Question(
            id: 5,
            text: "What is the largest organ in the human body?",
            options: ["Small Intestines", "Skin", "Legs", "Chest"],
            correctAnswer: "Skin"),
      ];
    }
  }
}
