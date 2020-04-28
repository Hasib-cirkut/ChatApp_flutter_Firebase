import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _auth = FirebaseAuth.instance;
  final _fireStore = Firestore.instance;
  FirebaseUser loggedInUser;

  final messageTextController = TextEditingController();

  String message = '';

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser();

      if (user != null) {
        loggedInUser = user;
        print(loggedInUser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  void sendMessage() {
    _fireStore
        .collection('messages')
        .add({'text': message, 'sender': loggedInUser.email});

    messageTextController.clear();
  }

  //Subscribe and listen to messageStream
  void messagesStream() async {
    await for (var snapshot in _fireStore.collection('messages').snapshots()) {
      for (var messageBody in snapshot.documents) {
        print(messageBody.data);
      }
    }
  }

  @override
  void initState() {
    super.initState();

    getCurrentUser();
    //messagesStream();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Chats'),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.lightBlue[200],
        elevation: 2,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0).copyWith(right: 18),
            child: IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                _auth.signOut();

                Navigator.pop(context);
              },
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Container(
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 6,
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        child: TextField(
                          controller: messageTextController,
                          onChanged: (value) {
                            message = value;
                          },
                          decoration: InputDecoration(
                            icon: Icon(
                              Icons.chat,
                              color: Colors.black45,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        child: IconButton(
                          icon: Icon(
                            Icons.send,
                            color: Colors.black87,
                          ),
                          onPressed: () {
                            sendMessage();
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 7,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    StreamBuilder<QuerySnapshot>(
                      stream: _fireStore.collection('messages').snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          print('data loading');
                        }
                        final messages = snapshot.data.documents.reversed;
                        List<MessageBuble> messageWidget = [];

                        for (var message in messages) {
                          final messageText = message.data['text'];
                          final messageSender = message.data['sender'];

                          messageWidget.add(
                            MessageBuble(
                              sender: messageSender,
                              text: messageText,
                              isMe: loggedInUser.email == messageSender,
                            ),
                          );
                        }

                        return Expanded(
                          child: ListView(
                            reverse: true,
                            children: messageWidget,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MessageBuble extends StatelessWidget {
  MessageBuble(
      {@required this.sender, @required this.text, @required this.isMe});

  final String sender;
  final String text;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Material(
        child: Column(
          crossAxisAlignment:
              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              '$sender',
              style:
                  TextStyle(fontWeight: FontWeight.w400, color: Colors.black45),
            ),
            SizedBox(
              height: 4,
            ),
            Material(
              color: isMe ? Colors.lightBlue[200] : Colors.teal[400],
              borderRadius: isMe
                  ? BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      topLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    )
                  : BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
              elevation: 1,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Text(
                  '$text',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.black),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
