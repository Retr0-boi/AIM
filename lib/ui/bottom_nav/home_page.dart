import 'package:flutter/material.dart';
import 'bottom_navigation_bar.dart';
import 'package:AIM/ui/drawer/drawer.dart';

class Home extends StatelessWidget {
  const Home({super.key});

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
                    int userIndex = index - 1; // Adjust index for posts
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
                              const CircleAvatar(
                                radius: 20,
                                child: Icon(Icons.person),
                              ),
                              const SizedBox(width: 8),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'User $userIndex',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  const Text(
                                    'Placeholder Department and batch',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const Text(
                            'Your placeholder text here',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 8),
                          // Placeholder image for user post
                          Container(
                            height: 250,
                            color: const Color.fromARGB(255, 150, 64, 64),
                          ),
                          const SizedBox(height: 8),
                          // Placeholder text after the red-tinted container
                          const Text(
                            'Your placeholder text here',
                            style: TextStyle(
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
                  },
                  childCount: 6, // Total number of items (1 Suggestions Box + 5 User Posts)
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}