import 'package:flutter/material.dart';
import 'package:albertians/models/userData.dart';
import 'package:albertians/ui/bottom_nav/connections_page.dart';
import 'package:albertians/ui/bottom_nav/home_page.dart';
import 'package:albertians/ui/post_pages/post_page.dart';
import 'package:albertians/ui/bottom_nav/notifications_page.dart';
import 'package:albertians/ui/bottom_nav/chat_page/chat_page.dart';
import 'package:albertians/ui/post_pages/event_page.dart';
import 'package:albertians/ui/post_pages/job_page.dart';

class MyBottomNavigationBar extends StatefulWidget {
  final int currentIndex;
  final ValueChanged<int> onItemTapped;
  final UserData? userData; // Add userData parameter

  const MyBottomNavigationBar({
    required this.currentIndex,
    required this.onItemTapped,
    required this.userData, // Make it nullable
    super.key,
  });

  @override
  State<MyBottomNavigationBar> createState() => _MyBottomNavigationBarState();
}

class _MyBottomNavigationBarState extends State<MyBottomNavigationBar> {
  late UserData? userData; // Define userData here

  @override
  void initState() {
    super.initState();
    userData = widget.userData; // Assign the value from the widget to userData
          }

  @override
  Widget build(BuildContext context) {
    // print('userData in nav bar: $userData');
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.group),
          label: 'Connections',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add_box_rounded),
          label: 'Post',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications),
          label: 'Notifications',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.chat_rounded),
          label: 'Chat',
        ),
      ],
      currentIndex: widget.currentIndex,
      onTap: (index) => _onItemTapped(context, index),
      selectedItemColor: Theme.of(context).focusColor,
      unselectedItemColor: Theme.of(context).unselectedWidgetColor,
      type: BottomNavigationBarType.fixed,
    );
  }

  void _onItemTapped(BuildContext context, int index) {
    if (widget.currentIndex != index) {
      if (index == 2) { // Check if the "Post" button is tapped
        // Show a dialog to choose between job, events, or regular posts
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Select post type"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // Close the dialog
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => JobMenu(userData: userData)), // Pass userData here
                      );
                    },
                    child: const Text("Job"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // Close the dialog
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => EventMenu(userData: userData)), // Pass userData here
                      );
                    },
                    child: const Text("Event"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // Close the dialog
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PostMenu(userData: userData)), // Pass userData here
                      );
                    },
                    child: const Text("Post"),
                  ),
                ],
              ),
            );
          },
        );
      } else {
        // Handle other bottom navigation items
        widget.onItemTapped(index);
        switch (index) {
          case 0:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Home(userData: userData)), // Pass userData here
            );
            break;
          case 1:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => ConnectionsPage(userData: userData)), // Pass userData here
            );
            break;
          case 3:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Notifications(userData: userData)), // Pass userData here
            );
            break;
          case 4:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Chat(userData: userData)), // Pass userData here
            );
            break;
        }
      }
    }
  }
}