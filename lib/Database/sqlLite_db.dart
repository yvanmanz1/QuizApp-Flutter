import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _database;
  static const String dbName = 'quiz.db';

  static const String quizTable = 'quizzes';
  static const String questionTable = 'questions';
  static const String optionTable = 'options';
  static const String userResponseTable = 'user_responses';

  static const String columnId = 'id';

  static const String columnQuizTitle = 'title';
  static const String columnQuizSynced = 'synced';

  static const String columnQuestionText = 'text';
  static const String columnQuestionQuizId = 'quiz_id';

  static const String columnOptionText = 'text';
  static const String columnOptionQuestionId = 'question_id';
  static const String columnOptionIsCorrect = 'is_correct';

  static const String columnResponseQuestionId = 'question_id';
  static const String columnResponseOptionId = 'option_id';
  static const String columnResponseQuizId = 'quiz_id';
  static const String columnResponseIsSynced = 'synced';

  static DatabaseHelper _instance = DatabaseHelper._();

  factory DatabaseHelper() => _instance;

  DatabaseHelper._();

  Future<Database> get database async {
    if (_database == null) {
      _database = await initDatabase();
    }
    return _database!;
  }

  Future<Database> initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, dbName);

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $quizTable (
            $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
            $columnQuizTitle TEXT,
            $columnQuizSynced INTEGER DEFAULT 0
          )
        ''');

        await db.execute('''
          CREATE TABLE $questionTable (
            $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
            $columnQuestionText TEXT,
            $columnQuestionQuizId INTEGER,
            FOREIGN KEY ($columnQuestionQuizId) REFERENCES $quizTable($columnId)
          )
        ''');

        await db.execute('''
          CREATE TABLE $optionTable (
            $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
            $columnOptionText TEXT,
            $columnOptionIsCorrect INTEGER,
            $columnOptionQuestionId INTEGER,
            FOREIGN KEY ($columnOptionQuestionId) REFERENCES $questionTable($columnId)
          )
        ''');

        await db.execute('''
          CREATE TABLE $userResponseTable (
            $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
            $columnResponseQuizId INTEGER,
            $columnResponseQuestionId INTEGER,
            $columnResponseOptionId INTEGER,
            $columnResponseIsSynced INTEGER DEFAULT 0,
            FOREIGN KEY ($columnResponseQuizId) REFERENCES $quizTable($columnId),
            FOREIGN KEY ($columnResponseQuestionId) REFERENCES $questionTable($columnId),
            FOREIGN KEY ($columnResponseOptionId) REFERENCES $optionTable($columnId)
          )
        ''');
      },
    );
  }
}
