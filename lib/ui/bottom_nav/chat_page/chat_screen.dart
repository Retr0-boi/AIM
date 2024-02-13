import 'package:AIM/services/api_service.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final String mongoId;
  final String receiverMongoId;
  final String name;
  final String profilePicture;
  final String conversationId;

  const ChatScreen({
    Key? key,
    required this.mongoId,
    required this.receiverMongoId,
    required this.name,
    required this.profilePicture,
    required this.conversationId,
  }) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final List<Map<String, String>> _messages = [];
  ApiService _apiService = ApiService(); // Initialize your ApiService
  String? currentUser; // Define currentUser variable

  @override
  void initState() {
    super.initState();
    _fetchMessages();
  }

  void _fetchMessages() async {
    // Call the API service method to fetch messages
    Map<String, dynamic> result =
        await _apiService.fetchMessages(widget.conversationId);

    if (result['success']) {
      setState(() {
        _messages.addAll(result['messages']);
      });
    } else {
      // Handle error when fetching messages
      print('Error fetching messages: ${result['error']}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
  backgroundColor: Theme.of(context).primaryColor,
  leading: Builder(
    builder: (BuildContext context) {
      return Row(
        children: [
          IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              //logic to go back a page
              Navigator.pop(context);
            },
          ),
          const SizedBox(width: 12), // Add spacing between back icon and profile picture
          CircleAvatar(
            backgroundImage: NetworkImage('http://192.168.56.1/' +widget.profilePicture),
            radius: 16, // Adjust the radius as needed
          ),
          const SizedBox(width: 12), // Add spacing between profile picture and name
          Text(
            widget.name,
            style: TextStyle(
              color: Theme.of(context).focusColor,
            ),
          ),
        ],
      );
    },
  ),
),
      body: Column(
        children: <Widget>[
          Flexible(
            child: _messages.isEmpty
                ? Center(
                    child: Text('This place looks empty. Send a hi!'),
                  )
                : ListView.builder(
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
                    color: isCurrentUser
                        ? Colors.blue[200]
                        : Colors.grey[300],
                    borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(12.0),
                        topRight: const Radius.circular(12.0),
                        bottomLeft: isCurrentUser
                            ? const Radius.circular(12.0)
                            : const Radius.circular(0)),
                  ),
                  child: Text(
                    message["message"]!,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize:
                          16.0, // Adjust font size here
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
