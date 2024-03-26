// login_screen.dart

import 'package:flutter/material.dart';
import 'package:quizapp/models/question.dart';
import 'package:quizapp/screens/quiz_screen.dart';
import 'admin_screen.dart';
import 'package:quizapp/models/db.connection.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:connectivity/connectivity.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final url = Uri.parse(
      'https://quizapp-f0e03-default-rtdb.firebaseio.com/questions.json');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () async {
                String email = _emailController.text;
                String password = _passwordController.text;

                try {
                  if (email == "admin" && password == "admin123") {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CreateQuizScreen(),
                      ),
                    );
                  } else {
                    List<Question> questions =
                        await fetchQuestionsFromBackend();

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => QuizScreen(questions: questions),
                      ),
                    );
                  }
                } catch (e) {
                  print('Error during login: $e');
                }
              },
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
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
