// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:albertians/models/db_helper.dart';
import 'package:albertians/models/userData.dart';
import 'package:albertians/services/api_service.dart';
import 'package:albertians/ui/bottom_nav/bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:albertians/ui/app_bars/app_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:albertians/ui/bottom_nav/home_page.dart';

class PostMenu extends StatefulWidget {
  final UserData? userData;
  const PostMenu({super.key, this.userData});
  @override
  State<PostMenu> createState() => _PostMenuState();
}

class _PostMenuState extends State<PostMenu> {
  UserData? userData;

  TextEditingController subjectController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  File? selectedImage;
  late Future<Map<String, dynamic>> userDataFuture;

  @override
  void initState() {
    super.initState();
    _initializeUserData();
  }

  Future<void> _initializeUserData() async {
    try {
      final userData = await DBHelper.getUserData();
      setState(() {
        userDataFuture = Future.value(userData);
      });
    } catch (e) {
      // print('Error initializing user data: $e');
      setState(() {
        userDataFuture = Future.error(e);
      });
    }
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PostAppBar(),
      bottomNavigationBar: MyBottomNavigationBar(
        currentIndex: 2,
        onItemTapped: (index) {},
        userData: userData,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Subject:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: subjectController,
              decoration: const InputDecoration(
                hintText: 'Enter the subject...',
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Content:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: contentController,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: 'Enter the content...',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text('Select Image'),
            ),
            const SizedBox(height: 20),
            selectedImage != null
                ? Image.file(
                    selectedImage!,
                    height: 100,
                  )
                : Container(),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // Check if subject and content are not empty
                if (subjectController.text.isEmpty ||
                    contentController.text.isEmpty) {
                  // Show a snackbar or dialog indicating that subject and content are required
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Subject and content are required.'),
                    ),
                  );
                  return;
                }

                try {
                  // Wait for userDataFuture to complete and get the user data
                  Map<String, dynamic> userData = await userDataFuture;

                  // Print the data before sending it
                  // print('Sending post content with the following data:');
                  // print('Subject: ${subjectController.text}');
                  // print('Content: ${contentController.text}');
                  // print('User ID: ${userData['mongo_id']}');
                  // print('User EMAIL: ${userData['email']}');
                  // print('User PASS: ${userData['password']}');
                  // print('Image: $selectedImage');
                  String dept = userData['department'];
                  // Call the postContent method from an instance of ApiService
                  ApiService apiService = ApiService();
                  Map<String, dynamic> result = await apiService.postContent(
                    subjectController.text,
                    contentController.text,
                    userData['mongo_id'],
                    'post',
                    dept,
                    userData['email'],
                    userData['password'],
                    image: selectedImage,
                  );

                  // Check if the post was successful
                  if (result['success']) {
                    // Show a snackbar or dialog indicating success
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Content posted successfully.'),
                      ),
                    );
                    // Clear text fields and selected image
                    subjectController.clear();
                    contentController.clear();
                    setState(() {
                      selectedImage = null;
                    });

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Home(),
                      ),
                    );
                  } else {
                    // Show a snackbar or dialog indicating failure
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content:
                            Text('Failed to post content. Please try again.'),
                      ),
                    );
                  }
                } catch (e) {
                  // print('Error fetching user data: $e');
                  // Handle error fetching user data, such as showing a snackbar or dialog
                }
              },
              child: const Text('Post'),
            ),
          ],
        ),
      ),
    );
  }
}
