import 'package:flutter/material.dart';
import 'package:AIM/ui/app_bar.dart';
import 'package:AIM/ui/drawer/drawer.dart';
import 'package:AIM/services/api_service.dart'; // Import your API service
import 'package:AIM/models/db_helper.dart'; // Import your SQLite database helper

class ProfilePage extends StatefulWidget implements PreferredSizeWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<Map<String, dynamic>> userDataFuture;

  @override
  void initState() {
    super.initState();
    // Call the SQLite database helper function to get user data
    userDataFuture = DBHelper.getUserData().then((userData) {
      // Extract mongoId from the user data
      String mongoId =
          userData['mongo_id'] ?? ''; // Replace 'mongoId' with the actual key

      // Create an instance of ApiService
      ApiService apiService = ApiService();

      // Call the instance method to fetch user data using the obtained mongoId
      return apiService.fetchUserData(mongoId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(),
      drawer: const MyDrawer(),
      body: FutureBuilder(
        future: userDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator(); // Show a loading indicator while data is being fetched
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            // Data has been successfully fetched
            Map<String, dynamic> userData =
                snapshot.data as Map<String, dynamic>;

            // Print the raw data
            print(userData);

            // Extract additional information based on current status
            String currentStatus = userData['current_status'];
            Widget additionalInfoWidget =
                _buildAdditionalInfo(currentStatus, userData);

            // Now you can display the data in the specified format
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 24),
                  // Profile Picture (Replace with your actual image path or URL)
                  CircleAvatar(
                    radius: 90,
                    backgroundImage: AssetImage('images/'+userData['profile_picture']),
                  ),

                  const SizedBox(height: 24),
                  // User Information Card
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildUserInfo('Name:', userData['name']),
                          _buildUserInfo('Department:', userData['department']),
                          _buildUserInfo('Program:', userData['program']),
                          _buildUserInfo('Batch:', userData['batch_from'] +" - " + userData['batch_to']),
                          _buildUserInfo('Email:', userData['email']),
                          _buildUserInfo('Date of Birth:', userData['DOB']),
                          // Add other information as needed
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Additional Information based on current status
                  additionalInfoWidget,
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildUserInfo(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(fontSize: 18),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildAdditionalInfo(
      String currentStatus, Map<String, dynamic> userData) {
    switch (currentStatus) {
      case 'Working (Govt)':
      case 'Working (Non Govt)':
      case 'Entrepreneur':
        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Current Status:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  currentStatus,
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 16),
                _buildUserInfo(
                    'Current Organization:', userData['current_org']),
                _buildUserInfo('Designation:', userData['current_designation']),
              ],
            ),
          ),
        );
      case 'Student':
        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Current Status:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  currentStatus,
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 16),
                _buildUserInfo('Current Program:', userData['current_program']),
                _buildUserInfo(
                    'Current Institution:', userData['current_institution']),
                _buildUserInfo('Expected Year of Passing:',
                    userData['exp_year_of_passing']),
              ],
            ),
          ),
        );
      // Add more cases as needed
      default:
        return const SizedBox.shrink(); // Return an empty widget for other cases or 'Not Working'
    }
  }
}
