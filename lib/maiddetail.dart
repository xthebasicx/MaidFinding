import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:project/maidselect.dart';
import 'package:project/user_role.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'chatlll.dart';

class maiddetail extends StatefulWidget {
  final Map<String, dynamic> lalong;
  final Map<String, dynamic> data;
  final String roomId;
  String bathroom;
  String bedroom;
  String livingroom;
  String note;
  DateTime dateTime;
  String service;

  maiddetail({
    required this.lalong,
    required this.data,
    required this.roomId,
    required this.bathroom,
    required this.bedroom,
    required this.livingroom,
    required this.note,
    required this.dateTime,
    required this.service,
  });

  @override
  State<maiddetail> createState() => _maiddetailState(
        service: service,
        data: data,
        roomId: roomId,
        bathroom: bathroom,
        bedroom: bedroom,
        livingroom: livingroom,
        note: note,
        dateTime: dateTime,
        lalong: lalong,
      );
}

class _maiddetailState extends State<maiddetail> {
  final Map<String, dynamic> lalong;
  final Map<String, dynamic> data;
  final String roomId;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  String bathroom;
  String bedroom;
  String livingroom;
  String note;
  DateTime dateTime;
  String service;
  _maiddetailState({
    required this.lalong,
    required this.data,
    required this.roomId,
    required this.bathroom,
    required this.bedroom,
    required this.livingroom,
    required this.note,
    required this.dateTime,
    required this.service,
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 7, 172, 134),
        toolbarHeight: 100,
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => maidselect(
                    service: service,
                    lalong: lalong,
                    bathroom: bathroom,
                    bedroom: bedroom,
                    livingroom: livingroom,
                    note: note,
                    dateTime: dateTime),
              ),
            );
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              SizedBox(
                height: 50,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 50,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Email:  ${data['email']}",
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Name:  ${data['name']}",
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Phone:  ${data['phone']}",
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Address:  ${data['address']}",
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 100,
                      ),
                      MaterialButton(
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0))),
                          elevation: 5.0,
                          height: 40,
                          onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      chatlll(RoomId: data['uid']),
                                ),
                              ),
                          child: Text(
                            "view Profile",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                          color: Colors.green),
                    ],
                  ),
                ),
              ),
            ],
          ),
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
            Map<String, dynamic> userdata =
                snapshot.data!.data() as Map<String, dynamic>;
            return Container(
              color: Color.fromARGB(255, 7, 172, 134),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(120, 10, 120, 10),
                child: MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0))),
                  elevation: 5.0,
                  height: 40,
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => user_role(),
                      ),
                    );
                    print(userdata);
                    match(data, roomId, userdata, bathroom, bedroom, livingroom,
                        note, dateTime.toString());
                    jobdetail(
                      data,
                      bathroom,
                      bedroom,
                      livingroom,
                      note,
                      dateTime.toString(),
                    );
                  },
                  child: Text(
                    "Accept",
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

  void match(
    data,
    roomId,
    Map<String, dynamic> userdata,
    String bathroom,
    String bedroom,
    String livgroom,
    String note,
    String dateTime,
  ) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    final FirebaseAuth _auth = FirebaseAuth.instance;
    Map<String, dynamic> x = {
      "uidmaid": data['uid'],
      "roomid": roomId,
    };
    Map<String, dynamic> y = {
      "uiduser": _auth.currentUser!.uid,
      "roomid": roomId,
    };
    Map<String, dynamic> z = {
      "uidmaid": data['uid'],
      "mname": data['name'],
      "memail": data['email'],
      "mphone": data['phone'],
      "mrole": data['role'],
      "uiduser": _auth.currentUser!.uid,
      "uname": userdata['name'],
      "uemail": userdata['email'],
      "urole": userdata['role'],
      "uphone": userdata['phone'],
      "uaddress": userdata['address'],
      "bedroom": bedroom,
      "bathroom": bathroom,
      "livingroom": livgroom,
      "note": note,
      "date": dateTime,
      "service": service,
    };
    db.collection("users").doc(_auth.currentUser!.uid).update(x);
    db.collection("users").doc(data['uid']).update(y);
    await db.collection('match').doc(roomId).collection('detail').add(z);
  }

  void jobdetail(
    data,
    String bathroom,
    String bedroom,
    String livgroom,
    String note,
    String dateTime,
  ) {
    final _auth = FirebaseAuth.instance;
    FirebaseFirestore db = FirebaseFirestore.instance;
    var user = _auth.currentUser;

    final input = {
      "mname": data['name'],
      "memail": data['email'],
      "mphone": data['phone'],
      "bedroom": bedroom,
      "bathroom": bathroom,
      "livingroom": livgroom,
      "note": note,
      "date": dateTime,
      "service": service,
    };

    db.collection("users").doc(user!.uid).collection("jobdetails").add(input);
  }
}
