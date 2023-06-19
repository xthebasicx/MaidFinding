import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class rate extends StatefulWidget {
  const rate({super.key});

  @override
  State<rate> createState() => _rateState();
}

class _rateState extends State<rate> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 7, 172, 134),
        toolbarHeight: 100,
        title: Center(
          child: Text(
            "Rate",
            style: TextStyle(
              fontSize: 30,
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Text("Cleaning",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600)),
            SizedBox(
              height: 10,
            ),
            Container(
              color: Color.fromARGB(192, 99, 247, 222),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Cleaning Start",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w500),
                        ),
                        Text("500./PT.",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500)),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Bedroom",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500)),
                        Text("100/.room",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500)),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Bathroom",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500)),
                        Text("100/.room",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500)),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Livingroom",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500)),
                        Text("100/.room",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500)),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Text("Washing",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600)),
            SizedBox(
              height: 10,
            ),
            Container(
              color: Color.fromARGB(192, 247, 105, 124),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Washing Start",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w500),
                        ),
                        Text("100./PT.",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500)),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Washing",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500)),
                        Text("150./PT.",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500)),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Folding",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500)),
                        Text("50./PT.",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500)),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Ironing",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500)),
                        Text("100./PT",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500)),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
