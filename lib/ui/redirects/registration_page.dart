import 'package:albertians/ui/redirects/login_page.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:albertians/services/api_service.dart';
import 'package:albertians/models/db_helper.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final ApiService apiService = ApiService();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _batchYearController = TextEditingController();
  final TextEditingController _batchYear2Controller = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _currentInstitutionController =
      TextEditingController();
  final TextEditingController _programmeController = TextEditingController();
  final TextEditingController _expectedYearController = TextEditingController();
  final TextEditingController _currentOrganisationController =
      TextEditingController();
  final TextEditingController _designationController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  DateTime? selectedDate;
  String _selectedDepartment = "";
  String _selectedProgram = "";
  String _selectedStatus = "";

  final List<String> departments = [];
  final List<String> programs = [];
  final List<String> statuses = [
    "Student",
    "Working (Govt)",
    "Working (Non Govt)",
    "Entrepreneur",
    "Not Working",
  ];

  @override
  void initState() {
    super.initState();
    _fetchDepartments(); // Fetch departments from API
    _selectedDepartment = departments.isNotEmpty ? departments[0] : "";
    _selectedProgram = programs.isNotEmpty ? programs[0] : "";
    _selectedStatus = statuses.isNotEmpty ? statuses[0] : "";
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
        print("Failed to fetch departments: ${data['error']}");
      }
    } catch (e) {
      print("Error fetching departments: $e");
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
        print("Failed to fetch courses: ${data['error']}");
      }
    } catch (e) {
      print("Error fetching courses: $e");
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _dobController.text = selectedDate!.toLocal().toString().split(' ')[0];
      });
    }
  }

  bool _isPasswordVisible = false;

  Widget _buildAdditionalFieldsBasedOnStatus() {
    switch (_selectedStatus) {
      case "Student":
        return Column(
          children: [
            TextField(
              controller: _currentInstitutionController,
              decoration: const InputDecoration(
                labelText: 'Current Institution',
              ),
            ),
            const SizedBox(height: 8.0),
            TextField(
              controller: _programmeController,
              decoration: const InputDecoration(
                labelText: 'Programme',
              ),
            ),
            const SizedBox(height: 8.0),
            TextField(
              controller: _expectedYearController,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
              ],
              decoration: const InputDecoration(
                labelText: 'Expected Year of Passing',
              ),
            ),
          ],
        );
      case "Working (Govt)":
      case "Working (Non Govt)":
      case "Entrepreneur":
        return Column(
          children: [
            TextField(
              controller: _currentOrganisationController,
              decoration: const InputDecoration(
                labelText: 'Current Organisation',
              ),
            ),
            const SizedBox(height: 8.0),
            TextField(
              controller: _designationController,
              decoration: const InputDecoration(
                labelText: 'Designation',
              ),
            ),
          ],
        );
      default:
        return const SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Albertians registration',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF002147),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // const SizedBox(height: 8.0),
              Image.asset(
                'images/Alberts.png',
                width: 200, // Adjust width as needed
                height: 200, // Adjust height as needed
              ),
              const SizedBox(height: 8.0),

              // Department Dropdown
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
              const SizedBox(height: 8.0),

              // Program Dropdown
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
              const SizedBox(height: 8.0),

              // Current Status Dropdown
              DropdownButtonFormField<String>(
                value: _selectedStatus,
                onChanged: (value) {
                  setState(() {
                    _selectedStatus = value!;
                  });
                },
                items: statuses.map((status) {
                  return DropdownMenuItem(
                    value: status,
                    child: Text(status),
                  );
                }).toList(),
                decoration: const InputDecoration(
                  labelText: 'Current Status',
                ),
                style: const TextStyle(
                    color: Colors.black), // change text color to white
                dropdownColor: Colors.white,
              ),
              const SizedBox(height: 8.0),

              // Batch (Two input boxes for years) with label
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        'Batch',
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                      const SizedBox(width: 16.0),
                      Expanded(
                        child: TextField(
                          controller: _batchYearController,
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          decoration: const InputDecoration(
                            labelText: 'From',
                          ),
                        ),
                      ),
                      const SizedBox(width: 16.0),
                      Expanded(
                        child: TextField(
                          controller: _batchYear2Controller,
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          decoration: const InputDecoration(
                            labelText: 'To',
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8.0),

              // Name
              TextField(
                controller: _nameController,
                keyboardType: TextInputType.text,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(
                    RegExp(r'[a-zA-Z\s]'),
                  ),
                ],
                decoration: const InputDecoration(
                  labelText: 'Name',
                ),
              ),
              const SizedBox(height: 8.0),

              // DOB with Date Picker
              InkWell(
                onTap: () => _selectDate(context),
                child: IgnorePointer(
                  child: TextField(
                    controller: _dobController,
                    decoration: const InputDecoration(
                      labelText: 'DOB',
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8.0),

              // Additional Fields based on Status
              _buildAdditionalFieldsBasedOnStatus(),
              const SizedBox(height: 8.0),
              // Phone
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                ],
                decoration: const InputDecoration(
                  labelText: 'Phone',
                ),
              ),
              const SizedBox(height: 8.0),
              // Email
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
              ),
              const SizedBox(height: 8.0),

              // Password
              TextField(
                controller: _passwordController,
                obscureText: !_isPasswordVisible,
                decoration: InputDecoration(
                  labelText: 'Password',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                ),
              ),

              const SizedBox(height: 32.0),

              // Register Button
              ElevatedButton(
                onPressed: () async {
                  try {
                    // Handle registration logic here
                    Map<String, dynamic> registrationData = {
                      'department': _selectedDepartment,
                      'program': _selectedProgram,
                      'batch_from': _batchYearController.text,
                      'batch_to': _batchYear2Controller.text,
                      'name': _nameController.text,
                      'DOB': _dobController.text,
                      'email': _emailController.text,
                      'password': _passwordController.text,
                      'account_status': 'waiting',
                      'identification': 'none',
                      'updation_date': 'none',
                      'updation_time': 'none',
                      'profile_picture':
                          '../../AIM/Alumni/user_management/assets/profile_pictures/DefaultUserIcon.png',
                      'current_status':
                          _selectedStatus, // Add this line for the 'current_status' field
                      'current_institution': _currentInstitutionController
                          .text, // Add this line if applicable
                      'programme': _programmeController
                          .text, // Add this line if applicable
                      'expected_year_of_passing': _expectedYearController
                          .text, // Add this line if applicable
                      'current_organisation': _currentOrganisationController
                          .text, // Add this line if applicable
                      'designation': _designationController
                          .text, // Add this line if applicable
                      'phone':
                          _phoneController.text, // Add this line if applicable
                    };

                    Map<String, dynamic> registrationResult =
                        await apiService.registerUser(registrationData);

                    bool registrationSuccess =
                        registrationResult['success'] ?? false;

                    if (registrationSuccess) {
                      print("registered successfully");

                      // Insert registration data into local SQLite database
                      await DBHelper.insertRegistrationData(registrationData);

                      // Navigate to the LoginPage
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginPage(),
                        ),
                      );
                    } else {
                      print('Registration failed');
                    }
                  } catch (e) {
                    // Print the full error message
                    print('Error registration_page.dart: $e');
                  }
                },
                child: const Text('Register'),
              ),
              const SizedBox(height: 32.0),

              // Already have an account? Click here
              GestureDetector(
                onTap: () {
                  // Navigate to the login page and replace the current page in the stack
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                child: const Text(
                  'Already have an account? Click here',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                    color: Colors.blue,
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
            ],
          ),
        ),
      ),
    );
  }

  Map<String, dynamic> _getAdditionalFieldsBasedOnStatus() {
    switch (_selectedStatus) {
      case "Student":
        return {
          'current_institution': _currentInstitutionController.text,
          'programme': _programmeController.text,
          'expected_year_of_passing': _expectedYearController.text,
        };
      case "Working (Govt)":
      case "Working (Non Govt)":
      case "Entrepreneur":
        return {
          'current_organisation': _currentOrganisationController.text,
          'designation': _designationController.text,
        };
      default:
        return {};
    }
  }

  @override
  void dispose() {
    // Dispose of your controllers
    _nameController.dispose();
    _dobController.dispose();
    _batchYearController.dispose();
    _batchYear2Controller.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _currentInstitutionController.dispose();
    _programmeController.dispose();
    _expectedYearController.dispose();
    _currentOrganisationController.dispose();
    _designationController.dispose();
    _emailController.dispose();

    super.dispose();
  }
}
