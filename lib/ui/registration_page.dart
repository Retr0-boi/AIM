import 'package:AIM/ui/login_page.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:AIM/services/api_service.dart';
import 'package:AIM/backend/db_helper.dart';

class RegistrationPage extends StatefulWidget {
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

  DateTime? selectedDate;
  String _selectedDepartment = "";
  String _selectedProgram = "";
  String _selectedStatus = "";

  final List<String> departments = [
    "Department A",
    "Department B",
    "Department C"
  ];
  final List<String> programs = ["Program 1", "Program 2", "Program 3"];
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

    // Initialize dropdown values
    _selectedDepartment = departments.isNotEmpty ? departments[0] : "";
    _selectedProgram = programs.isNotEmpty ? programs[0] : "";
    _selectedStatus = statuses.isNotEmpty ? statuses[0] : "";
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
              decoration: InputDecoration(
                labelText: 'Current Institution',
              ),
            ),
            SizedBox(height: 8.0),
            TextField(
              controller: _programmeController,
              decoration: InputDecoration(
                labelText: 'Programme',
              ),
            ),
            SizedBox(height: 8.0),
            TextField(
              controller: _expectedYearController,
              decoration: InputDecoration(
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
              decoration: InputDecoration(
                labelText: 'Current Organisation',
              ),
            ),
            SizedBox(height: 8.0),
            TextField(
              controller: _designationController,
              decoration: InputDecoration(
                labelText: 'Designation',
              ),
            ),
          ],
        );
      default:
        return SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Registration Page',
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
              // Department Dropdown
              DropdownButtonFormField<String>(
                value: _selectedDepartment,
                onChanged: (value) {
                  setState(() {
                    _selectedDepartment = value!;
                  });
                },
                items: departments.map((department) {
                  return DropdownMenuItem(
                    value: department,
                    child: Text(department),
                  );
                }).toList(),
                decoration: InputDecoration(
                  labelText: 'Department',
                ),
              ),
              SizedBox(height: 8.0),

              // Program Dropdown
              DropdownButtonFormField<String>(
                value: _selectedProgram,
                onChanged: (value) {
                  setState(() {
                    _selectedProgram = value!;
                  });
                },
                items: programs.map((program) {
                  return DropdownMenuItem(
                    value: program,
                    child: Text(program),
                  );
                }).toList(),
                decoration: InputDecoration(
                  labelText: 'Program',
                ),
              ),
              SizedBox(height: 8.0),

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
                decoration: InputDecoration(
                  labelText: 'Current Status',
                ),
              ),
              SizedBox(height: 8.0),

              // Batch (Two input boxes for years) with label
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Batch',
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                      SizedBox(width: 16.0),
                      Expanded(
                        child: TextField(
                          controller: _batchYearController,
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          decoration: InputDecoration(
                            labelText: 'From',
                          ),
                        ),
                      ),
                      SizedBox(width: 16.0),
                      Expanded(
                        child: TextField(
                          controller: _batchYear2Controller,
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          decoration: InputDecoration(
                            labelText: 'To',
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 8.0),

              // Name
              TextField(
                controller: _nameController,
                keyboardType: TextInputType.text,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(
                    RegExp(r'[a-zA-Z\s]'),
                  ),
                ],
                decoration: InputDecoration(
                  labelText: 'Name',
                ),
              ),
              SizedBox(height: 8.0),

              // DOB with Date Picker
              InkWell(
                onTap: () => _selectDate(context),
                child: IgnorePointer(
                  child: TextField(
                    controller: _dobController,
                    decoration: InputDecoration(
                      labelText: 'DOB',
                    ),
                  ),
                ),
              ),
              SizedBox(height: 8.0),

              // Additional Fields based on Status
              _buildAdditionalFieldsBasedOnStatus(),
              SizedBox(height: 8.0),

              // Email
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                ),
              ),
              SizedBox(height: 8.0),

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

              SizedBox(height: 32.0),

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
                      'profile_picture': 'DefaultUserIcon.png',
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

    super.dispose();
  }
}
