import 'package:flutter/material.dart';
import 'package:AIM/ui/app_bars/app_bar.dart';
import 'package:AIM/ui/drawer/drawer.dart';
import 'package:AIM/ui/bottom_nav/bottom_navigation_bar.dart';
import 'package:AIM/ui/bottom_nav/connections_page.dart';
import 'package:AIM/services/api_service.dart';
import 'package:AIM/models/db_helper.dart';

class Chat extends StatefulWidget implements PreferredSizeWidget {
  const Chat({super.key});

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
    conversationsFuture = _fetchConversations();
  }

  Future<Map<String, dynamic>> _fetchConversations() async {
    final userData = await DBHelper.getUserData();
    final mongoId = userData['mongo_id'] ?? '';
    final apiService = ApiService();
    return apiService.fetchConversation(mongoId);
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
      body: _buildConversationList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToConnectionsPage(context),
        tooltip: 'Start a new chat',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildConversationList() {
    return FutureBuilder<Map<String, dynamic>>(
      future: conversationsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          final conversations = snapshot.data?['conversations'] ?? [];

          if (conversations.isEmpty) {
            return const Center(
                child: Text('No chats. Click the button to start a chat.'));
          }

          // Build the UI with the list of conversations
          return ListView.builder(
            itemCount: conversations.length,
            itemBuilder: (context, index) {
              final conversation = conversations[index];
              final latestMessage = conversation['latest_message'] ?? '';
              final latestTimestamp = conversation['latest_timestamp'] ?? '';

              // Check if 'user_details' is not empty and contains non-null values
              final userDetailList = conversation['user_details'] ?? [];

              if (userDetailList.isNotEmpty && userDetailList.any((user) => user != null)) {
                final user = userDetailList.firstWhere((user) => user != null);
                final userName = user['name'] ?? '';
                final profilePicUrl = user['profile_picture'] ?? '';

                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Image.asset(
                    'images/' + profilePicUrl,
                    width: 40, // Adjust the width as needed
                    height: 40, // Adjust the height as needed
                    fit: BoxFit.cover,
                  ),
                    ),
                    title: Text(userName),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Latest Message: $latestMessage'),
                        Text('Timestamp: $latestTimestamp'),
                      ],
                    ),
                    onTap: () {
                      // Handle tapping on the conversation
                    },
                  ),
                );
              } else {
                // Handle the case when 'user_details' is empty or contains only null values
                // Add debug print to see why user_details is empty
                print('User details are empty or contain only null values');
                return const Card(
                  child: ListTile(
                    title: Text('User details not available'),
                  ),
                );
              }
            },
          );
        }
      },
    );
  }

  void _navigateToConnectionsPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ConnectionsPage()),
    );
  }
}