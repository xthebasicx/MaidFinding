import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project/cleaning.dart';
import 'package:project/maidselect.dart';

class awash extends StatefulWidget {
  String bathroom;
  String bedroom;
  String livingroom;
  String note;
  DateTime dateTime;
  awash(
      {required this.bathroom,
      required this.bedroom,
      required this.livingroom,
      required this.note,
      required this.dateTime});

  @override
  State<awash> createState() => _awashState(
      bathroom: bathroom,
      bedroom: bedroom,
      livingroom: livingroom,
      note: note,
      dateTime: dateTime);
}

class _awashState extends State<awash> {
  String bathroom;
  String bedroom;
  String livingroom;
  String note;
  DateTime dateTime;
  _awashState(
      {required this.bathroom,
      required this.bedroom,
      required this.livingroom,
      required this.note,
      required this.dateTime});
  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    final _auth = FirebaseAuth.instance;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 7, 172, 134),
        toolbarHeight: 100,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 90,
                      child: Column(
                        children: [
                          Image.asset("images/washing-machine.png"),
                          Container(
                            width: 30,
                            child: Material(
                              elevation: 2,
                              shadowColor: Colors.black,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(bedroom),
                          SizedBox(
                            height: 10,
                          ),
                          Text("bed room")
                        ],
                      ),
                    ),
                    Container(
                      width: 90,
                      child: Column(
                        children: [
                          Image.asset("images/iron.png"),
                          Container(
                            width: 30,
                            child: Material(
                              elevation: 2,
                              shadowColor: Colors.black,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(bathroom),
                          SizedBox(
                            height: 10,
                          ),
                          Text("shower room")
                        ],
                      ),
                    ),
                    Container(
                      width: 90,
                      child: Column(
                        children: [
                          Image.asset("images/laundry.png"),
                          Container(
                            width: 30,
                            child: Material(
                              elevation: 2,
                              shadowColor: Colors.black,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(livingroom),
                          SizedBox(
                            height: 10,
                          ),
                          Text("living room")
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("Date Time        "),
                        Text(dateTime.toString()),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("Note                  "),
                        Text(note),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Material(
                      elevation: 2,
                      shadowColor: Colors.black,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
      bottomNavigationBar: FutureBuilder<DocumentSnapshot>(
        future: users.doc(_auth.currentUser!.uid).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong");
          }

          if (snapshot.hasData && !snapshot.data!.exists) {
            return Text("Document does not exist");
          }

          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            return Container(
              color: Color.fromARGB(255, 7, 172, 134),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(100, 10, 100, 10),
                child: MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0))),
                  elevation: 5.0,
                  height: 40,
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => maidselect(
                            lalong: data,
                            bathroom: bathroom,
                            bedroom: bedroom,
                            livingroom: livingroom,
                            note: note,
                            dateTime: dateTime,
                            service: "Wash"),
                      ),
                    );
                  },
                  child: Text(
                    "Find Maid",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                    ),
                  ),
                  color: Colors.white,
                ),
              ),
            );
          }
          return Text("loading");
        },
      ),
    );
  }
}
