import 'package:http/http.dart' as http;
import 'dart:convert';
import 'question.dart';

class DBconnect {
  final url = Uri.parse(
      'https://quizapp-f0e03-default-rtdb.firebaseio.com/questions.json');

  Future<void> addQuestion(Question question) async {
    http.post(url,
        body: json.encode({
          'id': question.id,
          'question': question.text,
          'options': question.options,
          'answer': question.correctAnswer,
        }));
  }

  Future<void> fetchQuestion() async {
    http.get(url).then((response) {
      var quiz = json.decode(response.body);
    });
  }

  Future<void> deleteQuestion(int questionId) async {
    final deleteUrl = Uri.parse('$url/$questionId.json');
    await http.delete(deleteUrl);
  }
}
