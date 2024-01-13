import 'package:AIM/backend/mysql.dart';
import 'dart:async';
import 'package:mysql1/mysql1.dart';
import '../backend/auth_service.dart';


class RegisterUser {
  var db = Mysql();

  Future<void> registerUser(
    String name,
    String dob,
    String batchYearFrom,
    String batchYearTo,
    String department,
    String specialization,
    String email,
    String password,
  ) async {
    String query =
        "INSERT INTO acc_requests (name, DOB, batch_from, batch_to, department, specialization, email, password) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

    try {
      var conn = await db.getConnection();
      await conn.query(
        query,
        [
          name,
          dob,
          batchYearFrom,
          batchYearTo,
          department,
          specialization,
          email,
          password,
        ],
      );
      print('User registered successfully!');
      // Set user as authenticated after successful registration
      await AuthService.login(email, password);
    } catch (e) {
      print('Error registering user: $e');
      if (e is MySqlException && e.errorNumber == 1062) {
        //you need to write the code for this btw
      }
    } finally {
      await db.closeConnection();
    }
  }
  
}
