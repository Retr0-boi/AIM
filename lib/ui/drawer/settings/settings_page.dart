import 'package:flutter/material.dart';
import '../../home_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context); // Use pop to go back
              _navigateToPage(context, const Home());
              },
            );
          },
        ),
        title: const Text('Settings', style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // _buildSettingsOption(context, 'Account', AccountSettingsPage()),
            _buildSettingsOption(context, 'Security', const SecuritySettingsPage()),
            _buildSettingsOption(context, 'Notifications', const NotificationsSettingsPage()),
            _buildSettingsOption(context, 'Data Privacy', const DataPrivacySettingsPage()),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsOption(BuildContext context, String title, Widget page) {
    return ListTile(
      title: Text(title),
      onTap: () {
        _navigateToPage(context, page);
      },
    );
  }

  void _navigateToPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }
}

class AccountSettingsPage extends StatelessWidget {
  const AccountSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Settings'),
      ),
      body: const Center(
        child: Text('Account Settings Page'),
      ),
    );
  }
}

class SecuritySettingsPage extends StatelessWidget {
  const SecuritySettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Security Settings'),
      ),
      body: const Center(
        child: Text('Security Settings Page'),
      ),
    );
  }
}

class NotificationsSettingsPage extends StatelessWidget {
  const NotificationsSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications Settings'),
      ),
      body: const Center(
        child: Text('Notifications Settings Page'),
      ),
    );
  }
}

class DataPrivacySettingsPage extends StatelessWidget {
  const DataPrivacySettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Privacy Settings'),
      ),
      body: const Center(
        child: Text('Data Privacy Settings Page'),
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
}
