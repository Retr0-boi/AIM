import 'package:flutter/material.dart';
import 'package:AIM/backend/db_helper.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Database Viewer App',
      home: DatabaseViewerPage(),
    );
  }
}

class DatabaseViewerPage extends StatefulWidget {
  @override
  _DatabaseViewerPageState createState() => _DatabaseViewerPageState();
}
class _DatabaseViewerPageState extends State<DatabaseViewerPage> {
  List<Map<String, dynamic>> users = [];
  List<Map<String, dynamic>> registeredUsers = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    // Fetch data from SQLite tables
    List<Map<String, dynamic>> usersTable = await DBHelper.getUsersTable();
    List<Map<String, dynamic>> registeredUserTable =
        await DBHelper.getRegisteredUserTable();

    setState(() {
      users = usersTable;
      registeredUsers = registeredUserTable;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Database Viewer'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Contents of users table:',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            for (var user in users)
              Text(
                'ID: ${user['id']}, Username: ${user['username']}, Email: ${user['email']}, MongoObjectId: ${user['mongoObjectId']}',
                style: TextStyle(fontSize: 16.0),
              ),
            SizedBox(height: 16.0),
            Text(
              'Contents of registered_user table:',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            for (var user in registeredUsers)
              Text(
                'ID: ${user['id']}, Department: ${user['department']}, Program: ${user['program']}, '
                'Batch From: ${user['batch_from']}, Batch To: ${user['batch_to']}, '
                'Name: ${user['name']}, DOB: ${user['DOB']}, Email: ${user['email']}, '
                'Password: ${user['password']}, Account Status: ${user['account_status']}, '
                'Identification: ${user['identification']}, '
                'Updation Date: ${user['updation_date']}, Updation Time: ${user['updation_time']}, '
                'Object ID: ${user['obj_id']}',
                style: TextStyle(fontSize: 16.0),
              ),
          ],
        ),
      ),
    );
  }
}
