import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../config/app_config.dart';

class DatabaseService extends GetxService {
  late Database _database;
  Database get database => _database;

  Future<DatabaseService> init() async {
    _database = await _initDatabase();
    return this;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), AppConfig.databaseName);
    
    return await openDatabase(
      path,
      version: AppConfig.databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Users Table
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT UNIQUE NOT NULL,
        phone TEXT,
        photo_url TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT
      )
    ''');

    // Moods Table
    await db.execute('''
      CREATE TABLE moods (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        mood_level INTEGER NOT NULL,
        note TEXT,
        timestamp TEXT NOT NULL,
        triggers TEXT,
        activities TEXT,
        FOREIGN KEY (user_id) REFERENCES users (id)
      )
    ''');

    // Diary Entries Table
    await db.execute('''
      CREATE TABLE diary_entries (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        title TEXT NOT NULL,
        content TEXT NOT NULL,
        mood_level INTEGER,
        created_at TEXT NOT NULL,
        updated_at TEXT,
        tags TEXT,
        FOREIGN KEY (user_id) REFERENCES users (id)
      )
    ''');

    // Goals Table
    await db.execute('''
      CREATE TABLE goals (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        title TEXT NOT NULL,
        description TEXT,
        category TEXT NOT NULL,
        target_date TEXT NOT NULL,
        is_completed INTEGER DEFAULT 0,
        created_at TEXT NOT NULL,
        completed_at TEXT,
        progress INTEGER DEFAULT 0,
        FOREIGN KEY (user_id) REFERENCES users (id)
      )
    ''');

    // Medications Table
    await db.execute('''
      CREATE TABLE medications (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        name TEXT NOT NULL,
        dosage TEXT,
        frequency TEXT NOT NULL,
        times TEXT NOT NULL,
        start_date TEXT NOT NULL,
        end_date TEXT,
        is_active INTEGER DEFAULT 1,
        notes TEXT,
        FOREIGN KEY (user_id) REFERENCES users (id)
      )
    ''');

    // Skills Table
    await db.execute('''
      CREATE TABLE skills (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        category TEXT NOT NULL,
        content TEXT NOT NULL,
        steps TEXT NOT NULL,
        image_url TEXT,
        difficulty INTEGER DEFAULT 1
      )
    ''');

    // Sleep Records Table
    await db.execute('''
      CREATE TABLE sleep_records (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        sleep_time TEXT NOT NULL,
        wake_time TEXT NOT NULL,
        quality INTEGER NOT NULL,
        notes TEXT,
        duration INTEGER NOT NULL,
        FOREIGN KEY (user_id) REFERENCES users (id)
      )
    ''');

    // Achievements Table
    await db.execute('''
      CREATE TABLE achievements (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        icon TEXT NOT NULL,
        required_points INTEGER NOT NULL,
        is_unlocked INTEGER DEFAULT 0,
        unlocked_at TEXT
      )
    ''');

    // Behaviors Table
    await db.execute('''
      CREATE TABLE behaviors (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        behavior TEXT NOT NULL,
        is_positive INTEGER NOT NULL,
        timestamp TEXT NOT NULL,
        notes TEXT,
        FOREIGN KEY (user_id) REFERENCES users (id)
      )
    ''');

    // Meals Table
    await db.execute('''
      CREATE TABLE meals (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        meal_type TEXT NOT NULL,
        description TEXT NOT NULL,
        timestamp TEXT NOT NULL,
        mood_before INTEGER,
        mood_after INTEGER,
        FOREIGN KEY (user_id) REFERENCES users (id)
      )
    ''');

    // Exercises Table
    await db.execute('''
      CREATE TABLE exercises (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        type TEXT NOT NULL,
        duration INTEGER NOT NULL,
        timestamp TEXT NOT NULL,
        mood_before INTEGER,
        mood_after INTEGER,
        notes TEXT,
        FOREIGN KEY (user_id) REFERENCES users (id)
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Handle database upgrades
  }

  // Generic CRUD Operations
  Future<int> insert(String table, Map<String, dynamic> data) async {
    return await _database.insert(table, data);
  }

  Future<List<Map<String, dynamic>>> query(String table, {
    String? where,
    List<dynamic>? whereArgs,
    String? orderBy,
    int? limit,
  }) async {
    return await _database.query(
      table,
      where: where,
      whereArgs: whereArgs,
      orderBy: orderBy,
      limit: limit,
    );
  }

  Future<int> update(String table, Map<String, dynamic> data, {
    String? where,
    List<dynamic>? whereArgs,
  }) async {
    return await _database.update(
      table,
      data,
      where: where,
      whereArgs: whereArgs,
    );
  }

  Future<int> delete(String table, {
    String? where,
    List<dynamic>? whereArgs,
  }) async {
    return await _database.delete(
      table,
      where: where,
      whereArgs: whereArgs,
    );
  }
}