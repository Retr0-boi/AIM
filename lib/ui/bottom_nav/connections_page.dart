// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';
import 'package:albertians/ui/app_bars/app_bar.dart';
import 'package:albertians/ui/drawer/drawer.dart';
import 'package:albertians/services/api_service.dart';
import 'package:albertians/models/db_helper.dart';
import 'package:albertians/ui/bottom_nav/bottom_navigation_bar.dart';
import 'package:albertians/ui/bottom_nav/chat_page/chat_screen.dart'; // Import the ChatScreen

import 'package:albertians/models/userData.dart'; // Import the UserData class

class ConnectionsPage extends StatefulWidget implements PreferredSizeWidget {
  final UserData? userData; // Update the type to UserData

  const ConnectionsPage({super.key,required this.userData});

  @override
  State<ConnectionsPage> createState() => _ConnectionsPageState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _ConnectionsPageState extends State<ConnectionsPage> {
  UserData? userData;
  late Future<Map<String, dynamic>> userDataFuture;
  late Future<List<Map<String, dynamic>>> matchingUsersFuture;
  late String mongoId;

  @override
  void initState() {
    super.initState();
    // print("PRINTING USER DATA");
    // if (widget.userData != null) {
    //   widget.userData!.printUserData();
    // } else {
    //   print("NULL USER DATA");
    // }
    // Call the SQLite database helper function to get user data
    userDataFuture = DBHelper.getUserData().then((userData) {
      // Extract mongoId from the user data
      mongoId = userData['mongo_id'] ?? '';

      // Create an instance of ApiService
      ApiService apiService = ApiService();

      // Call the instance method to fetch user data using the obtained mongoId
      return apiService.fetchUserData(mongoId);
    });

    // Use the result of fetchUserData to get values for searchUsers
    matchingUsersFuture = userDataFuture.then((userData) {
      String batchFrom = userData['batch_from'] ?? '';
      String batchTo = userData['batch_to'] ?? '';
      String department = userData['department'] ?? '';
      String program = userData['program'] ?? '';
      // Call the ApiService method to search for matching users
      return ApiService()
          .searchUsers(batchFrom, batchTo, department, program, mongoId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ConnectionsAppBar(),
      drawer: const MyDrawer(),
      bottomNavigationBar: MyBottomNavigationBar(
        currentIndex: 1,
        onItemTapped: (index) {},
        userData: userData,
      ),
      body: FutureBuilder(
        future: matchingUsersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // If the Future is still running, display a loading indicator
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // If an error occurred, display an error message
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            // If the Future is complete and successful, display the user list
            List<Map<String, dynamic>> matchingUsers = snapshot.data ?? [];
            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: _buildHeading("Classmates"),
                ),
                _buildSection(matchingUsers),
              ],
            );
          }
        },
      ),
    );
  }

  SliverList _buildSection(List<Map<String, dynamic>> userList) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          Map<String, dynamic> user = userList[index];

          return Container(
            margin: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0.0),
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Row(
              children: [
                // Replace CircleAvatar with Image.asset

                ClipOval(
                  child: Image.network(
                    serverUrl + user['profile_picture'],
                    // 'http://192.168.45.72/' + user['profile_picture'],
                    width: 40, // Adjust the width as needed
                    height: 40, // Adjust the height as needed
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    user['name'].toString(),
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        // Adjust the style as needed
                        ),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    // print('Chat button clicked for ${user['_id']} by $mongoId');
                    String recipientId = user['_id']['\$oid'].toString();
                    Map<String, dynamic> initiationResult = await ApiService()
                        .initiateConversation(mongoId, recipientId);

                    if (initiationResult['success'] == true) {
                      // Access the conversationId from the response map
                      String conversationId =
                          initiationResult['conversationId']['\$oid'];
                      _navigateToChatScreen(mongoId, recipientId, user['name'],
                          user['profile_picture'], conversationId);
                    } else {
                      // print('Error initiating conversation: ${initiationResult['error']}');
                      // Handle error
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Colors.blue, // Customize button color
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.chat, // Use the chat icon
                      color: Colors.white, // Customize icon color
                    ),
                  ),
                ),
              ],
            ),
          );
        },
        childCount: userList.length,
      ),
    );
  }

  void _navigateToChatScreen(String mongoId, String recipientId, String name,
      String profilePicture, String conversationId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatScreen(
          mongoId: mongoId,
          receiverMongoId: recipientId,
          name: name,
          profilePicture: profilePicture,
          conversationId: conversationId,
        ),
      ),
    );
  }

  Widget _buildHeading(String heading) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      child: Text(
        heading,
        style: const TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }
}
