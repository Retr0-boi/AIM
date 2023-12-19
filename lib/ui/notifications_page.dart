import 'package:flutter/material.dart';
import '../app_bar.dart';
import '../drawer.dart';
import '../bottom_navigation_bar.dart';

class Notifications extends StatelessWidget implements PreferredSizeWidget {
  const Notifications({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(),
      drawer: const MyDrawer(),
      bottomNavigationBar: MyBottomNavigationBar(
        currentIndex: 3,
        onItemTapped: (index) {},
      ),
      body: const Center(
        child: Text(
          'This is the NOTIFICATIONS Page WITH INDEX 3',
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}