import 'package:AIM/ui/bottom_nav/home_page.dart';
import 'package:flutter/material.dart';
import 'package:AIM/services/api_service.dart';
import 'package:AIM/models/db_helper.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

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
        padding: const EdgeInsets.fromLTRB(16.0, 48.0, 16.0, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
                  // Access the MongoDB object ID from the response
                  String mongoId = authenticationResult['mongo_id'];
                  String userName = authenticationResult['userName'];
                  Map<String, dynamic> userData = {
                    'username': userName, // Replace with actual data
                    'email': _emailController.text,
                    'mongo_id': mongoId,
                    'password': _passwordController.text, // Replace with actual data
                  };

                  // Insert user data into SQLite
                  await DBHelper.insertUserData(userData);
                  // Navigate to the home page and pass the MongoDB object ID
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const Home()),
                  );
                } else {
                  // Show an error dialog on failed login
                  showDialog( 
                    context: context,
                    builder: (BuildContext context) {
                      return  AlertDialog(
                        title: const Text('Login Failed'),
                        content: Text(authenticationResult['error'] ?? 'Unknown error'),
                        actions: [
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
              },
              child: const Text('Login'),
            ),
            const SizedBox(height: 128.0),
          ],
        ),
      ),
    );
  }
}
