import 'package:albertians/ui/bottom_nav/chat_page/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:albertians/ui/app_bars/app_bar.dart';
import 'package:albertians/ui/drawer/drawer.dart';
import 'package:albertians/ui/bottom_nav/bottom_navigation_bar.dart';
import 'package:albertians/ui/bottom_nav/connections_page.dart';
import 'package:albertians/services/api_service.dart';
import 'package:albertians/models/db_helper.dart';

class Chat extends StatefulWidget implements PreferredSizeWidget {
  const Chat({super.key});

  @override
  _ChatState createState() => _ChatState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _ChatState extends State<Chat> {
  late Future<Map<String, dynamic>> conversationsFuture;
  late String mongoId;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
    conversationsFuture = _fetchConversations();
  }

  Future<void> _fetchUserData() async {
    final userData = await DBHelper.getUserData();
    mongoId = userData['mongo_id'] ?? '';
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

          // Extract user data from the snapshot
          // final userData = snapshot.data?['userData'];

          // Build the UI with the list of conversations
          return ListView.builder(
            itemCount: conversations.length,
            itemBuilder: (context, index) {
              final conversation = conversations[index];
              final latestMessage = conversation['latest_message'] ?? '';
              final userDetailList = conversation['user_details'] ?? [];

              if (userDetailList.isNotEmpty &&
                  userDetailList.any((user) => user != null)) {
                final user = userDetailList.firstWhere((user) => user != null);
                final userName = user['name'] ?? '';
                final profilePicUrl = user['profile_picture'] ?? '';

                return Card(
                  child: ListTile(
                    leading: CircleAvatar(

                      child: Image.network(
                        'http://192.168.56.1/' + profilePicUrl,
                        width: 40,
                        height: 40,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text('$userName'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Latest Message: $latestMessage'),
                      ],
                    ),
                    // onTap: () {
                    //   // Handle tapping on the conversation
                    //   print(
                    //       'Chat button clicked for ${user['_id']} with conversation id${conversation['_id']}');
                    //   String recipientId = user['_id']['\$oid'].toString();
                    //   Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //       builder: (context) => ChatScreen(
                    //           mongoId: mongoId, // Pass the MongoID of the user
                    //           receiverMongoId:
                    //               recipientId, // Pass the MongoID of the receiver
                    //           name: user['name'], // Pass the name
                    //           profilePicture: user[
                    //               'profile_picture'], // Pass the profile picture URL
                    //           conversationId: conversation['_id']),
                    //     ),
                    //   );
                    // },
                    onTap: () {
                      // Handle tapping on the conversation
                      print(
                          'Chat button clicked for ${user['_id']} with conversation id ${conversation['_id']}');
                      String recipientId = user['_id']['\$oid']
                          .toString(); // Access ObjectId correctly
                      String conversationId = conversation['_id']['\$oid']
                          .toString(); // Access ObjectId correctly
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatScreen(
                            mongoId: mongoId, // Pass the MongoID of the user
                            receiverMongoId:
                                recipientId, // Pass the MongoID of the receiver
                            name: user['name'], // Pass the name
                            profilePicture: user[
                                'profile_picture'], // Pass the profile picture URL
                            conversationId:
                                conversationId, // Pass the conversation ID
                          ),
                        ),
                      );
                    },
                  ),
                );
              } else {
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
