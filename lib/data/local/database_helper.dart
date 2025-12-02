import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('lingologic.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final dbFilePath = path.join(dbPath, filePath);

    return await openDatabase(
      dbFilePath,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    // User profiles table
    await db.execute('''
      CREATE TABLE user_profiles (
        id TEXT PRIMARY KEY,
        created_at TEXT NOT NULL,
        streak_days INTEGER NOT NULL DEFAULT 0,
        total_time_minutes INTEGER NOT NULL DEFAULT 0
      )
    ''');

    // Words table
    await db.execute('''
      CREATE TABLE words (
        id TEXT PRIMARY KEY,
        language TEXT NOT NULL,
        word_text TEXT NOT NULL,
        translation TEXT NOT NULL,
        image_url TEXT,
        audio_url TEXT,
        category TEXT NOT NULL
      )
    ''');

    // Word mastery table
    await db.execute('''
      CREATE TABLE word_mastery (
        user_id TEXT NOT NULL,
        word_id TEXT NOT NULL,
        mastery_level INTEGER NOT NULL DEFAULT 0,
        next_review_date TEXT,
        ease_factor REAL NOT NULL DEFAULT 2.5,
        interval_days INTEGER NOT NULL DEFAULT 1,
        last_reviewed TEXT,
        PRIMARY KEY (user_id, word_id),
        FOREIGN KEY (word_id) REFERENCES words(id)
      )
    ''');

    // Game sessions table
    await db.execute('''
      CREATE TABLE game_sessions (
        id TEXT PRIMARY KEY,
        user_id TEXT NOT NULL,
        game_type TEXT NOT NULL,
        start_time TEXT NOT NULL,
        end_time TEXT,
        score INTEGER NOT NULL DEFAULT 0,
        difficulty_level TEXT NOT NULL
      )
    ''');

    // Sync queue table
    await db.execute('''
      CREATE TABLE sync_queue (
        id TEXT PRIMARY KEY,
        user_id TEXT NOT NULL,
        table_name TEXT NOT NULL,
        operation TEXT NOT NULL,
        data TEXT NOT NULL,
        created_at TEXT NOT NULL,
        synced_at TEXT
      )
    ''');

    // Create indexes
    await db.execute('CREATE INDEX idx_word_mastery_user ON word_mastery(user_id)');
    await db.execute('CREATE INDEX idx_word_mastery_review ON word_mastery(next_review_date)');
    await db.execute('CREATE INDEX idx_game_sessions_user ON game_sessions(user_id)');
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }

  // Generic CRUD operations
  Future<int> insert(String table, Map<String, dynamic> data) async {
    final db = await database;
    return await db.insert(table, data);
  }

  Future<List<Map<String, dynamic>>> query(
    String table, {
    bool? distinct,
    List<String>? columns,
    String? where,
    List<Object?>? whereArgs,
    String? groupBy,
    String? having,
    String? orderBy,
    int? limit,
    int? offset,
  }) async {
    final db = await database;
    return await db.query(
      table,
      distinct: distinct,
      columns: columns,
      where: where,
      whereArgs: whereArgs,
      groupBy: groupBy,
      having: having,
      orderBy: orderBy,
      limit: limit,
      offset: offset,
    );
  }

  Future<int> update(
    String table,
    Map<String, dynamic> values, {
    String? where,
    List<Object?>? whereArgs,
  }) async {
    final db = await database;
    return await db.update(table, values, where: where, whereArgs: whereArgs);
  }

  Future<int> delete(
    String table, {
    String? where,
    List<Object?>? whereArgs,
  }) async {
    final db = await database;
    return await db.delete(table, where: where, whereArgs: whereArgs);
  }
}

