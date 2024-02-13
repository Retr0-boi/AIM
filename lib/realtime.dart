import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NotificationsPage extends StatefulWidget {
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  List<String> notifications = [];

  @override
  void initState() {
    super.initState();
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    try {
      // Make HTTP GET request to fetch notifications from the server
      var response = await http.get(Uri.parse('http://192.168.56.1/AIM/api/change_listener.php'));

      if (response.statusCode == 200) {
        // Parse the JSON response and update the notifications list
        setState(() {
          notifications = json.decode(response.body);
        });
      } else {
        // Handle error response
        print('Failed to fetch notifications: ${response.statusCode}');
      }
    } catch (e) {
      // Handle network error
      print('Error fetching notifications: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(notifications[index]),
          );
        },
      ),
    );
  }
}
void main() {
  runApp(MaterialApp(
    home: NotificationsPage(),
  ));
}
