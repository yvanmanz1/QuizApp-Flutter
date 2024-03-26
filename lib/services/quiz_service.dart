import 'package:quizapp/models/quiz.dart';
import 'package:quizapp/models/result.dart';

class QuizService {
  Future<List<Quiz>> getQuizzes() async {
    try {
      List<Quiz> quizzes = await _fetchQuizzesFromServer();
      return quizzes;
    } catch (e) {
      throw Exception('Failed to fetch quizzes: $e');
    }
  }

  Future<List<Quiz>> _fetchQuizzesFromServer() async {
    return [];
  }

  Future<Result> submitQuiz(List<String> selectedAnswers, String quizId) async {
    int score = calculateScore(selectedAnswers, quizId);
    DateTime completionTime = DateTime.now();

    // Save the result locally
    Result result = Result(
      quizId: quizId,
      score: score,
      completionTime: completionTime,
    );

    return result;
  }

  int calculateScore(List<String> selectedAnswers, String quizId) {
    int correctAnswersCount = 0;

    List<String> correctAnswers = getCorrectAnswers(quizId);

    for (int i = 0; i < selectedAnswers.length; i++) {
      if (selectedAnswers[i] == correctAnswers[i]) {
        correctAnswersCount++;
      }
    }

    int totalQuestions = selectedAnswers.length;
    int score = (correctAnswersCount / totalQuestions * 100).round();

    return score;
  }

  List<String> getCorrectAnswers(String quizId) {
    return [];
  }
}
