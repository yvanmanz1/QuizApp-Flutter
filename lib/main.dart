import 'package:flutter/material.dart';
import 'package:quizapp/screens/registration_screen.dart';
import 'package:quizapp/services/notif_service.dart';

void main() {
  runApp(MaterialApp(
    home: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Color.fromRGBO(12, 69, 92, 1),
        appBar: AppBar(
          title: Text('Quiz App Example'),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              NotificationService().showNotification(
                  title: 'NEW',
                  body:
                      'Check out our new quiz or progress with your exsting one');
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SignUpScreen(),
                ),
              );
            },
            child: Text('Start Quiz'),
          ),
        ),
      ),
    );
  }
}
