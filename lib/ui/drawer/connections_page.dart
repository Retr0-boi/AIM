import 'package:flutter/material.dart';
import 'package:AIM/app_bar.dart';
import 'package:AIM/drawer.dart';

class ConnectionsPage extends StatelessWidget implements PreferredSizeWidget {
  const ConnectionsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(),
      drawer: const MyDrawer(),
      body: CustomScrollView(
        slivers: [
          _buildSection("Classmates", _classmatesList()),
          _buildSection("Friends", _friendsList()),
        ],
      ),
    );
  }

  SliverList _buildSection(String title, List<String> userList) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return ListTile(
            title: Text(userList[index]),
            // Add more ListTile customization or onTap logic as needed
          );
        },
        childCount: userList.length,
      ),
    );
  }

  List<String> _classmatesList() {
    // Replace with logic to fetch and return a list of classmates
    return ['Classmate 1', 'Classmate 2', 'Classmate 3'];
  }

  List<String> _friendsList() {
    // Replace with logic to fetch and return a list of friends
    return ['Friend 1', 'Friend 2', 'Friend 3'];
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
