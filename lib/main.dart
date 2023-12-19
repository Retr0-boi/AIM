import 'package:flutter/material.dart';
import 'ui/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AIM',
      theme: ThemeData(
        primaryColor: const Color(0xFF002147),
        secondaryHeaderColor: const Color(0xFF8F2817),
        canvasColor: const Color(0xFF002147),
        focusColor: Colors.blueAccent[700],
        unselectedWidgetColor: Colors.white38,
      ),
      home: const Home(),
    );
  }
}