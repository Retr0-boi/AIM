import 'package:flutter/material.dart';
import 'package:AIM/ui/app_bars/app_bar.dart';
import '../drawer/drawer.dart';
import 'bottom_navigation_bar.dart';

class Home extends StatelessWidget implements PreferredSizeWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.indigo[900],
      drawer: const MyDrawer(),
      bottomNavigationBar: MyBottomNavigationBar(
        currentIndex: 0,
        onItemTapped: (index) {},
      ),
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(
            // expandedHeight: 110, // Height of the Suggestions Box
            floating: false,
            pinned: true,
            flexibleSpace: HomeAppBar(),
          ),
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
              childCount:
                  6, // Total number of items (1 Suggestions Box + 5 User Posts)
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
