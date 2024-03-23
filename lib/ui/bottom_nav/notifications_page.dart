import 'package:albertians/models/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:albertians/ui/app_bars/app_bar.dart';
import '../drawer/drawer.dart';
import 'bottom_navigation_bar.dart';
import 'package:albertians/models/userData.dart';
import 'package:albertians/services/api_service.dart';

class Notifications extends StatefulWidget {
  final UserData? userData; // Update the type to UserData

  const Notifications({super.key, this.userData});

  @override
  State<Notifications> createState() => _NotificationsPage();
}

class _NotificationsPage extends State<Notifications> {
  late String department;
  late ApiService apiService;

  @override
  void initState() {
    super.initState();
    apiService = ApiService(); // Initialize apiService heregetNotifications
    _fetchDepartment();
  }

  Future<void> _fetchDepartment() async {
    final userData = await DBHelper.getUserData();
    setState(() {
      department = userData['department'] ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final userData = widget.userData;
    apiService.getNotifications(department); // Call getNotifications here
    return Scaffold(
      appBar: const NotificationsAppBar(),
      drawer: const MyDrawer(),
      bottomNavigationBar: MyBottomNavigationBar(
        currentIndex: 3,
        onItemTapped: (index) {},
        userData: userData, // Pass userData here
      ),
      body: _buildNotificationsList(),
    );
  }

Widget _buildNotificationsList() {
  return FutureBuilder<List<Map<String, dynamic>>>(
    future: apiService.getNotifications(department),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      } else if (snapshot.hasError) {
        return Center(child: Text('Error: ${snapshot.error}'));
      } else if (snapshot.hasData) {
        List<Map<String, dynamic>> notifications = snapshot.data!;
        notifications.sort((a, b) {
          final DateTime? aTimestamp = a['timestamp'] != null
              ? DateTime.parse(a['timestamp'])
              : null;
          final DateTime? bTimestamp = b['timestamp'] != null
              ? DateTime.parse(b['timestamp'])
              : null;
          if (aTimestamp != null && bTimestamp != null) {
            return bTimestamp.compareTo(aTimestamp);
          } else if (aTimestamp != null) {
            return 1; // Move 'a' after 'b'
          } else if (bTimestamp != null) {
            return -1; // Move 'b' after 'a'
          }
          return 0; // Both timestamps are null, leave them in their current order
        });

        Map<String, List<Map<String, dynamic>>> groupedNotifications =
            groupNotificationsByDate(notifications);

        return ListView(
          children: groupedNotifications.entries
              .map((entry) => Column(
                    children: [
                      _buildSectionDivider(entry.key),
                      ...entry.value
                          .map((notification) =>
                              _buildNotificationItem(notification))
                          ,
                    ],
                  ))
              .toList(),
        );
      } else {
        return const Center(child: Text('No notifications available'));
      }
    },
  );
}

Map<String, List<Map<String, dynamic>>> groupNotificationsByDate(
    List<Map<String, dynamic>> notifications) {
  Map<String, List<Map<String, dynamic>>> groupedNotifications = {};
  for (var notification in notifications) {
    String date = notification['timestamp'] ?? 'Unknown Date';
    if (!groupedNotifications.containsKey(date)) {
      groupedNotifications[date] = [];
    }
    groupedNotifications[date]!.add(notification);
  }
  return groupedNotifications;
}
  // bool _isToday(DateTime? timestamp) {
  //   if (timestamp == null) return false;

  //   final now = DateTime.now();
  //   return timestamp.day == now.day &&
  //       timestamp.month == now.month &&
  //       timestamp.year == now.year;
  // }

  Widget _buildSectionDivider(String title) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

Widget _buildNotificationItem(Map<String, dynamic> notification) {
  if (notification['type'] == 'friend_request') {
    return _buildFriendRequestItem(notification);
  }

  String notificationMessage = '';
  // String uwu = notification['type'];
  // Handle different notification types
  switch (notification['type']) {
    case 'job':
      notificationMessage = 'New job available';
      break;
    case 'event':
      notificationMessage = 'New event available';
      break;
    case 'admin':
      notificationMessage = 'New admin notification';
      break;
    // Add more cases as needed
    default:
      notificationMessage = 'Unknown notification type';
      // print("the value is $uwu");
      break;
  }

  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
    child: Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        title: Text(notificationMessage),
        subtitle: Text(notification['timestamp'] ?? ''),
        onTap: () {
          _handleNotificationTap(notification);
        },
      ),
    ),
  );
}
void _handleNotificationTap(Map<String, dynamic> notification) {
  String notificationType = notification['type'];
  switch (notificationType) {
    case 'job':
      // Navigate to job page
      Navigator.pushNamed(context, '/jobPage');
      break;
    case 'event':
      // Navigate to event page
      Navigator.pushNamed(context, '/eventPage');
      break;
    // Add more cases as needed
    default:
      // Handle other notification types
      break;
  }
}
Widget _buildFriendRequestItem(Map<String, dynamic> notification) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
    child: Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          ListTile(
            leading: const CircleAvatar(
              backgroundImage: AssetImage('images/DefaultUserIcon.png'),
              backgroundColor: Colors.transparent,
            ),
            title: Text(
              '${notification['username']} sent a friend request',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            onTap: () {
              // Handle friend request tap
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle approve button tap
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade300,
                    ),
                    child: const Text('Approve'),
                  ),
                ),
                const SizedBox(
                    width: 16.0), // Add some spacing between the buttons
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle disapprove button tap
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade300,
                    ),
                    child: const Text('Disapprove'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
}
