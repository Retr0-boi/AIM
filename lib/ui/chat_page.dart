import 'package:flutter/material.dart';
import 'package:AIM/ui/app_bar.dart';
import 'package:AIM/ui/drawer/drawer.dart';
import 'package:AIM/bottom_navigation_bar.dart';
import 'package:AIM/ui/connections_page.dart';

class Chat extends StatelessWidget implements PreferredSizeWidget {
  Chat({super.key});

  // Remove 'const' since the list contains dynamic values
  final List<String> users = ['User 1', 'User 2', 'User 3'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(),
      drawer: const MyDrawer(),
      bottomNavigationBar: MyBottomNavigationBar(
        currentIndex: 4,
        onItemTapped: (index) {},
      ),
      body: const Center(
        child: Text(
          'This is the Chat Page WITH INDEX 4',
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ConnectionsPage()),
          );
        },
        tooltip: 'Start a new chat',
        child: const Icon(Icons.chat),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
