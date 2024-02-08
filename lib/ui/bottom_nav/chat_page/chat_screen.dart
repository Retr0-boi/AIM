import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final List<Map<String, String>> _messages = [
    {"sender": "User", "message": "Hello!"},
    {"sender": "Other", "message": "Hi there!"},
    {"sender": "Other", "message": "How are you?"},
    {"sender": "User", "message": "I'm good, thank you!"},
    {"sender": "User", "message": "What are you up to?"},
    {"sender": "Other", "message": "Just working on some Flutter code."},
    {"sender": "User", "message": "That's cool!"},
    {"sender": "Other", "message": "Yes, it's really fun!"},
  ];

  String? currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Username/group name",
          style: TextStyle(
            color: Theme.of(context).focusColor,
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () {
                //logic to go back a page
                Navigator.pop(context);
              },
            );
          },
        ),
      ),
      body: Column(
        children: <Widget>[
          Flexible(
            child: ListView.builder(
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (BuildContext context, int index) {
                return _buildMessage(_messages[index]);
              },
            ),
          ),
          const Divider(height: 1.0),
          _buildTextComposer(),
        ],
      ),
    );
  }

  Widget _buildTextComposer() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: <Widget>[
          Flexible(
            child: TextField(
              controller: _textController,
              onSubmitted: _handleSubmitted,
              decoration: const InputDecoration.collapsed(
                hintText: "Send a message",
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () => _handleSubmitted(_textController.text),
          ),
        ],
      ),
    );
  }

  void _handleSubmitted(String text) {
    _textController.clear();
    setState(() {
      _messages.insert(0, {"sender": "User", "message": text});
    });
  }

  Widget _buildMessage(Map<String, String> message) {
  bool isCurrentUser = message["sender"] == "User";
  bool isNewUser = currentUser != message["sender"];
  currentUser = message["sender"];

  return Container(
    margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (!isCurrentUser) ...[
          isNewUser
              ? CircleAvatar(child: Text(message["sender"]![0]))
              : const SizedBox(width: 40.0),
          const SizedBox(width: 10.0),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: isCurrentUser
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: isCurrentUser ? Colors.blue[200] : Colors.grey[300],
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(12.0),
                    topRight: const Radius.circular(12.0),
                    bottomLeft: isCurrentUser
                        ? const Radius.circular(12.0)
                        : const Radius.circular(0)
                  ),
                ),
                child: Text(
                  message["message"]!,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0, // Adjust font size here
                  ),
                ),
              ),
            ],
          ),
        ),
        
      ],
    ),
  );
}
}
