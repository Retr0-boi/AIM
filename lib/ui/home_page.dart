import 'package:flutter/material.dart';
import '../app_bar.dart';
import '../drawer.dart';
import '../bottom_navigation_bar.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final ScrollController _scrollController = ScrollController();
  bool _isVisible = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.position.userScrollDirection == ScrollDirection.reverse) {
      setState(() {
        _isVisible = false;
      });
    }
    if (_scrollController.position.userScrollDirection == ScrollDirection.forward) {
      setState(() {
        _isVisible = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MyDrawer(),
      bottomNavigationBar: MyBottomNavigationBar(
        currentIndex: 0,
        onItemTapped: (index) {},
      ),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            floating: true,
            pinned: true,
            snap: true,
            // Set expandedHeight if you want to have a custom app bar with an image, etc.
            // expandedHeight: 110,
            flexibleSpace: Visibility(
              visible: _isVisible,
              child: const MyAppBar(),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                // Remaining code remains the same
                if (index == 0) {
                  // Suggestions Box
                  return Container(
                    height: 110,
                    margin: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 9,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.all(8),
                          child: Column(
                            children: [
                              Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Center(
                                  child: CircleAvatar(
                                    radius: 25,
                                    backgroundColor: Colors.transparent,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'User $index',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                } else {
                  // User Posts Box
                  int userIndex = index - 1; // Adjust index for posts
                  return Container(
                    margin: EdgeInsets.all(8),
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 20,
                              child: const Icon(Icons.person),
                            ),
                            SizedBox(width: 8),
                            Text(
                              'User $userIndex',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        // Placeholder image for user post
                        Container(
                          height: 100,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 8),
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
              childCount: 6, // Total number of items (1 Suggestions Box + 5 User Posts)
            ),
          ),
        ],
      ),
    );
  }
}
