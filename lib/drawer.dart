import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme_provider.dart';
import 'ui/settings/settings_page.dart';
import 'backend/auth_service.dart';
import 'ui/registration_page.dart';
import 'package:AIM/backend/db_helper.dart';
import 'package:AIM/ui/drawer/profile_page.dart';

class MyDrawer extends StatelessWidget implements PreferredSizeWidget {
  const MyDrawer({Key? key}) : super(key: key);

  Widget _buildRoundedDrawerHeader(BuildContext context) {
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
              backgroundColor: Colors.white,
              child: Icon(
                Icons.person,
                size: 30,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(width: 8),
            FutureBuilder<Map<String, dynamic>>(
              // Fetch the user data from DBHelper
              future: DBHelper.getUserData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  String username =
                      snapshot.data?['username'] ?? 'Default Username';

                  return Text(
                    username,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  );
                } else {
                  return const CircularProgressIndicator();
                }
              },
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
                _buildRoundedDrawerHeader(context),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: <Widget>[
                      ListTile(
                        leading: const Icon(Icons.account_circle),
                        title: const Text('Profile'),
                        onTap: () {
                          // Handle profile tap
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProfilePage()),
                          );

                          // Add your navigation logic or any actions you want to perform
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.star),
                        title: const Text('Events'),
                        onTap: () {
                          // Handle placeholder button tap
                          Navigator.pop(context);
                          // Add your navigation logic or any actions you want to perform
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.groups_2),
                        title: const Text('Connection'),
                        onTap: () {
                          // Handle placeholder button tap
                          Navigator.pop(context);
                          // Add your navigation logic or any actions you want to perform
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.message_sharp),
                        title: const Text('Contact'),
                        onTap: () {
                          // Handle placeholder button tap
                          Navigator.pop(context);
                          // Add your navigation logic or any actions you want to perform
                        },
                      ),
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
                      MaterialPageRoute(builder: (context) => SettingsPage()),
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
                          builder: (context) => RegistrationPage()),
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

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
