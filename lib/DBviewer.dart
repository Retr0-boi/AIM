import 'package:flutter/material.dart';
import 'package:AIM/backend/db_helper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Database Viewer App',
      home: DatabaseViewerPage(),
    );
  }
}

class DatabaseViewerPage extends StatefulWidget {
  const DatabaseViewerPage({super.key});

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
        title: const Text('Database Viewer'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Contents of users table:',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            for (var user in users)
              Text(
                'Username: ${user['username']}, Email: ${user['email']}, password: ${user['password']},mongo_id: ${user['mongo_id']}',
                style: const TextStyle(fontSize: 16.0),
              ),
            const SizedBox(height: 16.0),
            const Text(
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
                'Updation Date: ${user['updation_date']}, Updation Time: ${user['updation_time']}, ',
                style: const TextStyle(fontSize: 16.0),
              ),
          ],
        ),
      ),
    );
  }
}
