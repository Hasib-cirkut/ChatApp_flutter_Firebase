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
    _fireStore.collection('messages').add({
      'text': message,
      'sender': loggedInUser.email,
      'timestamp': DateTime.now().toUtc().millisecondsSinceEpoch
    });

    messageTextController.clear();
  }

  @override
  void initState() {
    super.initState();

    getCurrentUser();
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
                flex: 7,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    StreamBuilder<QuerySnapshot>(
                      stream: _fireStore
                          .collection('messages')
                          .orderBy('timestamp', descending: true)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(child: CircularProgressIndicator());
                        } else {
                          var listMessage = snapshot.data.documents;
                          return Expanded(
                            child: ListView.builder(
                              shrinkWrap: true,
                              padding: EdgeInsets.all(10.0),
                              itemBuilder: (context, index) => MessageBuble(
                                sender: listMessage[index]['sender'],
                                text: listMessage[index]['text'],
                                isMe: loggedInUser.email ==
                                    listMessage[index]['sender'],
                              ),
                              itemCount: listMessage.length,
                              reverse: true,
                            ),
                          );
                        }
                      },
                      // builder: (context, snapshot) {
                      //   if (!snapshot.hasData) {
                      //     return Center(child: CircularProgressIndicator());
                      //   }
                      //   final messages = snapshot.data.documents;
                      //   List<MessageBuble> messageWidget = [];

                      //   for (var message in messages) {
                      //     final messageText = message.data['text'];
                      //     final messageSender = message.data['sender'];

                      //     final messageBubble = MessageBuble(
                      //       sender: messageSender,
                      //       text: messageText,
                      //       isMe: loggedInUser.email == messageSender,
                      //     );

                      //     messageWidget.add(messageBubble);
                      //   }

                      //   return Expanded(
                      //     child: ListView(
                      //       children: messageWidget,
                      //     ),
                      //   );
                      // },
                    ),
                  ],
                ),
              ),
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
