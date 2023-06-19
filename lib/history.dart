import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project/viewhistory.dart';

class history extends StatefulWidget {
  const history({super.key});

  @override
  State<history> createState() => _historyState();
}

class _historyState extends State<history> {
  @override
  Widget build(BuildContext context) {
    final _auth = FirebaseAuth.instance;
    var user = _auth.currentUser;
    final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection("jobdetails")
        .snapshots();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 7, 172, 134),
        toolbarHeight: 100,
        title: Center(
          child: Text(
            "History",
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
              return Column(
                children: [
                  SizedBox(height: 10),
                  Container(
                    height: 80,
                    color: Colors.grey,
                    child: ListTile(
                      title: Text(
                        data['service'],
                        style: TextStyle(fontSize: 20),
                      ),
                      onTap: () {
                        print(data);
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => viewhistory(data: data)),
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
