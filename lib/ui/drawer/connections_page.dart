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
          SliverToBoxAdapter(
            child: _buildHeading("Classmates"),
          ),
          _buildSection(_classmatesList()),
          SliverToBoxAdapter(
            child: _buildHeading("Friends"),
          ),
          _buildSection(_friendsList()),
        ],
      ),
    );
  }

  SliverList _buildSection(List<String> userList) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return Container(
            margin: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0.0),
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.grey,
                  // Replace with user's profile picture
                ),
                SizedBox(width: 16),
                Text(userList[index]), // Replace with user's name
              ],
            ),
          );
        },
        childCount: userList.length,
      ),
    );
  }

  Widget _buildHeading(String heading) {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Text(
        heading,
        style: TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
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
