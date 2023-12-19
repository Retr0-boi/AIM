import 'package:flutter/material.dart';
import '../app_bar.dart';
import '../drawer.dart';
import '../bottom_navigation_bar.dart';

class Chat extends StatelessWidget implements PreferredSizeWidget {
  const Chat({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(),
      drawer: const MyDrawer(),
      bottomNavigationBar: MyBottomNavigationBar(
        currentIndex: 4,
        onItemTapped: (index) {},
      ),
      body: const Center(
        child: Text(
          'This is the Chat Page WITH INDEX 4',
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}