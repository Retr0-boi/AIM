// ignore_for_file: use_build_context_synchronously

import 'package:albertians/models/db_helper.dart';
import 'package:albertians/models/userData.dart';
import 'package:albertians/services/api_service.dart';
import 'package:albertians/ui/drawer/job_page.dart';
import 'package:flutter/material.dart';
import 'package:albertians/ui/app_bars/app_bar.dart';
import 'package:albertians/ui/drawer/drawer.dart';
import 'package:albertians/ui/bottom_nav/bottom_navigation_bar.dart';

// class JobMenu extends StatefulWidget {
//   const JobMenu({super.key});

//   @override
// }

class JobMenu extends StatefulWidget {
  final UserData? userData;

  const JobMenu({super.key, this.userData});

    @override
  State<JobMenu> createState() => _JobMenuState();

}




class _JobMenuState extends State<JobMenu> {
  UserData? userData;
  TextEditingController jobSubjectController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  TextEditingController registrationLinkController = TextEditingController();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const JobAppBar(),
      drawer: const MyDrawer(),
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
              controller: jobSubjectController,
              decoration: const InputDecoration(
                hintText: 'Enter the subject...',
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Job details:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: contentController,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: 'Enter the job details...',
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Registration Link:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: registrationLinkController,
              decoration: const InputDecoration(
                hintText: 'Enter the registration link...',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                String subject = jobSubjectController.text;
                String jobDetails = contentController.text;
                String registrationLink = registrationLinkController.text;
                Map<String, dynamic> userData = await userDataFuture;
                  String dept = userData['department'];
                Map<String, dynamic> response = await ApiService().postJobs(
                    subject,
                    jobDetails,
                    userData['mongo_id'],
                    userData['email'],
                    userData['password'],
                    'job',
                    dept,
                    registrationLink,
                    'waiting');

                if (response['success']) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Job posted successfully!'),
                  ));
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const JobPage(),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Failed to post job: ${response['error']}'),
                  ));
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
