import 'dart:io';
import 'package:flutter/material.dart';
import 'package:AIM/app_bar.dart';
import 'package:AIM/drawer.dart';
import 'package:AIM/bottom_navigation_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class EventMenu extends StatefulWidget {
  const EventMenu({super.key});

  @override
  _EventMenuState createState() => _EventMenuState();
}

class _EventMenuState extends State<EventMenu> {
  TextEditingController subjectController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  File? selectedImage;
  
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
      appBar: const MyAppBar(),
      drawer: const MyDrawer(),
      bottomNavigationBar: MyBottomNavigationBar(
        currentIndex: 2,
        onItemTapped: (index) {},
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
              onPressed: () {
                // Add logic to handle posting (e.g., sending data to MongoDB)
                // Access the entered data using subjectController.text, contentController.text, and selectedImage
              },
              child: const Text('Post'),
            ),
          ],
        ),
      ),
    );
  }
}
