import 'package:quizapp/models/quiz.dart';
import 'package:sqflite/sqflite.dart';

class QuizManager {
  late Database _database;

  QuizManager() {
    initDatabase();
  }

  Future<void> initDatabase() async {
    _database = await openDatabase(
      'quiz_database.db',
      version: 1,
      onCreate: (db, version) {},
    );
  }

  Future<List<Quiz>> getQuizzes() async {
    return [];
  }

  Future<void> addQuiz(Quiz quiz) async {}

  Future<void> editQuiz(Quiz quiz) async {}

  Future<void> deleteQuiz(String quizId) async {}
}
