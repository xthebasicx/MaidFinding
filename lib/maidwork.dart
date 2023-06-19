import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project/maid_role.dart';
import 'auser.dart';
import 'login.dart';

class maidwork extends StatefulWidget {
  final Map<String, dynamic> roomid;
  maidwork({
    required this.roomid,
  });

  @override
  State<maidwork> createState() => _maidworkState(roomid: roomid);
}

class _maidworkState extends State<maidwork> {
  final Map<String, dynamic> roomid;
  _maidworkState({
    required this.roomid,
  });
  int counter = 0;
  String y = 'Accept Job';
  void x() {
    if (counter == 0) {
      y = 'Arrive';
      FirebaseFirestore.instance
          .collection("users")
          .doc(roomid['uiduser'])
          .update({"s": y});
      counter++;
    } else if (counter == 1) {
      y = 'Working';
      FirebaseFirestore.instance
          .collection("users")
          .doc(roomid['uiduser'])
          .update({"s": y});
      counter++;
    } else if (counter == 2) {
      y = 'Finish job';
      counter = 2;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    final _auth = FirebaseAuth.instance;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 131, 92, 240),
        toolbarHeight: 100,
        title: Center(
          child: Text(
            "Status",
            style: TextStyle(
              fontSize: 30,
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
      body: Center(
        child: Container(
          child: Column(
            children: [
              SizedBox(
                height: 100,
              ),
              Container(
                height: 80,
                width: 150,
                padding: EdgeInsets.all(8.0),
                margin: EdgeInsets.symmetric(horizontal: 8.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: Color.fromARGB(255, 255, 184, 0),
                ),
                child: Center(
                  child: Text(
                    '$y',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 25,
                        color: Colors.black),
                  ),
                ),
              ),
              SizedBox(
                height: 100,
              ),
              FutureBuilder<DocumentSnapshot>(
                future: users.doc(_auth.currentUser!.uid).get(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text("Something went wrong");
                  }

                  if (snapshot.hasData && !snapshot.data!.exists) {
                    return Text("Document does not exist");
                  }

                  if (snapshot.connectionState == ConnectionState.done) {
                    Map<String, dynamic> data =
                        snapshot.data!.data() as Map<String, dynamic>;
                    return MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(20.0))),
                      elevation: 5.0,
                      height: 40,
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => auser(
                              user: data['uid'],
                              maid: data['uiduser'],
                              roomid: data['roomid'],
                            ),
                          ),
                        );
                      },
                      child: Text(
                        "View details",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                      color: Color.fromARGB(255, 131, 92, 240),
                    );
                  }
                  return Container();
                },
              ),
              SizedBox(
                height: 10,
              ),
              MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0))),
                elevation: 5.0,
                height: 40,
                onPressed: () {
                  Future.delayed(Duration(seconds: 2), (() {
                    if (y == 'Arrive') {
                      Future.delayed(Duration(seconds: 3), () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Notification'),
                              content: Text("Don't forget to update status"),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text('Yes')),
                              ],
                            );
                          },
                        );
                      });
                    }
                  }));
                  Future.delayed(Duration(seconds: 2), (() {
                    if (y == 'Working') {
                      Future.delayed(Duration(seconds: 3), () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Notification'),
                              content: Text("Don't forget to update status"),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text('Yes')),
                              ],
                            );
                          },
                        );
                      });
                    }
                  }));
                  x();
                  if (y == 'Finish job') {
                    showDialog(
                      context: context,
                      builder: ((context) => AlertDialog(
                            title: Text('Alert'),
                            content: Text('Did you complete the task?'),
                            actions: [
                              TextButton(
                                  onPressed: () async {
                                    var db = FirebaseFirestore.instance;
                                    db
                                        .collection("users")
                                        .doc(_auth.currentUser!.uid)
                                        .update({"status": '0'});
                                    FirebaseFirestore.instance
                                        .collection("users")
                                        .doc(roomid['uiduser'])
                                        .update({"s": y});
                                    Navigator.pop(context);
                                    await Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => maid_role(),
                                      ),
                                    );
                                  },
                                  child: Text('Yes')),
                              TextButton(
                                  onPressed: () {
                                    y = 'Finish job';
                                    Navigator.pop(context);
                                  },
                                  child: Text('No')),
                            ],
                          )),
                    );
                  }
                },
                child: Text(
                  "Updates",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
                color: Color.fromARGB(255, 131, 92, 240),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 50,
        color: Color.fromARGB(255, 131, 92, 240),
      ),
    );
  }

  Future<void> logout(BuildContext context) async {
    CircularProgressIndicator();
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => login(),
      ),
    );
  }
}
