import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static Future<Database> initDatabase() async {
    return openDatabase(
      join(await getDatabasesPath(), 'AIM.db'),
      onCreate: (db, version) {
        // Create 'users' table
        db.execute(
          'CREATE TABLE users(username TEXT, email TEXT, mongo_id TEXT,password TEXT)',
        );
        // Create 'registered_user' table
        db.execute(
          'CREATE TABLE registered_user('
          'id INTEGER PRIMARY KEY,'
          'department TEXT,'
          'current_status TEXT,'
          'current_institution TEXT,'
          'program TEXT,'
          'expected_pass_year TEXT,'
          'current_organisation TEXT,'
          'designation TEXT,'
          'batch_from TEXT,'
          'batch_to TEXT,'
          'name TEXT,'
          'DOB TEXT,'
          'email TEXT,'
          'password TEXT,'
          'account_status TEXT,'
          'identification TEXT,'
          'updation_date TEXT,'
          'updation_time TEXT,'
          'obj_id TEXT,'
          'programme TEXT,'
          'expected_year_of_passing TEXT' // Add this line for the 'expected_year_of_passing' field
          ')',
        );
      },
      version: 1,
    );
  }

 static Future<void> insertUserData(Map<String, dynamic> userData) async {
    final Database db = await initDatabase();

    await db.insert('users', userData);
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

  static Future<void> insertRegistrationData(
      Map<String, dynamic> registrationData) async {
    final Database db = await initDatabase();

    // Insert the registration data into the database using 'registered_user' table
    await db.insert(
      'registered_user',
      registrationData,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  //DELETEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE ON PRODUCTION
  static Future<void> printUsersTable() async {
    final Database db = await initDatabase();
    List<Map<String, dynamic>> users = await db.query('users');

    print('Contents of users table:');
    for (var user in users) {
      print(
          'Username: ${user['username']}, Email: ${user['email']},Password: ${user['password']},mongo_id: ${user['mongo_id']}');
    }
  }

  static Future<void> printRegisteredUserTable() async {
    final Database db = await initDatabase();
    List<Map<String, dynamic>> registeredUsers =
        await db.query('registered_user');

    print('Contents of registered_user table:');
    for (var user in registeredUsers) {
      print(
        'ID: ${user['id']}, Department: ${user['department']}, Program: ${user['program']}, '
        'Batch From: ${user['batch_from']}, Batch To: ${user['batch_to']}, '
        'Name: ${user['name']}, DOB: ${user['DOB']}, Email: ${user['email']}, '
        'Password: ${user['password']}, Account Status: ${user['account_status']}, '
        'Identification: ${user['identification']}, '
        'Updation Date: ${user['updation_date']}, Updation Time: ${user['updation_time']}, '
        'Object ID: ${user['obj_id']}, '
        'Current Status: ${user['current_status']}, '
        'Current Institution: ${user['current_institution']}, '
        'Expected Pass Year: ${user['expected_pass_year']}, '
        'Current Organisation: ${user['current_organisation']}, '
        'Designation: ${user['designation']}',
      );
    }
  }

  static Future<List<Map<String, dynamic>>> getUsersTable() async {
    final Database db = await initDatabase();
    return await db.query('users');
  }

  static Future<List<Map<String, dynamic>>> getRegisteredUserTable() async {
    final Database db = await initDatabase();
    return await db.query('registered_user');
  }

  // TILL HEREEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE
  static Future<Map<String, dynamic>> getUserData() async {
    final Database db = await initDatabase();
    List<Map<String, dynamic>> result = await db.query('users');

    if (result.isNotEmpty) {
      return result.first;
    } else {
      return {}; // Return an empty map if no user data found
    }
  }
  
}
