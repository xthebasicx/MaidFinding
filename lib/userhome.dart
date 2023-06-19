import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:project/cleaning.dart';
import 'package:project/wash.dart';

class userhome extends StatefulWidget {
  const userhome({super.key});

  @override
  State<userhome> createState() => _userhomeState();
}

class _userhomeState extends State<userhome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 7, 172, 134),
        toolbarHeight: 150,
        title: Center(
            child: Text(
          "MF.User Select Services",
          style: TextStyle(
            fontSize: 30,
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        )),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Container(
            height: 100,
            padding: EdgeInsets.all(8.0),
            margin: EdgeInsets.symmetric(horizontal: 8.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: Color.fromARGB(255, 108, 129, 240),
            ),
            child: Row(
              children: [
                Image.asset("images/house.png"),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                  child: Text(
                    "Cleaning House",
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 25,
                        color: Colors.white),
                  ),
                ),
                IconButton(
                  onPressed: (() {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => cleaning(),
                      ),
                    );
                  }),
                  icon: Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            height: 100,
            padding: EdgeInsets.all(8.0),
            margin: EdgeInsets.symmetric(horizontal: 8.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: Color.fromARGB(255, 84, 133, 190),
            ),
            child: Row(
              children: [
                Image.asset("images/washing-machine.png"),
                Padding(
                  padding: const EdgeInsets.fromLTRB(50, 0, 40, 0),
                  child: Text(
                    "Washing",
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 25,
                        color: Colors.white),
                  ),
                ),
                IconButton(
                  onPressed: (() {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => wash(),
                      ),
                    );
                  }),
                  icon: Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
