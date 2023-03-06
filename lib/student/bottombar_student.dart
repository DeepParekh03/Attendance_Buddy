import 'package:flutter/material.dart';
import 'package:image_firebase/student/dashboard_student.dart';
import 'package:image_firebase/student/teams.dart';
import 'package:image_firebase/student/profile.dart';

class BottomBarStudent extends StatefulWidget {
  const BottomBarStudent({Key? key}) : super(key: key);

  @override
  State<BottomBarStudent> createState() => _BottomBarStudentState();
}

class _BottomBarStudentState extends State<BottomBarStudent> {
  int _selectedIndex = 0;
  final List<Widget> _children = [
    DashboardScreenStudent(),
    ViewTeams(),
    Profile(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: Colors.red,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Teams',
            backgroundColor: Colors.green,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
            backgroundColor: Colors.purple,
          ),
        ],
      ),
    );
  }
}
