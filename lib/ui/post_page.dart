import 'package:flutter/material.dart';
import 'home_page.dart';

// import '../app_bar.dart';
// import '../drawer.dart';
// import '../bottom_navigation_bar.dart';

class PostMenu extends StatelessWidget implements PreferredSizeWidget {
  const PostMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      backgroundColor: Theme.of(context).primaryColor,
      leading: Builder(
        builder: (BuildContext context) {
          return IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
            onPressed: () {
              // code to go back a page
              _navigateToPage(context, const Home());
            },
          );
        },
      ),
    ),
      
      body: Stack(
        children: [
          // Gallery content view
          Center(
            child: Text(
              'Gallery Content View',
              style: TextStyle(fontSize: 20),
            ),
          ),

          // Preview on top
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AppBar(
              backgroundColor: Colors.transparent,
              leading: Builder(
                builder: (BuildContext context) {
                  return IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      // Navigate back when the back button is pressed
                      Navigator.of(context).pop();
                    },
                  );
                },
              ),
            ),
          ),
          Positioned(
            top: kToolbarHeight,
            left: 0,
            right: 0,
            bottom: 0,
            child: Center(
              child: Text(
                'Preview',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
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