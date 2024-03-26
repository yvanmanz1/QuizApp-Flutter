// signup_screen.dart

import 'package:flutter/material.dart';
import 'package:quizapp/screens/login_screen.dart';
import 'package:quizapp/services/notif_service.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController numberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Names'),
              ),
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(labelText: 'Confirm Password'),
                obscureText: true,
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () async {
                  NotificationService().showNotification(
                      title: 'CONGRATULATIONS!!!',
                      body: 'You have succesfully registered.');

                  String email = emailController.text;
                  String password = passwordController.text;

                  try {
                    print('Registration successful: $email');
                    print(
                        'Token: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6Ijc1Yzg2YTA4LTRiYjYtNDIxMi1iYjJiLWU5ZjA1YWIxNzg3MSIsIm5iZiI6MTcwNzQ2NjA2OCwiZXhwIjoxNzA3NDY5NjY4LCJpYXQiOjE3MDc0NjYwNjgsImlzcyI6Imh0dHA6Ly9sb2NhbGhvc3Q6NjA2NDYiLCJhdWQiOiJodHRwOi8vbG9jYWxob3N0OjYwNjQ2In0.p8wwJqTyu99dEYVKON9kuzrPRcFCtOfYq3HgCdqWCXc');
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginScreen(),
                      ),
                    );
                  } catch (e) {
                    print('Error during registration: $e');
                  }
                },
                child: Text('Sign Up'),
              ),
              ElevatedButton(
                onPressed: () async {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginScreen(),
                    ),
                  );
                },
                child: Text('Have an account. LogIn'),
              ),
            ],
          )),
    );
  }
}
