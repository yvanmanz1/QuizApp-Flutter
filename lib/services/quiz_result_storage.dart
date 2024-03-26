import 'package:shared_preferences/shared_preferences.dart';

class QuizResultStorage {
  static const String quizResultsKey = 'quiz_results';

  Future<void> storeQuizResult(String quizId, int score) async {
    final prefs = await SharedPreferences.getInstance();
    final storedResults = prefs.getStringList(quizResultsKey) ?? [];

    final updatedResults = Map<String, int>.fromEntries(
      storedResults.map((result) {
        final parts = result.split(':');
        return MapEntry(parts[0], int.parse(parts[1]));
      }),
    );

    updatedResults[quizId] = score;

    prefs.setStringList(
      quizResultsKey,
      updatedResults.entries
          .map((entry) => '${entry.key}:${entry.value}')
          .toList(),
    );
  }

  Future<Map<String, int>> getQuizResults() async {
    final prefs = await SharedPreferences.getInstance();
    final storedResults = prefs.getStringList(quizResultsKey) ?? [];

    return Map<String, int>.fromEntries(
      storedResults.map((result) {
        final parts = result.split(':');
        return MapEntry<String, int>(parts[0], int.parse(parts[1]));
      }),
    );
  }
}
