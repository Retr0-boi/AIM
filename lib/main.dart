import 'package:albertians/models/userData.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'ui/bottom_nav/home_page.dart';
import 'ui/redirects/registration_page.dart';
import 'models/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<UserData>(
      create: (_) => UserData(), // Create an instance of UserData
      child: MaterialApp(
        title: 'AIM',
        theme: ThemeData(
          primaryColor: const Color(0xFF002147),
          secondaryHeaderColor: const Color(0xFF8F2817),
          canvasColor: const Color(0xFF002147),
          focusColor: Colors.blueAccent[700],
          primarySwatch: Colors.green,
          unselectedWidgetColor: Colors.white38,
        ),
        home: const AuthenticationWrapper(),
      ),
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserData?>(
      future: AuthService.getUserData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          UserData? userData = snapshot.data;
          bool isLoggedIn = userData != null;

          if (isLoggedIn) {
            return Home(userData: userData);
          } else {
            return const RegistrationPage();
          }
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
