import 'package:flutter/material.dart';
import '../app_bar.dart';
import '../drawer.dart';
import '../bottom_navigation_bar.dart';

class Alumni extends StatelessWidget implements PreferredSizeWidget {
  const Alumni({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(),
      drawer: const MyDrawer(),
      bottomNavigationBar: MyBottomNavigationBar(
        currentIndex: 1,
        onItemTapped: (index) {},
      ),
      body: const Center(
        child: Text(
          'This is the ALUMNI Page WITH INDEX 1',
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}