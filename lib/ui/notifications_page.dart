import 'package:flutter/material.dart';
import 'app_bar.dart';
import 'drawer/drawer.dart';
import 'bottom_navigation_bar.dart';

class Notifications extends StatelessWidget implements PreferredSizeWidget {
  const Notifications({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(),
      drawer: const MyDrawer(),
      bottomNavigationBar: MyBottomNavigationBar(
        currentIndex: 3,
        onItemTapped: (index) {},
      ),
      body: _buildNotificationsList(),
    );
  }

  Widget _buildNotificationsList() {
    // Mock data for notifications
    List<Map<String, dynamic>?> notifications = [
      {
        'type': 'welcome',
        'message': 'Welcome to this app!',
        'timestamp': DateTime.now()
      },
      {
        'type': 'friend_request',
        'username': 'John Doe',
        'profilePicture': 'path_to_image',
        'timestamp': DateTime.now()
      },
      {
        'type': 'admin_notification',
        'message': 'Important message from admin.',
        'timestamp': DateTime.now()
      },
      null,
    ];

    // Remove null notifications
    notifications.removeWhere((notification) => notification == null);

    // Sort notifications by time
    notifications.sort((a, b) => b!['timestamp'].compareTo(a!['timestamp']));

    bool printedTodayHeader =
        false; // Track whether "Today" header has been printed

    return ListView.builder(
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        final notification = notifications[index]!;
        final isToday = _isToday(notification['timestamp']);
        final showHeader = isToday && !printedTodayHeader;

        if (showHeader) {
          printedTodayHeader = true;
        }

        return Column(
          children: [
            if (showHeader) _buildSectionDivider('Today'),
            _buildNotificationItem(notification),
            if (index < notifications.length - 1)
              const Divider(), // Add a divider between notifications
          ],
        );
      },
    );
  }

  bool _isToday(DateTime? timestamp) {
    if (timestamp == null) return false;

    final now = DateTime.now();
    return timestamp.day == now.day &&
        timestamp.month == now.month &&
        timestamp.year == now.year;
  }

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

    // Handle other notification types here

    return ListTile(
      title: Text(notification['type'] ?? ''),
      subtitle: Text(notification['message'] ?? ''),
      onTap: () {
        // Handle notification tap
      },
    );
  }

  Widget _buildFriendRequestItem(Map<String, dynamic> notification) {
    return Column(
      children: [
        ListTile(
          leading: const CircleAvatar(
            backgroundImage: AssetImage('images/test.png'),
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
                      backgroundColor: Colors.green.shade300),
                  child: const Text('Approve'),
                ),
              ),
              const SizedBox(width: 16.0), // Add some spacing between the buttons
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // Handle disapprove button tap
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade300),
                  child: const Text('Disapprove'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
