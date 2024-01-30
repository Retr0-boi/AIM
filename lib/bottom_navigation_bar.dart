import 'package:flutter/material.dart';
import 'ui/alumni_page.dart';
import 'ui/home_page.dart';
import 'ui/post_page.dart';
import 'ui/notifications_page.dart';
import 'ui/chat_page.dart';

class MyBottomNavigationBar extends StatefulWidget {
  final int currentIndex;
  final ValueChanged<int> onItemTapped;

  const MyBottomNavigationBar({
    required this.currentIndex,
    required this.onItemTapped,
    Key? key,
  }) : super(key: key);

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

      switch (index) {
        case 0:
          _navigateWithoutAnimation(context, const Home());
          break;
        case 1: 
          _navigateWithoutAnimation(context, const Alumni());
          break;
        case 2:
          _navigateWithoutAnimation(context, const PostMenu());
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

  void _navigateWithoutAnimation(BuildContext context, Widget page) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        
      ),
    );
  }
  
}