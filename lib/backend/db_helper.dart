import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static Future<Database> initDatabase() async {
    return openDatabase(
      join(await getDatabasesPath(), 'your_database_name.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE users(id INTEGER PRIMARY KEY, username TEXT)',
        );
      },
      version: 1,
    );
  }

  static Future<void> insertUser(String username) async {
    final Database db = await initDatabase();
    await db.insert(
      'users',
      {'username': username},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<bool> isUserValid(String username) async {
    final Database db = await initDatabase();
    List<Map<String, dynamic>> result = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [username],
    );
    return result.isNotEmpty;
  }
  static Future<void> deleteUser() async {
    final Database db = await initDatabase();
    await db.delete('users');
  }
}
