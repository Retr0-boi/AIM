import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: RegistrationPage(),
    );
  }
}

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _dobController = TextEditingController();
  TextEditingController _batchYearController = TextEditingController();
  TextEditingController _batchYear2Controller = TextEditingController();
  TextEditingController _departmentController = TextEditingController();
  TextEditingController _specializationController = TextEditingController();

  DateTime? selectedDate; // To store selected date

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registration Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 48.0, 16.0, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Name
            TextField(
              controller: _nameController,
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

            // Batch (Two input boxes for years) with label
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Batch',
                      style: TextStyle(
                        // fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                    SizedBox(width: 16.0),
                    Expanded(
                      child: TextField(
                        controller: _batchYearController,
                        keyboardType: TextInputType.number,
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

            // Department
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _departmentController,
                        decoration: InputDecoration(
                          labelText: 'Department',
                        ),
                      ),
                    ),
                    SizedBox(width: 16.0),
                    Expanded(
                      child: TextField(
                        controller: _specializationController,
                        decoration: InputDecoration(
                          labelText: 'Specialization',
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),

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
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
              ),
            ),
            SizedBox(height: 32.0),

            // Register Button
            ElevatedButton(
              onPressed: () {
                // Handle registration logic here
                print('Name: ${_nameController.text}');
                print('DOB: ${_dobController.text}');
                print('Batch - From: ${_batchYearController.text}');
                print('Batch - To: ${_batchYear2Controller.text}');
                print('Department: ${_departmentController.text}');
                print('Specialization: ${_specializationController.text}');
                print('Email: ${_emailController.text}');
                print('Password: ${_passwordController.text}');
                // _navigateToPage(context, SettingsPage());
              },
              child: Text('Register'),
            ),
            SizedBox(height: 32.0),

            Text(
              'Alreay have an account? click here',
              style: TextStyle(
                // fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToPage(BuildContext context, Widget page) {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => page,
      ),
    );
  }
}
