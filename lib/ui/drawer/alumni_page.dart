// ignore_for_file: prefer_interpolation_to_compose_strings, use_build_context_synchronously

import 'package:albertians/services/api_service.dart';
import 'package:albertians/ui/drawer/profile_details_page.dart';
import 'package:flutter/material.dart';
import 'package:albertians/ui/app_bars/app_bar.dart';
import 'package:flutter/services.dart';

class Alumni extends StatefulWidget {
  const Alumni({super.key});

  @override
  State<Alumni> createState() => _AlumniState();
}

class _AlumniState extends State<Alumni> {
  final ApiService apiService = ApiService();

  TextEditingController searchTextController = TextEditingController();
  // String? selectedDepartment;
  String? batchFrom;
  String? batchTo;


  String _selectedDepartment = "";
  String _selectedProgram = "";

  final List<String> departments = [];
  final List<String> programs = [];

    @override
  void initState() {
    super.initState();
    _fetchDepartments(); // Fetch departments from API
    _selectedDepartment = departments.isNotEmpty ? departments[0] : "";
    _selectedProgram = programs.isNotEmpty ? programs[0] : "";
  }
Future<void> _fetchDepartments() async {
    try {
      final Map<String, dynamic> data =
          await apiService.fetchDepartmentsAndPrograms();
      if (data['success']) {
        setState(() {
          departments
              .clear(); // Clear existing departments before adding new ones
          data['departments'].forEach((dept) {
            departments.add(dept
                .toString()); // Convert to String and add to departments list
          });
          _selectedDepartment = departments.isNotEmpty
              ? departments[0]
              : ""; // Initialize selected department here
        });
      } else {
        // print("Failed to fetch departments: ${data['error']}");
      }
    } catch (e) {
      // print("Error fetching departments: $e");
    }
  }
 Future<void> _fetchCoursesByDepartment(String department) async {
    try {
      final Map<String, dynamic> data =
          await apiService.fetchCoursesByDepartment(department);
      if (data['success']) {
        setState(() {
          programs.clear(); // Clear existing programs
          programs.addAll(
              data['courses'].map<String>((course) => course.toString()));
          _selectedProgram = programs.isNotEmpty ? programs[0] : "";
        });
      } else {
        // print("Failed to fetch courses: ${data['error']}");
      }
    } catch (e) {
      // print("Error fetching courses: $e");
    }
  }
  List<Map<String, dynamic>> alumniData = [];
  @override
  void dispose() {
    searchTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AlumniAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Search Bar
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: TextField(
                controller: searchTextController,
                decoration: const InputDecoration(
                  hintText: 'Search for names...',
                  prefixIcon: Icon(Icons.search),
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Department Dropdown
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child:
                 DropdownButtonFormField<String>(
                value: _selectedDepartment,
                onChanged: (value) {
                  setState(() {
                    _selectedDepartment = value!;
                    _fetchCoursesByDepartment(_selectedDepartment);
                  });
                },
                items: departments.map((department) {
                  return DropdownMenuItem(
                    value: department,
                    child: Text(department),
                  );
                }).toList(),
                decoration: const InputDecoration(
                  labelText: 'Department',
                ),
                style: const TextStyle(
                    color: Colors.black), // change text color to white
                dropdownColor: Colors.white,
              ),
              ),
            ),
            const SizedBox(height: 20),
            // Course Dropdown
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: 
                DropdownButtonFormField<String>(
                value: _selectedProgram,
                onChanged: (value) {
                  if (_selectedDepartment.isEmpty) {
                    // If department is not selected, show temporary message
                    setState(() {
                      _selectedProgram = ""; // Reset selected program
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Select a department to continue'),
                      ),
                    );
                  } else {
                    // If department is selected, update selected program
                    setState(() {
                      _selectedProgram = value!;
                    });
                  }
                },
                items: programs.map((program) {
                  return DropdownMenuItem(
                    value: program,
                    child: Text(program),
                  );
                }).toList(),
                decoration: const InputDecoration(
                  labelText: 'Program',
                ),
                style: const TextStyle(
                    color: Colors.black), // change text color to white
                dropdownColor: Colors.white,
              ),
              ),
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
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: TextField(
                        decoration: const InputDecoration(
                          labelText: 'Batch From',
                          border: InputBorder.none,
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          LengthLimitingTextInputFormatter(4),
                        ],
                        onChanged: (value) {
                          batchFrom = value;
                        },
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
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: TextField(
                        decoration: const InputDecoration(
                          labelText: 'Batch To',
                          border: InputBorder.none,
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          LengthLimitingTextInputFormatter(4),
                        ],
                        onChanged: (value) {
                          batchTo = value;
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Search Button
            ElevatedButton(
              onPressed: () async {
                // Call the API service method
                List<Map<String, dynamic>> data = await apiService.searchAlumni(
                  name: searchTextController.text,
                  department: _selectedDepartment,
                  course: _selectedProgram,
                  batchFrom: batchFrom,
                  batchTo: batchTo,
                );
                // print("RECIEEVED DATA: $data");
                setState(() {
                  alumniData = data;
                });
              },
              child: const Text('Search'),
            ),
            const SizedBox(height: 20),
            // Display Search Results
            Expanded(
              child: ListView.builder(
                itemCount: alumniData.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    onTap: () {
                      // print('Clicked Alumni ID: ${alumniData[index]['_id']}');
                      // Call the method to fetch and display user data when ListTile is clicked
                      _fetchAndDisplayUserData('${alumniData[index]['_id']}');
                    },

                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(
                        serverUrl + alumniData[index]['profile_picture'],
                        // 'http://192.168.45.72/' + alumniData[index]['profile_picture'],
                        
                      ),
                    ),
                    title: Text('${alumniData[index]['name'] ?? 'Unknown'}'),
                    // Add more fields as needed
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _fetchAndDisplayUserData(String mongoId) async {
    try {
      // Call the API service method to fetch user data
      Map<String, dynamic> userData = await apiService.fetchUserData(mongoId);

      // Check if the request was successful
      if (userData['success'] == true) {
        // Navigate to the profile details page and pass the user data
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProfileDetailsPage(userData: userData),
          ),
        );
      } else {
        // Handle case when the API indicates failure
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error'),
              content: Text(
                'Failed to fetch user data. Reason: $mongoId',
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      // Handle general exception
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text('Exception occurred while fetching user data: $e'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }
}
