import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project/amaiddetail.dart';
import 'package:project/endjob.dart';

class status extends StatefulWidget {
  const status({super.key});

  @override
  State<status> createState() => _statusState();
}

class _statusState extends State<status> {
  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    final _auth = FirebaseAuth.instance;
    final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
        .collection('users')
        .where("uid", isEqualTo: _auth.currentUser!.uid)
        .snapshots();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 7, 172, 134),
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
              FirebaseFirestore.instance
                  .collection('users')
                  .doc(_auth.currentUser!.uid)
                  .get()
                  .then((DocumentSnapshot documentSnapshot) {
                if (documentSnapshot.exists) {
                  if (documentSnapshot.get('s') == "Finish job") {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => endjob(
                          data: data,
                        ),
                      ),
                    );
                  }
                }
              });
              return Column(
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
                      //color: Color.fromARGB(255, 255, 184, 0),
                    ),
                    child: Center(
                      child: Text(
                        data['s'],
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 25,
                            color: Colors.black),
                      ),
                    ),
                  ),
                ],
              );
            }).toList(),
          );
        },
      ),
      bottomNavigationBar: Container(
        height: 200,
        child: FutureBuilder<DocumentSnapshot>(
          future: users.doc(_auth.currentUser!.uid).get(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              Map<String, dynamic> data =
                  snapshot.data!.data() as Map<String, dynamic>;
              return Center(
                child: MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0))),
                  elevation: 5.0,
                  height: 40,
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => amaiddetail(
                          user: data['uid'],
                          maid: data['uidmaid'],
                          roomid: data['roomid'],
                        ),
                      ),
                    );
                  },
                  child: Text(
                    "Maid Detail",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  color: Color.fromARGB(255, 7, 172, 134),
                ),
              );
            }
            return Text("loading");
          },
        ),
      ),
    );
  }
}
