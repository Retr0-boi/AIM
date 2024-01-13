import 'package:flutter/material.dart';


class ErrorPage extends StatefulWidget {
  @override
  _ErrorPageState createState() => _ErrorPageState();
}

class _ErrorPageState extends State<ErrorPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Error Page'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error,
                size: 50,
                color: Colors.red,
              ),
              SizedBox(height: 20),
              Text(
                'Oops! It seems like you already sent a registration request, please wait for our response through mail!\nIf you didn\'t send this request, please contact our support team at support@aim.com',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center, // This line centers the text
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Navigate back to the previous screen or home page
                  Navigator.pop(context);
                },
                child: Text('Go Back'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
