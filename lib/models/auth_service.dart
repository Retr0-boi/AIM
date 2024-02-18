import 'package:albertians/models/userData.dart';

import 'db_helper.dart';
import 'package:sqflite/sqflite.dart';

class AuthService {
  static Future<UserData?> getUserData() async {
  final Database db = await DBHelper.initDatabase();
  List<Map<String, dynamic>> result = await db.query('users');

  if (result.isNotEmpty) {
    // Assuming you have a column named 'mongo_id' in your users table
    String mongoId = result.first['mongo_id'] ?? '';
    String username = result.first['username'] ?? '';
    String email = result.first['email'] ?? '';
    String password = result.first['password'] ?? '';
    String department = result.first['department'] ?? '';
    String batchFrom = result.first['batch_from'] ?? '';
    String batchTo = result.first['batch_to'] ?? '';

    return UserData(
      mongoId: mongoId,
      username: username,
      email: email,
      password: password,
      department: department,
      batchFrom: batchFrom,
      batchTo: batchTo,
    );
  } else {
    return null;
  }
}

  static Future<bool> isLoggedIn() async {
  UserData? userData = await getUserData();
  return userData?.isLoggedIn ?? false;
}

  static Future<void> logout() async {
    await DBHelper.deleteTables();
  }
}
