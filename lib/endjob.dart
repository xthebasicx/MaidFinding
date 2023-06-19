import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project/user_role.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class endjob extends StatefulWidget {
  final Map<String, dynamic> data;
  endjob({required this.data});

  @override
  State<endjob> createState() => _endjobState(data: data);
}

class _endjobState extends State<endjob> {
  final Map<String, dynamic> data;
  _endjobState({required this.data});
  double rating = 0;
  double average = 0;

  @override
  Widget build(BuildContext context) {
    final _auth = FirebaseAuth.instance;
    final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
        .collection('match')
        .doc(data['roomid'])
        .collection('detail')
        .snapshots();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 7, 172, 134),
        toolbarHeight: 100,
      ),
      body: Container(
        child: StreamBuilder<QuerySnapshot>(
          stream: _usersStream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
                            "Maid Email:  ${data['memail']}",
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
                            "Maid Name:  ${data['mname']}",
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
                            "Maid Phone:  ${data['mphone']}",
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 60,
                      ),
                    ],
                  ),
                );
              }).toList(),
            );
          },
        ),
      ),
      bottomNavigationBar: Container(
        color: Color.fromARGB(255, 7, 172, 134),
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
            onPressed: () async {
              showDialog(
                context: context,
                builder: ((context) => AlertDialog(
                      title: Text('Rate the maid'),
                      content: RatingBar.builder(
                        initialRating: 0,
                        minRating: 0,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemPadding: EdgeInsets.symmetric(horizontal: 3.0),
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (rating) {
                          print(rating);
                          setState(() {
                            this.rating = rating;
                          });
                        },
                      ),
                      actions: [
                        TextButton(
                            onPressed: () async {
                              await FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(data['uidmaid'])
                                  .update({
                                'score': FieldValue.arrayUnion([rating])
                              });
                              Future<List<dynamic>> getArrayData() async {
                                DocumentSnapshot snapshot =
                                    await FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(data['uidmaid'])
                                        .get();

                                if (snapshot.exists) {
                                  Map<String, dynamic> data =
                                      snapshot.data() as Map<String, dynamic>;
                                  List<dynamic> arrayData = data['score'];
                                  return arrayData;
                                } else {
                                  return [];
                                }
                              }

                              double calculateAverage(List<dynamic> arrayData) {
                                double sum = 0;
                                int count = arrayData.length;

                                for (dynamic data in arrayData) {
                                  sum += data;
                                }

                                double average = sum / count;
                                return average;
                              }

                              List<dynamic> arrayData = await getArrayData();

                              if (arrayData.isNotEmpty) {
                                double average = calculateAverage(arrayData);
                                print('ค่าเฉลี่ย: $average');
                                setState(() {
                                  this.average = average;
                                });
                              } else {
                                print('ไม่มีข้อมูลในอาร์เรย์');
                              }

                              await FirebaseFirestore.instance
                                  .collection("users")
                                  .doc(data['uidmaid'])
                                  .update({
                                "average": average,
                              });

                              /*await FirebaseFirestore.instance
                                  .collection('chatroom')
                                  .doc(data['roomid'])
                                  .collection('chats')
                                  .where('type', isEqualTo: 'text')
                                  .get()
                                  .then((querySnapshot) {
                                querySnapshot.docs.forEach((doc) {
                                  doc.reference.delete();
                                });
                              });*/
                              await FirebaseFirestore.instance
                                  .collection('match')
                                  .doc(data['roomid'])
                                  .collection('detail')
                                  .where('mrole', isEqualTo: 'Maid')
                                  .get()
                                  .then((querySnapshot) {
                                querySnapshot.docs.forEach((doc) {
                                  doc.reference.delete();
                                });
                              });
                              await FirebaseFirestore.instance
                                  .collection("users")
                                  .doc(_auth.currentUser!.uid)
                                  .update({
                                "s": "",
                              });
                              Navigator.pop(context);
                              await Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => user_role(),
                                ),
                              );
                            },
                            child: Text('Yes')),
                      ],
                    )),
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
      ),
    );
  }
}
