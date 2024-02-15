import 'package:albertians/services/api_service.dart';
import 'package:albertians/ui/drawer/profile_details_page.dart';
import 'package:flutter/material.dart';
import 'package:albertians/ui/app_bars/app_bar.dart';
import 'package:flutter/services.dart';

class Alumni extends StatefulWidget {
  const Alumni({super.key});

  @override
  _AlumniState createState() => _AlumniState();
}

class _AlumniState extends State<Alumni> {
  final ApiService apiService = ApiService();

  TextEditingController searchTextController = TextEditingController();
  String? selectedDepartment;
  String? selectedCourse;
  String? batchFrom;
  String? batchTo;
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
                child: DropdownButton<String>(
                  value: selectedDepartment,
                  items: [
                    'MBA',
                  ] // Replace with your department options
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
                  style: const TextStyle(color: Colors.black),
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
                child: DropdownButton<String>(
                  value: selectedCourse,
                  items: [
                    'MBA',
                  ] // Replace with your course options
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
                  style: const TextStyle(color: Colors.black),
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
                  department: selectedDepartment,
                  course: selectedCourse,
                  batchFrom: batchFrom,
                  batchTo: batchTo,
                );
                print("RECIEEVED DATA: $data");
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
                        'http://192.168.56.1/' + alumniData[index]['profile_picture'],
                        
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
