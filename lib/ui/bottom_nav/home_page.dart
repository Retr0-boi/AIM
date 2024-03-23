// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:albertians/models/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:albertians/ui/bottom_nav/bottom_navigation_bar.dart';
import 'package:albertians/ui/drawer/drawer.dart';
import 'package:albertians/services/api_service.dart';
import 'package:photo_view/photo_view.dart';
import 'package:albertians/models/userData.dart';
// import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  final UserData? userData;

  const Home({super.key, this.userData});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late String department; 
  final ApiService _apiService = ApiService();
  List<Map<String, dynamic>> _posts = [];

  @override
  void initState() {
    super.initState();
    _fetchDepartment();
  }

  Future<void> _fetchDepartment() async {
    final userData = await DBHelper.getUserData();
    setState(() {
      department = userData['department'] ?? '';
      // print("department is $department");
    });
    _fetchPosts(department);
  }

  Future<void> _fetchPosts(String department) async {
    try {
      // print("department is $department");
      List<Map<String, dynamic>> posts = await _apiService.getPosts(department);
      setState(() {
        _posts = posts;
      });
    } catch (e) {
      // print('Error fetching posts: $e');
      // Handle error here
    }
  }

  @override
  Widget build(BuildContext context) {
    final userData = widget.userData;
    // print("CHECKING IF THIS WORKS $userData");
    // userData?.printUserData();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Home",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(
                Icons.menu,
                color: Colors.white,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      drawer: const MyDrawer(),
      bottomNavigationBar: MyBottomNavigationBar(
        currentIndex: 0,
        onItemTapped: (index) {},
        userData: userData,
      ),
      body: CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                if (index == 0) {
                  // Suggestions Box
                  return Container();
                } else {
                  final postIndex = index - 1;
                  final post = _posts[postIndex];
                  final user = post['user'];
                  return Container(
                    margin: const EdgeInsets.all(8),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: 50,
                              height: 50,
                              child: CircleAvatar(
                                radius: 90,
                                backgroundImage: NetworkImage(
                                  // 'http://192.168.56.1/' +
                                  'http://192.168.45.72/' +
                                      (user['profile_picture'] ?? ''),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user['name'] ?? '',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  user['department'] +
                                          " " +
                                          user['batch_from'] +
                                          ' - ' +
                                          user['batch_to'] ??
                                      '',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Text(
                          post['subject'] ?? '',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 8),
                        if (post.containsKey('image'))
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => FullScreenImage(
                                  imageUrl:
                                      // 'http://192.168.56.1/' + post['image'],
                                      'http://192.168.45.72/' + post['image'],
                                ),
                              ));
                            },
                            child: Center(
                              child: Image.network(
                                // 'http://192.168.56.1/' + post['image'],
                                'http://192.168.45.72/' + post['image'],
                              ),
                            ),
                          ),
                        const SizedBox(height: 8),
                        Text(
                          post['content'] ?? '',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  );
                }
              },
              childCount: _posts.length + 1,
            ),
          ),
        ],
      ),
    );
  }
}

class FullScreenImage extends StatelessWidget {
  final String imageUrl;

  const FullScreenImage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: PhotoView(
          imageProvider: NetworkImage(imageUrl),
          minScale: PhotoViewComputedScale.contained * 0.8,
          maxScale: PhotoViewComputedScale.covered * 2,
          initialScale: PhotoViewComputedScale.contained,
        ),
      ),
    );
  }
}
