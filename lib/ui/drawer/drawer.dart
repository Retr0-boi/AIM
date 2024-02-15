import 'package:albertians/ui/drawer/alumni_page.dart';
import 'package:albertians/ui/drawer/event_page.dart';
import 'package:albertians/ui/drawer/job_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:albertians/models/theme_provider.dart';
import 'package:albertians/ui/drawer/settings/settings_page.dart';
import 'package:albertians/models/auth_service.dart';
import 'package:albertians/ui/redirects/registration_page.dart';
import 'package:albertians/models/db_helper.dart';
import 'package:albertians/ui/drawer/profile_page.dart';
import 'package:albertians/services/api_service.dart'; // Import your API service

class MyDrawer extends StatefulWidget implements PreferredSizeWidget {
  const MyDrawer({super.key});

  @override
  _MyDrawerState createState() => _MyDrawerState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _MyDrawerState extends State<MyDrawer> {
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

  Widget _buildRoundedDrawerHeader(
      BuildContext context, Map<String, dynamic>? userData) {
    if (userData == null) {
      return const SizedBox
          .shrink(); // or any other loading indicator or placeholder widget
    }
    return Container(
      height: 80,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(14.0),
          bottomRight: Radius.circular(14.0),
        ),
      ),
      child: DrawerHeader(
        padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.transparent,
              backgroundImage: NetworkImage(
                  'http://192.168.56.1/' + userData['profile_picture']),
            ),
            const SizedBox(width: 8),
            Text(
              userData['name'] ?? 'Default Username',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ChangeNotifierProvider(
        create: (context) => ThemeProvider(),
        child: Builder(
          builder: (context) {
            return Column(
              children: <Widget>[
                FutureBuilder<Map<String, dynamic>>(
                  future: userDataFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return _buildRoundedDrawerHeader(context, snapshot.data);
                    } else {
                      return const SizedBox
                          .shrink(); // or any other loading indicator
                    }
                  },
                ),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: <Widget>[
                      const SizedBox(width: 8),

                      ListTile(
                        leading: const Icon(Icons.account_circle),
                        title: const Text('Profile'),
                        onTap: () {
                          // Handle profile tap
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ProfilePage()),
                          );

                          // Add your navigation logic or any actions you want to perform
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.star),
                        title: const Text('Events'),
                        onTap: () {
                          // Handle placeholder button tap
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const EventPage()),
                          );
                          // Add your navigation logic or any actions you want to perform
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.work_rounded),
                        title: const Text('Jobs'),
                        onTap: () {
                          // Handle placeholder button tap
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const JobPage()),
                          );
                          // Add your navigation logic or any actions you want to perform
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.groups_2),
                        title: const Text('Alumni'),
                        onTap: () {
                          // Handle placeholder button tap
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Alumni()),
                          );
                          // Add your navigation logic or any actions you want to perform
                        },
                      ),
                      // ListTile(
                      //   leading: const Icon(Icons.message_sharp),
                      //   title: const Text('Contact'),
                      //   onTap: () {
                      //     // Handle placeholder button tap
                      //     Navigator.pop(context);
                      //     // Add your navigation logic or any actions you want to perform
                      //   },
                      // ),
                      ListTile(
                        leading: const Icon(Icons.place),
                        title: const Text('Campus Visit'),
                        onTap: () {
                          // Handle placeholder button tap
                          Navigator.pop(context);
                          // Add your navigation logic or any actions you want to perform
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.work),
                        title: const Text('Request Job'),
                        onTap: () {
                          // Handle placeholder button tap
                          Navigator.pop(context);
                          // Add your navigation logic or any actions you want to perform
                        },
                      ),
                    ],
                  ),
                ),
                Divider(
                  color: Theme.of(context).primaryColor,
                ),
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: const Text('Settings'),
                  onTap: () {
                    // Handle settings tap
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SettingsPage()),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('Logout'),
                  onTap: () async {
                    // Handle logout tap
                    Navigator.pop(context);
                    await AuthService.logout();
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const RegistrationPage()),
                      (route) => false,
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
