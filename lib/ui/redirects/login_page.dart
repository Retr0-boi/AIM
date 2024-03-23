// ignore_for_file: use_build_context_synchronously

import 'package:albertians/models/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:albertians/models/userData.dart';
import 'package:albertians/ui/bottom_nav/home_page.dart';
import 'package:albertians/services/api_service.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Login Page',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF002147),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
                'images/Alberts.png',
                width: 200, // Adjust width as needed
                height: 200, // Adjust height as needed
              ),
              const SizedBox(height: 8.0),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
            ),
            const SizedBox(height: 8.0),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
            ),
            const SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: () async {
                // Perform user authentication
                Map<String, dynamic> authenticationResult =
                    await ApiService().loginUser(
                  _emailController.text,
                  _passwordController.text,
                );

                bool isAuthenticated = authenticationResult['success'];

                if (isAuthenticated) {
                  // Access user data from the response
                  UserData userData = UserData.fromJson(authenticationResult);

                  Map<String, dynamic> authUserData = {
                    "mongo_id": userData.mongoId,
                    "username": userData.username,
                    "email": userData.email,
                    "password": userData.password,
                    "department": userData.department,
                    "batch_from": userData.batchFrom,
                    "batch_to": userData.batchTo,
                  };
                  DBHelper.insertUserData(authUserData);
                  // Update user data in the app state
                  Provider.of<UserData>(context, listen: false).updateUserData(
                    mongoId: userData.mongoId,
                    username: userData.username,
                    email: userData.email,
                    password: userData.password,
                    department: userData.department,
                    batchFrom: userData.batchFrom,
                    batchTo: userData.batchTo,
                    isLoggedIn: userData.isLoggedIn,
                    // Add other fields as needed
                  );

                  // Navigate to the home page
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Home(),
                    ),
                  );
                } else {
                  // Show an error message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        authenticationResult['error'] ?? 'Unknown error',
                      ),
                    ),
                  );
                }
              },
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
