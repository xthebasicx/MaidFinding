import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:project/cleaning.dart';
import 'package:project/maiddetail.dart';
import 'package:geolocator/geolocator.dart';
import 'package:units_converter/units_converter.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class maidselect extends StatefulWidget {
  final Map<String, dynamic> lalong;
  String service;
  String bathroom;
  String bedroom;
  String livingroom;
  String note;
  DateTime dateTime;
  maidselect(
      {required this.service,
      required this.lalong,
      required this.bathroom,
      required this.bedroom,
      required this.livingroom,
      required this.note,
      required this.dateTime});

  @override
  State<maidselect> createState() => _maidselectState(
      service: service,
      lalong: lalong,
      bathroom: bathroom,
      bedroom: bedroom,
      livingroom: livingroom,
      note: note,
      dateTime: dateTime);
}

class _maidselectState extends State<maidselect> {
  final Map<String, dynamic> lalong;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final firestoreInstance = FirebaseFirestore.instance;
  String service;
  String bathroom;
  String bedroom;
  String livingroom;
  String note;
  DateTime dateTime;
  _maidselectState(
      {required this.service,
      required this.lalong,
      required this.bathroom,
      required this.bedroom,
      required this.livingroom,
      required this.note,
      required this.dateTime});
  double average = 0;
  @override
  String matchId(String user1, String user2) {
    if (user1[0].toLowerCase().codeUnits[0] >
        user2.toLowerCase().codeUnits[0]) {
      return "$user1$user2";
    } else {
      return "$user2$user1";
    }
  }

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
        .collection('users')
        .where("role", isEqualTo: "Maid")
        .where('local', isEqualTo: 'true')
        .where('status', isEqualTo: '1')
        .snapshots();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 7, 172, 134),
        toolbarHeight: 100,
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => cleaning(),
              ),
            );
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: Text('Select Maid'),
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
              double userla = lalong['la'];
              double userlong = lalong['long'];
              double distance = Geolocator.distanceBetween(
                userla,
                userlong,
                data['la'],
                data['long'],
              );

              return Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    color: Colors.green[100],
                    child: ListTile(
                      title: Text(data['name']),
                      subtitle: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Rating ${data['average'].toStringAsFixed(1)}'),
                          Text(
                              '${distance.convertFromTo(LENGTH.meters, LENGTH.kilometers)!.toStringAsFixed(2)} KM'),
                        ],
                      ),
                      onTap: () {
                        print(data);
                        String roomId =
                            matchId(_auth.currentUser!.uid, data['uid']);
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => maiddetail(
                                bathroom: bathroom,
                                bedroom: bedroom,
                                livingroom: livingroom,
                                note: note,
                                dateTime: dateTime,
                                roomId: roomId,
                                data: data,
                                service: service,
                                lalong: lalong),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
