import 'package:flutter/material.dart';
import '../app_bar.dart';
import '../drawer.dart';
import '../bottom_navigation_bar.dart';

class PostMenu extends StatelessWidget implements PreferredSizeWidget {
  const PostMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(),
      drawer: const MyDrawer(),
      bottomNavigationBar: MyBottomNavigationBar(
        currentIndex: 2,
        onItemTapped: (index) {},
      ),
      body: const Center(
        child: Text(
          'This is the POST Page WITH INDEX 2',
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}