import 'package:AIM/ui/app_bars/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:AIM/models/db_helper.dart';
import 'package:AIM/services/api_service.dart';

import 'package:AIM/ui/drawer/drawer.dart';
import 'package:AIM/ui/bottom_nav/bottom_navigation_bar.dart';
import 'package:AIM/ui/bottom_nav/connections_page.dart';

class Chat extends StatefulWidget implements PreferredSizeWidget {
  const Chat({Key? key});

  @override
  _ChatState createState() => _ChatState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _ChatState extends State<Chat> {
  late Future<Map<String, dynamic>> conversationsFuture;

  @override
  void initState() {
    super.initState();
    conversationsFuture = DBHelper.getUserData().then((userData) {
      String mongoId = userData['mongo_id'] ?? '';
      ApiService apiService = ApiService();
      return apiService.fetchConversation(mongoId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ChatAppBar(),
      drawer: const MyDrawer(),
      bottomNavigationBar: MyBottomNavigationBar(
        currentIndex: 4,
        onItemTapped: (index) {},
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: conversationsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<dynamic> conversations = snapshot.data?['conversations'] ?? [];

            if (conversations.isEmpty) {
              return const Center(child: Text('No chats. Click the button to start a chat.'));
            }

            // Build the UI with the list of conversations
            return ListView.builder(
              itemCount: conversations.length,
              itemBuilder: (context, index) {
                var conversation = conversations[index];
                var latestMessage = conversation['latest_message'] ?? '';
                var latestTimestamp = conversation['latest_timestamp'] ?? '';

                return ListTile(
                  title: Text('User ${index + 1}'),
                  subtitle: Text('Latest Message: $latestMessage\nTimestamp: $latestTimestamp'),
                  onTap: () {
                    // Handle tapping on the conversation
                  },
                );
              },
            );
          }
        },
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
}
