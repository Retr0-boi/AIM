import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  final String userId;

  const ChatScreen({required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with User $userId'),
      ),
      body: Center(
        child: Text('Chat content goes here.'),
      ),
    );
  }
}