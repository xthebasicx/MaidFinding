import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project/chatll.dart';
import 'package:project/share.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'chatlll.dart';

class ChatRoommaid extends StatefulWidget {
  final String userMap;
  final String chatRoomId;
  ChatRoommaid({required this.chatRoomId, required this.userMap});

  @override
  State<ChatRoommaid> createState() =>
      _ChatRoomState(userMap: userMap, chatRoomId: chatRoomId);
}

class _ChatRoomState extends State<ChatRoommaid> {
  final String userMap;
  final String chatRoomId;
  _ChatRoomState({required this.chatRoomId, required this.userMap});
  bool hasData = false;
  @override
  void initState() {
    super.initState();
    checkData();
  }

  Future<void> checkData() async {
    try {
      final ref = FirebaseStorage.instance.ref('/${widget.chatRoomId}/');
      final result = await ref.listAll();

      setState(() {
        hasData = result.items.isNotEmpty;
      });
    } catch (e) {
      print('Error checking data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController _message = TextEditingController();
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final size = MediaQuery.of(context).size;

    void onSendMessage() async {
      if (_message.text.isNotEmpty) {
        Map<String, dynamic> messages = {
          "sendby": _auth.currentUser!.uid,
          "message": _message.text,
          "type": "text",
          "time": FieldValue.serverTimestamp(),
        };

        _message.clear();
        await _firestore
            .collection('chatroom')
            .doc(chatRoomId)
            .collection('chats')
            .add(messages);
      } else {
        print("Enter Some Text");
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: StreamBuilder<DocumentSnapshot>(
          stream: _firestore.collection("users").doc(userMap).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.data != null) {
              return Container(
                child: Column(
                  children: [
                    Text(""),
                  ],
                ),
              );
            } else {
              return Container();
            }
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: size.height / 1.25,
              width: size.width,
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('chatroom')
                    .doc(chatRoomId)
                    .collection('chats')
                    .orderBy("time", descending: false)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.data != null) {
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> map = snapshot.data!.docs[index]
                            .data() as Map<String, dynamic>;
                        return messages(size, map, context);
                      },
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ),
            Container(
              height: size.height / 10,
              width: size.width,
              alignment: Alignment.center,
              child: Container(
                height: size.height / 12,
                width: size.width / 1.1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: size.height / 17,
                      width: size.width / 2,
                      child: TextField(
                        controller: _message,
                        decoration: InputDecoration(
                            suffixIcon: IconButton(
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      chatll(RoomId: chatRoomId),
                                ),
                              ),
                              icon: Icon(Icons.attachment),
                            ),
                            hintText: "Send Message",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            )),
                      ),
                    ),
                    IconButton(
                        icon: Icon(Icons.send), onPressed: onSendMessage),
                    IconButton(
                      icon: Icon(Icons.download),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => chatlll(RoomId: chatRoomId),
                        ),
                      ),
                      color: hasData ? Colors.red : Colors.black,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget messages(Size size, Map<String, dynamic> map, BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final size = MediaQuery.of(context).size;
    return map['type'] == "text"
        ? Container(
            width: size.width,
            alignment: map['sendby'] == _auth.currentUser!.uid
                ? Alignment.centerRight
                : Alignment.centerLeft,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 14),
              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.blue,
              ),
              child: Text(
                map['message'],
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          )
        : Container();
  }
}
