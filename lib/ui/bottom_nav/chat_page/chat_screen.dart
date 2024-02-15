import 'package:albertians/services/api_service.dart';
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
    List<dynamic> messages = result['messages'];
    List<Map<String, String>> formattedMessages = [];
    for (var message in messages) {
      formattedMessages.add({
        '_id': message['_id']['\$oid'],
        'conversationId': message['conversationId'],
        'message': message['message'],
        'receiverMongoId': message['receiverMongoId'],
        'senderMongoId': message['senderMongoId'],
        'timestamp': message['timestamp']['\$date']['\$numberLong'],
      });
    }

    setState(() {
      _messages.addAll(formattedMessages);
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
                const SizedBox(
                    width:
                        12), // Add spacing between back icon and profile picture
                CircleAvatar(
                  backgroundImage: NetworkImage(
                      'http://192.168.56.1/' + widget.profilePicture),
                  radius: 16, // Adjust the radius as needed
                ),
                const SizedBox(
                    width: 12), // Add spacing between profile picture and name
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

void _handleSubmitted(String text) async {
  _textController.clear();
  
  // Construct the message object to be consistent with received messages
  Map<String, String> newMessage = {
    '_id': 'temporary_id',  // You can assign a temporary ID or use null
    'conversationId': widget.conversationId,
    'message': text,
    'receiverMongoId': widget.receiverMongoId,
    'senderMongoId': widget.mongoId,
    'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
    'sender': 'User',  // Indicate that the message is sent by the current user
  };

  setState(() {
    _messages.insert(0, newMessage);
  });

  // Call the API service method to send the message
  Map<String, dynamic> result = await _apiService.sendMessage(
      widget.conversationId, text, widget.receiverMongoId, widget.mongoId);

  if (!result['success']) {
    // Handle error when sending message
    print('Error sending message: ${result['error']}');
  }
}

  // void _handleSubmitted(String text) {
  //   _textController.clear();
  //   setState(() {
  //     _messages.insert(0, {"sender": "User", "message": text});
  //   });
  // }

  Widget _buildMessage(Map<String, String> message) {
  bool isCurrentUser = message["senderMongoId"] == widget.mongoId;

  return Container(
    margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
    child: Row(
      mainAxisAlignment: isCurrentUser
          ? MainAxisAlignment.end
          : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (!isCurrentUser) ...[
          CircleAvatar(
            // Use appropriate avatar for the receiver
            backgroundImage: NetworkImage(
              'http://192.168.56.1/' + widget.profilePicture,
            ),
            radius: 16, // Adjust the radius as needed
          ),
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
                    topLeft: Radius.circular(12.0),
                    topRight: Radius.circular(12.0),
                    bottomLeft: isCurrentUser
                        ? Radius.circular(12.0)
                        : Radius.circular(0),
                    bottomRight: isCurrentUser
                        ? Radius.circular(0)
                        : Radius.circular(12.0),
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
