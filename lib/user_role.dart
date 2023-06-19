import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:project/history.dart';
import 'package:project/model/UserModel.dart';
import 'package:project/profile.dart';
import 'package:project/rate.dart';
import 'package:project/status.dart';
import 'package:project/userhome.dart';

class user_role extends StatefulWidget {
  const user_role({super.key});

  @override
  State<user_role> createState() => _user_roleState();
}

class _user_roleState extends State<user_role> {
  int currentIndex = 0;
  static const List body = [
    userhome(),
    rate(),
    status(),
    history(),
    profile(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body.elementAt(currentIndex),
      bottomNavigationBar: NavigationBar(
        destinations: [
          NavigationDestination(icon: Icon(Icons.home), label: 'home'),
          NavigationDestination(icon: Icon(Icons.checklist), label: 'rate'),
          NavigationDestination(icon: Icon(Icons.assignment), label: 'status'),
          NavigationDestination(
              icon: Icon(Icons.notifications_active), label: 'notification'),
          NavigationDestination(icon: Icon(Icons.person), label: 'person'),
        ],
        selectedIndex: currentIndex,
        onDestinationSelected: ((int index) {
          setState(() {
            currentIndex = index;
          });
        }),
      ),
    );
  }
}
