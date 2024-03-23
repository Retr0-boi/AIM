import 'dart:io';
import 'package:albertians/ui/bottom_nav/home_page.dart';
import 'package:flutter/material.dart';
import 'package:albertians/ui/app_bars/app_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:albertians/ui/drawer/drawer.dart';
import 'package:albertians/services/api_service.dart'; // Import your API service
import 'package:albertians/models/db_helper.dart'; // Import your SQLite database helper

class ProfilePage extends StatefulWidget implements PreferredSizeWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<Map<String, dynamic>> userDataFuture;
  late File? selectedImage;
  late String mongoId;
  late String email;
  late String password;

  @override
  void initState() {
    super.initState();
    // Call the SQLite database helper function to get user data
    userDataFuture = DBHelper.getUserData().then((userData) {
      mongoId = userData['mongo_id'] ?? ''; 
      email = userData['email'] ?? '';
      password = userData['password'] ?? '';

      ApiService apiService = ApiService();

      return apiService.fetchUserData(mongoId);
    });
  }

  Future<void> _requestPermissions() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
  }

  Future<void> _pickImage() async {
    await _requestPermissions(); // Add this line
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        selectedImage = File(pickedFile.path);
      });
      _showConfirmationDialog();
    }
  }

  Future<void> _showConfirmationDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Update Profile Picture'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Do you want to update your profile picture?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () {
                // Call API service to update profile picture
                _updateProfilePicture(selectedImage!, mongoId,email,password);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _updateProfilePicture(File imageFile, String mongoId,String email,String password) async {
    if (mongoId.isNotEmpty) {
      // Call your API service method here
      ApiService apiService = ApiService();
      // Replace 'userId' with the actual user ID
      Map<String, dynamic> response =
          await apiService.updateProfileImage(mongoId, imageFile,email,password);
      if (response['success']) {
        // Handle success
        print('Profile picture updated successfully');
        // Navigator.of(context).pop();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const Home(),
          ),
        );
      } else {
        // Handle failure
        print('Failed to update profile picture');
      }
    } else {
      print('Error: mongoId is empty or not initialized');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ProfileAppBar(),
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
                  GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 90,
                      backgroundImage: NetworkImage(
                          // 'http://192.168.56.1/' + userData['profile_picture']),
                          'http://192.168.45.72/' +
                              userData['profile_picture']),
                    ),
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
                          _buildUserInfo(
                              'Batch:',
                              userData['batch_from'] +
                                  " - " +
                                  userData['batch_to']),
                          _buildUserInfo('Email:', userData['email']),
                          _buildUserInfo('Date of Birth:', userData['DOB']),
                          _buildUserInfo('Phone:', userData['phone']),
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
        return const SizedBox
            .shrink(); // Return an empty widget for other cases or 'Not Working'
    }
  }
}
