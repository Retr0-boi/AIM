import 'package:flutter/material.dart';
import 'package:AIM/ui/app_bars/app_bar.dart';
import 'package:AIM/ui/drawer/drawer.dart';
// import 'package:AIM/bottom_navigation_bar.dart';
class Alumni extends StatefulWidget {
  const Alumni({Key? key}) : super(key: key);

  @override
  _AlumniState createState() => _AlumniState();
}

class _AlumniState extends State<Alumni> {
  String? selectedDepartment;
  String? selectedCourse;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AlumniAppBar(),
      drawer: const MyDrawer(),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  // Search Bar
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: const TextField(
                      decoration: InputDecoration(
                        hintText: 'Search for names...',
                        prefixIcon: Icon(Icons.search),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Dropdowns and TextFields
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Department Dropdown
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: DropdownButton<String>(
                              value: selectedDepartment,
                              items: ['MBA']
                                  .map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              hint: const Text('Select Department'),
                              onChanged: (String? value) {
                                setState(() {
                                  selectedDepartment = value;
                                });
                              },
                              style: TextStyle(color: Colors.black), // change text color to white
                              dropdownColor: Colors.white, // change dropdown background color to black
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 16),

                      // Course Dropdown
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: DropdownButton<String>(
                              value: selectedCourse,
                              items: ['MBA']
                                  .map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              hint: const Text('Select Course'),
                              onChanged: (String? value) {
                                setState(() {
                                  selectedCourse = value;
                                });
                              },
                              style: TextStyle(color: Colors.black), // change text color to white
                              dropdownColor: Colors.white, // change dropdown background color to black
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Batch TextFields
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: const Padding(
                            padding:
                                EdgeInsets.symmetric(horizontal: 8.0),
                            child: TextField(
                              decoration: InputDecoration(
                                labelText: 'Batch From',
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 16),

                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: const Padding(
                            padding:
                                EdgeInsets.symmetric(horizontal: 8.0),
                            child: TextField(
                              decoration: InputDecoration(
                                labelText: 'Batch To',
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Search Button
                  ElevatedButton(
                    onPressed: () {
                      // Validate inputs
                      // If batch search, ensure both batch from and to are provided
                      // If not batch search, at least one query must be provided
                      // Perform search based on inputs
                    },
                    child: Text('Search'),
                  ),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return Container(
                  margin: const EdgeInsets.fromLTRB(16.0,0.0,16.0,8.0),
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        backgroundColor: Colors.grey,
                        // Replace with user's profile picture
                      ),
                      const SizedBox(width: 16),
                      Text('User $index'), // Replace with user's name
                    ],
                  ),
                );
              },
              childCount: 10, // Replace with the actual number of users
            ),
          ),
        ],
      ),
    );
  }
}