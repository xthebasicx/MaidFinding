import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:project/editprofile.dart';
import 'package:project/login.dart';
import 'package:project/maidwait.dart';
import 'package:project/profilez.dart';

import 'maideditprofile.dart';

class maid_role extends StatefulWidget {
  const maid_role({super.key});

  @override
  State<maid_role> createState() => _maid_roleState();
}

class _maid_roleState extends State<maid_role> {
  @override
  Widget build(BuildContext context) {
    final _auth = FirebaseAuth.instance;
    var user = _auth.currentUser;

    CollectionReference users = FirebaseFirestore.instance.collection('users');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 131, 92, 240),
        toolbarHeight: 100,
        title: Center(
            child: Text(
          "MF.Maid",
          style: TextStyle(
            fontSize: 30,
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        )),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              SizedBox(
                height: 40,
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: Form(
                  child: Column(
                    children: [
                      FutureBuilder<DocumentSnapshot>(
                        future: users.doc(user!.uid).get(),
                        builder: (BuildContext context,
                            AsyncSnapshot<DocumentSnapshot> snapshot) {
                          if (snapshot.hasError) {
                            return Text("Something went wrong");
                          }

                          if (snapshot.hasData && !snapshot.data!.exists) {
                            return Text("Document does not exist");
                          }

                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            Map<String, dynamic> data =
                                snapshot.data!.data() as Map<String, dynamic>;
                            return Column(
                              children: [
                                Container(
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Email:  ${data['email']}",
                                            style: TextStyle(fontSize: 20),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 20),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Name:  ${data['name']}",
                                            style: TextStyle(fontSize: 20),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 20),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Phone:  ${data['phone']}",
                                            style: TextStyle(fontSize: 20),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }

                          return Text("loading");
                        },
                      ),
                      SizedBox(height: 100),
                      MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0))),
                        elevation: 5.0,
                        height: 40,
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => profilez(RoomId: user!.uid),
                          ),
                        ),
                        child: Text(
                          "Add Profile",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                        color: Color.fromARGB(255, 131, 92, 240),
                      ),
                      MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0))),
                        elevation: 5.0,
                        height: 40,
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => maideditprofile(),
                            ),
                          );
                        },
                        child: Text(
                          "Edit Profile",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                        color: Color.fromARGB(255, 131, 92, 240),
                      ),
                      FutureBuilder<DocumentSnapshot>(
                        future: users.doc(user.uid).get(),
                        builder: (BuildContext context,
                            AsyncSnapshot<DocumentSnapshot> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            Map<String, dynamic> data =
                                snapshot.data!.data() as Map<String, dynamic>;
                            return MaterialButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0))),
                              elevation: 5.0,
                              height: 40,
                              onPressed: () {
                                var db = FirebaseFirestore.instance;
                                db
                                    .collection("users")
                                    .doc(user.uid)
                                    .update({"status": '1'});
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        maidwait(roomid: data),
                                  ),
                                );
                              },
                              child: Text(
                                "Find job",
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
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
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
              logout(context);
            },
            child: Text(
              "Logout",
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
