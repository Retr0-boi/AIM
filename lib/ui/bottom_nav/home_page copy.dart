import 'package:flutter/material.dart';
import 'package:AIM/ui/bottom_nav/bottom_navigation_bar.dart';
import 'package:AIM/ui/drawer/drawer.dart';
import 'package:AIM/services/api_service.dart';
import 'package:photo_view/photo_view.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final ApiService _apiService = ApiService();
  List<Map<String, dynamic>> _posts = [];

  @override
  void initState() {
    super.initState();
    _fetchPosts();
  }

  Future<void> _fetchPosts() async {
    try {
      List<Map<String, dynamic>> posts = await _apiService.getPosts();
      setState(() {
        _posts = posts;
      });
    } catch (e) {
      print('Error fetching posts: $e');
      // Handle error here
    }
  }

  @override
  Widget build(BuildContext context) {
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
      drawer: const MyDrawer(), // Set to null to remove the drawer
      bottomNavigationBar: MyBottomNavigationBar(
        currentIndex: 0,
        onItemTapped: (index) {},
      ),
      body: Builder(
        builder: (context) {
          return CustomScrollView(
            slivers: [
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    // User Posts Box
                    if (index == 0) {
                      // Suggestions Box
                      return Container(
                          // Build the suggestions box
                          // You can customize this part as needed
                          );
                    } else {
                      // User Post
                      final postIndex = index - 1; // Adjust index for posts
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
                                Container(
                                  width: 50, // Set the desired width
                                  height: 50, // Set the desired height
                                  child: CircleAvatar(
                                    radius: 90,
                                    backgroundImage: NetworkImage(
                                      'http://192.168.56.1/' +
                                          (user['profile_picture'] ??
                                              ''), // Ensure to handle null profile picture
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
                            // Placeholder image for user post
                            if (post.containsKey('image'))
                              GestureDetector(
                                onTap: () {
                                  // Navigate to fullscreen image view
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => FullScreenImage(
                                      imageUrl: 'http://192.168.56.1/' +
                                          post['image'],
                                    ),
                                  ));
                                },
                                child: Image.network(
                                  'http://192.168.56.1/' + post['image'],
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    // Handle comment button
                                  },
                                  child: const Icon(Icons.comment_outlined),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    // Handle placeholder button
                                  },
                                  child: const Icon(Icons.thumb_up_off_alt),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    // Handle placeholder button
                                  },
                                  child: const Icon(Icons.share),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }
                  },
                  childCount: _posts.length +
                      1, // Total number of items (1 Suggestions Box + n User Posts)
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
class FullScreenImage extends StatelessWidget {
  final String imageUrl;

  const FullScreenImage({Key? key, required this.imageUrl}) : super(key: key);

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