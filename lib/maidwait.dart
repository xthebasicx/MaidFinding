import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project/maid_role.dart';
import 'package:project/maidwork.dart';

class maidwait extends StatefulWidget {
  final Map<String, dynamic> roomid;
  maidwait({
    required this.roomid,
  });

  @override
  State<maidwait> createState() => _maidwaitState(roomid: roomid);
}

class _maidwaitState extends State<maidwait> {
  final Map<String, dynamic> roomid;
  _maidwaitState({
    required this.roomid,
  });
  @override
  Widget build(BuildContext context) {
    final _auth = FirebaseAuth.instance;
    Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
        .collection('match')
        .doc(roomid['roomid'])
        .collection('detail')
        .snapshots();
    FirebaseFirestore db = FirebaseFirestore.instance;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 131, 92, 240),
        toolbarHeight: 100,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _usersStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.docs.isNotEmpty) {
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
                              "Service:  ${data['service']}",
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
                              "Number of Service:  ${data['bedroom']},${data['bathroom']},${data['livingroom']}",
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
                              "Maid Email:  ${data['uemail']}",
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
                              "Maid Name:  ${data['uname']}",
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
                              "Maid Phone:  ${data['uphone']}",
                              style: TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 90,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              MaterialButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(20.0))),
                                elevation: 5.0,
                                height: 40,
                                onPressed: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          maidwork(roomid: roomid),
                                    ),
                                  );
                                },
                                child: Text(
                                  "Accept",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                ),
                                color: Color.fromARGB(255, 7, 172, 134),
                              ),
                              MaterialButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(20.0))),
                                elevation: 5.0,
                                height: 40,
                                onPressed: () {
                                  FirebaseFirestore.instance
                                      .collection('match')
                                      .doc(roomid['roomid'])
                                      .collection('detail')
                                      .where('mrole', isEqualTo: 'Maid')
                                      .get()
                                      .then((querySnapshot) {
                                    querySnapshot.docs.forEach((doc) {
                                      doc.reference.delete();
                                    });
                                  });
                                },
                                child: Text(
                                  "Denied",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                  ),
                                ),
                                color: Color.fromARGB(255, 255, 184, 0),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                }).toList(),
              );
            } else {
              return Center(
                  child: Text(
                'Finding Job...',
                style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.w500,
                ),
              ));
            }
          }
          return Container();
        },
      ),
      bottomNavigationBar: Container(
        color: Color.fromARGB(255, 131, 92, 240),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            120,
            10,
            120,
            10,
          ),
          child: MaterialButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            elevation: 5.0,
            height: 40,
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => maid_role(),
                ),
              );
              var db = FirebaseFirestore.instance;
              db
                  .collection("users")
                  .doc(_auth.currentUser!.uid)
                  .update({"status": '0'});
            },
            child: Text(
              "Cancel",
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
              ),
            ),
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
