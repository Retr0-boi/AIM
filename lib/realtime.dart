import 'package:albertians/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
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
      var response = await http.get(Uri.parse(serverUrl+'AIM/api/change_listener.php'));

      if (response.statusCode == 200) {
        // Parse the JSON response and update the notifications list
        setState(() {
          notifications = json.decode(response.body);
        });
      } else {
        // Handle error response
        // print('Failed to fetch notifications: ${response.statusCode}');
      }
    } catch (e) {
      // Handle network error
      // print('Error fetching notifications: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
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
  runApp(const MaterialApp(
    home: NotificationsPage(),
  ));
}
