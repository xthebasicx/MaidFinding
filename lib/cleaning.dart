import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project/acleaning.dart';
import 'package:project/user_role.dart';

class cleaning extends StatefulWidget {
  const cleaning({super.key});

  @override
  State<cleaning> createState() => _cleaningState();
}

class _cleaningState extends State<cleaning> {
  DateTime dateTime = DateTime.now();
  DocumentReference<Map<String, dynamic>>? test;
  @override
  Widget build(BuildContext context) {
    final TextEditingController bathroom = new TextEditingController();
    final TextEditingController bedroom = new TextEditingController();
    final TextEditingController livingroom = new TextEditingController();
    final TextEditingController note = new TextEditingController();
    final hours = dateTime.hour.toString().padLeft(2, '0');
    final minutes = dateTime.minute.toString().padLeft(2, '0');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 7, 172, 134),
        toolbarHeight: 100,
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => user_role(),
              ),
            );
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: Text('Enter the number of rooms'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("Date Time"),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: pickDateTime,
                      child: FittedBox(
                        child: Text(
                          '${dateTime.day}/${dateTime.month}/${dateTime.year} $hours:$minutes',
                          style: TextStyle(
                              fontWeight: FontWeight.w400, color: Colors.black),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                          minimumSize: Size.fromHeight(40),
                          backgroundColor: Colors.white,
                          shadowColor: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
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
                          Image.asset("images/beds.png"),
                          Container(
                            height: 40,
                            width: 30,
                            child: Material(
                              elevation: 2,
                              shadowColor: Colors.black,
                              child: TextField(
                                controller: bedroom,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  enabled: true,
                                  contentPadding: const EdgeInsets.only(
                                      left: 14.0, bottom: 8.0, top: 8.0),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        new BorderSide(color: Colors.white),
                                    borderRadius: new BorderRadius.circular(10),
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        new BorderSide(color: Colors.white),
                                    borderRadius: new BorderRadius.circular(10),
                                  ),
                                ),
                                keyboardType: TextInputType.number,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text("Bed room")
                        ],
                      ),
                    ),
                    Container(
                      width: 90,
                      child: Column(
                        children: [
                          Image.asset("images/bathtub.png"),
                          Container(
                            height: 40,
                            width: 30,
                            child: Material(
                              elevation: 2,
                              shadowColor: Colors.black,
                              child: TextField(
                                controller: bathroom,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  enabled: true,
                                  contentPadding: const EdgeInsets.only(
                                      left: 14.0, bottom: 8.0, top: 8.0),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        new BorderSide(color: Colors.white),
                                    borderRadius: new BorderRadius.circular(10),
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        new BorderSide(color: Colors.white),
                                    borderRadius: new BorderRadius.circular(10),
                                  ),
                                ),
                                keyboardType: TextInputType.number,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text("Shower room")
                        ],
                      ),
                    ),
                    Container(
                      width: 90,
                      child: Column(
                        children: [
                          Image.asset("images/room.png"),
                          Container(
                            height: 40,
                            width: 30,
                            child: Material(
                              elevation: 2,
                              shadowColor: Colors.black,
                              child: TextField(
                                controller: livingroom,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  enabled: true,
                                  contentPadding: const EdgeInsets.only(
                                      left: 14.0, bottom: 8.0, top: 8.0),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        new BorderSide(color: Colors.white),
                                    borderRadius: new BorderRadius.circular(10),
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        new BorderSide(color: Colors.white),
                                    borderRadius: new BorderRadius.circular(10),
                                  ),
                                ),
                                keyboardType: TextInputType.number,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text("Living room")
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
                        Text("Note"),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Material(
                      elevation: 2,
                      shadowColor: Colors.black,
                      child: TextFormField(
                        controller: note,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          enabled: true,
                          contentPadding: const EdgeInsets.only(
                              left: 14.0, bottom: 8.0, top: 8.0),
                          focusedBorder: OutlineInputBorder(
                            borderSide: new BorderSide(color: Colors.white),
                            borderRadius: new BorderRadius.circular(10),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: new BorderSide(color: Colors.white),
                            borderRadius: new BorderRadius.circular(10),
                          ),
                        ),
                      ),
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
      bottomNavigationBar: Container(
        color: Color.fromARGB(255, 7, 172, 134),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(120, 10, 120, 10),
          child: MaterialButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            elevation: 5.0,
            height: 40,
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                    builder: (context) => acleaning(
                        bathroom: bathroom.text,
                        bedroom: bedroom.text,
                        livingroom: livingroom.text,
                        note: note.text,
                        dateTime: dateTime)),
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

  Future pickDateTime() async {
    DateTime? date = await pickDate();
    if (date == null) return;
    TimeOfDay? time = await pickTime();
    if (time == null) return;

    final dateTime = DateTime(
      date.day,
      date.month,
      date.year,
      time.hour,
      time.minute,
    );
    setState(() => this.dateTime = dateTime);
  }

  Future<DateTime?> pickDate() => showDatePicker(
      context: context,
      initialDate: dateTime,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100));

  Future<TimeOfDay?> pickTime() => showTimePicker(
        context: context,
        initialTime: TimeOfDay(hour: dateTime.hour, minute: dateTime.minute),
      );
}
