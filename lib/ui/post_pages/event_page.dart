import 'package:AIM/models/db_helper.dart';
import 'package:AIM/services/api_service.dart';
import 'package:AIM/ui/drawer/event_page.dart';
import 'package:flutter/material.dart';
import 'package:AIM/ui/app_bars/app_bar.dart';
import 'package:AIM/ui/drawer/drawer.dart';
import 'package:AIM/ui/bottom_nav/bottom_navigation_bar.dart';

class EventMenu extends StatefulWidget {
  const EventMenu({super.key});

  @override
  _EventMenuState createState() => _EventMenuState();
}

class _EventMenuState extends State<EventMenu> {
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
      print('Error initializing user data: $e');
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
              'Event details:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: contentController,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: 'Enter the job event...',
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

                Map<String, dynamic> response = await ApiService().postJobs(
                    subject,
                    jobDetails,
                    userData['mongo_id'],
                    'event',
                    registrationLink,
                    'approved');

                if (response['success']) {
                  // Show a success message or perform any actions indicating successful posting
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Job posted successfully!'),
                  ));
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const EventPage()), // Replace JobPage with your actual job page widget
                  );
                } else {
                  // Handle errors, display an error message, or perform appropriate error handling actions
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Failed to post job: ${response['error']}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      backgroundColor: Colors
                          .red, // Customize the background color if needed
                      behavior: SnackBarBehavior
                          .floating, // Choose the SnackBar behavior
                      duration: const Duration(
                          seconds:
                              5), // Set the duration for how long the SnackBar should be visible
                      action: SnackBarAction(
                        label: 'Retry', // You can customize the action label
                        onPressed: () {
                          // Add any action you want to perform when the action button is pressed
                        },
                      ),
                    ),
                  );
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
