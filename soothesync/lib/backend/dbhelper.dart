import 'package:soothesync/backend/log.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('anxiety_logs.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();  
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const integerType = 'INTEGER NOT NULL';

    await db.execute('''
      CREATE TABLE anxiety_logs (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        dateTime TEXT NOT NULL,
        heartRate INTEGER NOT NULL,
        oxygenLevel INTEGER NOT NULL,
        anxietyScore INTEGER NOT NULL,
        severityLevel TEXT NOT NULL,
        symptoms TEXT NOT NULL
      );
    ''');
  }

  Future<int> insertLog(AnxietyLog log) async {
    final db = await instance.database;
    final id = await db.insert('anxiety_logs', log.toMap());
    return id;
  }

  Future<List<AnxietyLog>> getLogs() async {
    final db = await instance.database;
    final result = await db.query('anxiety_logs');

    return result.map((map) => AnxietyLog.fromMap(map)).toList();
  }

  Future<List<AnxietyLog>> getLogsByDate(DateTime date) async {
    final db = await instance.database;

    int dateTimeFormat = DateTime(date.year, date.month, date.day).millisecondsSinceEpoch;

    final result = await db.query(
      'anxiety_logs',
      where: 'strftime("%Y-%m-%d", datetime(dateTime / 1000, "unixepoch")) = ?',
      whereArgs: [date.toIso8601String().split('T')[0]],
    );

    return result.isNotEmpty
        ? result.map((map) => AnxietyLog.fromMap(map)).toList()
        : [];
  }
}
