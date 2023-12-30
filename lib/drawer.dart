import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme_provider.dart';
import 'ui/settings/settings_page.dart';

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
            const Text(
              'YOUR NAME',
              style: TextStyle(
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
            var themeProvider = Provider.of<ThemeProvider>(context);

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
                          Navigator.pop(context);
                          // Add your navigation logic or any actions you want to perform
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.star),
                        title: const Text('Placeholder Button'),
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
                  leading: Icon(
                    themeProvider.currentTheme == ThemeData.light()
                        ? Icons.light_mode_outlined
                        : Icons.dark_mode_outlined,
                  ),
                  onTap: () {
                    themeProvider.toggleTheme();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: const Text('Settings'),
                  onTap: () {
                    // Handle settings tap
                    Navigator.pop(context);
                    _navigateToPage(context, SettingsPage());
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _navigateToPage(BuildContext context, Widget page) {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => page,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
