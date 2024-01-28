import 'package:flutter/material.dart';
import 'ui/home_page.dart';
import 'ui/registration_page.dart';
import 'backend/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AIM',
      theme: ThemeData(
        primaryColor: const Color(0xFF002147),
        secondaryHeaderColor: const Color(0xFF8F2817),
        canvasColor: const Color(0xFF002147),
        focusColor: Colors.blueAccent[700],
        primarySwatch: Colors.green,
        unselectedWidgetColor: Colors.white38,
      ),
      home: AuthenticationWrapper(),
    );
  }
}
class AuthenticationWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: AuthService.isLoggedIn(),
      
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          bool isLoggedIn = snapshot.data ?? false;
          return isLoggedIn ? Home() : RegistrationPage();
        } else {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}




// gotta fix the home page drawer button
// gotta set redirects and some exception handling
// permission thingy + posts
// networking page + filters
// chat ui

// Database Connection:
// The database connection details should not be hard-coded in the API file. 
//It's better to store these details in a configuration file, and possibly use environment variables for sensitive information.