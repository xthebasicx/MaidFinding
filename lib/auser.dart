import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'ChatRoom.dart';
import 'ChatRoommaid.dart';

class auser extends StatefulWidget {
  final String user;
  final String maid;
  final String roomid;
  auser({required this.user, required this.maid, required this.roomid});

  @override
  State<auser> createState() =>
      _auserState(user: user, maid: maid, roomid: roomid);
}

class _auserState extends State<auser> {
  final String user;
  final String maid;
  final String roomid;
  _auserState({required this.user, required this.maid, required this.roomid});
  @override
  Widget build(BuildContext context) {
    final _auth = FirebaseAuth.instance;
    final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
        .collection('match')
        .doc(roomid)
        .collection('detail')
        .snapshots();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 131, 92, 240),
        toolbarHeight: 100,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _usersStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Text('Job Details', style: TextStyle(fontSize: 30)),
                    SizedBox(
                      height: 50,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Services:  ${data['service']}",
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Number of Services:  ${data['bedroom']},${data['bathroom']},${data['livingroom']}",
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Date:  ${data['date']}",
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Note:  ${data['note']}",
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "User Email:  ${data['uemail']}",
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "User Name:  ${data['uname']}",
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "User Phone:  ${data['uphone']}",
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }).toList(),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: MaterialButton(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          elevation: 5.0,
          height: 40,
          onPressed: () {
            print(maid);
            print(user);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatRoommaid(
                  chatRoomId: roomid,
                  userMap: user,
                ),
              ),
            );
          },
          child: Text(
            "Chat",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
          color: Color.fromARGB(255, 131, 92, 240),
        ),
      ),
    );
  }
}
