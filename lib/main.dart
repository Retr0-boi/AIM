import 'package:flutter/material.dart';
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
      home: const AuthenticationWrapper(),
    );
  }
}
class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: AuthService.isLoggedIn(),
      
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          bool isLoggedIn = snapshot.data ?? false;
          return isLoggedIn ? const Home() : const RegistrationPage();
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

// CLIENT SIDE

// events set aakanam
// alumni search set aakanam
// drawer profile picture set aakanam
// campus visit set aakanam
// job request set aakanam
// posts set aakanam on home apge 
// share,like, comment set aakanam
// connection page popup thingy for profiles
// real time notifcations
// actual messaging thingy
// settings page enthelum aakanam (optional)


// SERVER SIDE

// REQUEST ID 
// post management
// request management
// notifications 
// login mysql aakanam
