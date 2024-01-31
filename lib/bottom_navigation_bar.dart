import 'package:flutter/material.dart';
import 'ui/alumni_page.dart';
import 'ui/home_page.dart';
import 'ui/post_pages/post_page.dart';
import 'ui/notifications_page.dart';
import 'ui/chat_page.dart';
import 'package:AIM/ui/post_pages/event_page.dart';
import 'package:AIM/ui/post_pages/job_page.dart';

class MyBottomNavigationBar extends StatefulWidget {
  final int currentIndex;
  final ValueChanged<int> onItemTapped;

  const MyBottomNavigationBar({
    required this.currentIndex,
    required this.onItemTapped,
    super.key,
  });

  @override
  createState() => _MyBottomNavigationBarState();
}

class _MyBottomNavigationBarState extends State<MyBottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.group),
          label: 'Alumni',
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
      widget.onItemTapped(index);

      if (index == 2) {
        // Show a dialog to choose between "Jobs," "Events," or "Post"
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("What would you like to post"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const JobMenu()),
                      );
                    },
                    child: Text("Jobs"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const EventMenu()),
                      );
                    },
                    child: Text("Events"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const PostMenu()),
                      );
                    },
                    child: Text("Post"),
                  ),
                ],
              ),
            );
          },
        );
      } else {
        // Navigate to the selected page
        switch (index) {
          case 0:
            _navigateWithoutAnimation(context, const Home());
            break;
          case 1:
            _navigateWithoutAnimation(context, const Alumni());
            break;
          case 3:
            _navigateWithoutAnimation(context, const Notifications());
            break;
          case 4:
            _navigateWithoutAnimation(context, Chat());
            break;
        }
      }
    }
  }

  void _navigateWithoutAnimation(BuildContext context, Widget page) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => page,
      ),
    );
  }
}
