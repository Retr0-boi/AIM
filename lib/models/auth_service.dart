import 'db_helper.dart';
import 'package:sqflite/sqflite.dart';

class AuthService {

  static Future<Map<String, dynamic>> getUserData() async {
    final Database db = await DBHelper.initDatabase();
    List<Map<String, dynamic>> result = await db.query('users');

    if (result.isNotEmpty) {
      // Assuming you have a column named 'mongo_id' in your users table
      String mongoId = result.first['mongo_id'] ?? '';

      return {'isLoggedIn': true, 'mongo_id': mongoId};
    } else {
      return {'isLoggedIn': false, 'mongo_id': ''};
    }
  }

  static Future<bool> isLoggedIn() async {
    Map<String, dynamic> userData = await getUserData();
    return userData['isLoggedIn'] ?? false;
  }

    static Future<void> logout() async {
    await DBHelper.deleteTables();
  }
}
