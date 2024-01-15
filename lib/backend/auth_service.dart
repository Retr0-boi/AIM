import 'package:mysql1/mysql1.dart';
import 'package:AIM/backend/mysql.dart';
import 'db_helper.dart';
import 'package:sqflite/sqflite.dart';


class AuthService {
  static Future<bool> login(String username, String password) async {
    final MySqlConnection connection = await Mysql().getConnection();

    try {
      Results results = await connection.query(
        'SELECT * FROM users WHERE email = ? AND password = ? AND locked = ?',
        [username, password,0],
      );

      bool isLoggedIn = results.isNotEmpty;

      if (isLoggedIn) {
        await DBHelper.insertUser(username);
      }

      return isLoggedIn;
    } catch (e) {
      print('Error during login: $e');
      return false;
    } finally {
      await connection.close();
    }
  }

  static Future<bool> isLoggedIn() async {
    // Check if user information is stored in SQLite
    final Database db = await DBHelper.initDatabase();
    List<Map<String, dynamic>> result = await db.query('users');

    return result.isNotEmpty;
  }

  static Future<bool> _checkUsernameValidity(String username) async {
    final MySqlConnection connection = await Mysql().getConnection();

    try {
      Results results = await connection.query(
        'SELECT * FROM users WHERE username = ?',
        [username],
      );

      return results.isNotEmpty;
    } catch (e) {
      print('Error during username validity check: $e');
      return false;
    } finally {
      await connection.close();
    }
  }
  static Future<void> logout() async {
    await DBHelper.deleteUser();
  }
}
