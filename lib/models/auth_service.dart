import 'package:albertians/models/userData.dart';
import 'package:albertians/services/api_service.dart';
import 'db_helper.dart';
import 'package:sqflite/sqflite.dart';

class AuthService {
  static Future<UserData?> getUserData() async {
    final Database db = await DBHelper.initDatabase();
    List<Map<String, dynamic>> result = await db.query('users');

    if (result.isNotEmpty) {
      String email = result.first['email'] ?? '';
      String password = result.first['password'] ?? '';
      ApiService apiService = ApiService();
      // print("AUTH: LOGGING IN");
      Map<String, dynamic> loginResult =
          await apiService.loginUser(email, password);
      if (loginResult.containsKey('success') && loginResult['success']) {
        // print("AUTH: LOGIN SUCCESSFUL");
        String mongoId = loginResult['mongo_id'];
        String userName = loginResult['userName'];
        String department = loginResult['department'];
        String batchFrom = loginResult['batch_from'];
        String batchTo = loginResult['batch_to'];
        return UserData(
          mongoId: mongoId,
          username: userName,
          email: email,
          password: password,
          department: department,
          batchFrom: batchFrom,
          batchTo: batchTo,
        );
      } else {
        // print("AUTH: LOGIN FAILED");
        return null;
      }
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
