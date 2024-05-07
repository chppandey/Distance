import 'dart:developer';

import 'package:distance_app/Model/location_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static Database? _database;
  static const String dbName = 'location_database.db';

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    } else {
      _database = await initDatabase();
      return _database!;
    }
  }

  Future<Database> initDatabase() async {
    // Get a location using path_provider
    var directory = await getApplicationDocumentsDirectory();
    var path = join(directory.path, dbName);

    log("path is ${path.toString()}");

    // Open/create the database at a given path
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDb,
    );
  }

  Future<void> _createDb(Database db, int version) async {
    // Create tables
    await db.execute('''
      CREATE TABLE traking_location (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        timestamp TEXT,
        latitude TEXT,
        longitude TEXT,
        accuracy TEXT,
        distance TEXT
      )
    ''');
  }

  Future<void> insertIntoTable(LocationModel insertData) async {
    Database db = await database;
    try {
      await db.insert("traking_location", insertData.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    } catch (e) {
      log("vhj ${e.toString()}");
    }
  }

  Future<List<Map<String, dynamic>>?> getData(String query) async {
    print("wuery--> $query");
    Database db = await database;
    try {
      return await db.rawQuery(
        'SELECT * FROM traking_location WHERE '
        'latitude LIKE ? OR '
        'longitude LIKE ? OR '
        'timestamp LIKE ? OR '
        'accuracy LIKE ? OR '
        'distance LIKE ?',
        [
          '%$query%', // Wildcard for matching any text containing the query
          '%$query%',
          '%$query%',
          '%$query%',
          '%$query%',
        ],
      );
    } catch (e) {
      log(e.toString());
    }
    return null;
  }
}


///where: "distance LIKE?", whereArgs: ["fgh"]