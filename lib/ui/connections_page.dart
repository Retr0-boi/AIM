import 'package:flutter/material.dart';
import 'package:AIM/ui/app_bar.dart';
import 'package:AIM/ui/drawer/drawer.dart';
import 'package:AIM/services/api_service.dart';
import 'package:AIM/models/db_helper.dart';
import 'package:AIM/ui/bottom_navigation_bar.dart';
class ConnectionsPage extends StatefulWidget implements PreferredSizeWidget {
  const ConnectionsPage({super.key});

  @override
  _ConnectionsPageState createState() => _ConnectionsPageState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _ConnectionsPageState extends State<ConnectionsPage> {
  late Future<Map<String, dynamic>> userDataFuture;
  late Future<List<Map<String, dynamic>>> matchingUsersFuture;

  @override
  void initState() {
    super.initState();
    // Call the SQLite database helper function to get user data
    userDataFuture = DBHelper.getUserData().then((userData) {
      // Extract mongoId from the user data
      String mongoId = userData['mongo_id'] ?? '';

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
      return ApiService().searchUsers(batchFrom, batchTo, department, program);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(),
      drawer: const MyDrawer(),
      bottomNavigationBar: MyBottomNavigationBar(
        currentIndex: 1,
        onItemTapped: (index) {},
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
              const CircleAvatar(
                backgroundColor: Colors.grey,
                // Replace with user's profile picture
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
                onTap: () {
                  // Handle chat button click for the specific user
                  // You can implement your custom logic here
                  print('Chat button clicked for ${user['_id']}');
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
