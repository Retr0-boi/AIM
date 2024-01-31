import 'package:flutter/material.dart';
import 'package:AIM/app_bar.dart';
import 'package:AIM/drawer.dart';
import 'package:AIM/bottom_navigation_bar.dart';
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
          _showUserSelectionDialog(context);
        },
        tooltip: 'Start a new chat',
        child: const Icon(Icons.chat),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  void _showUserSelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Choose a user to chat with'),
          content: Column(
            children: [
              // Replace this with a ListView.builder to display your users
              for (String user in users)
                ListTile(
                  title: Text(user),
                  onTap: () {
                    Navigator.of(dialogContext).pop();
                    _startChatWithUser(context, user);
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  void _startChatWithUser(BuildContext context, String selectedUser) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Starting a chat with $selectedUser'),
      ),
    );
  }
}