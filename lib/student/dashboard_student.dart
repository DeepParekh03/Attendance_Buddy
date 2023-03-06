import 'package:flutter/material.dart';
import 'package:image_firebase/admin/Email.dart';
import 'package:image_firebase/admin/colors.dart';
import 'package:image_firebase/student/AnalyticsStudent.dart';
import 'package:image_firebase/student/leaderboard_teams.dart';
import 'dart:ui' as ui;
import 'dart:io';
import 'package:image_firebase/student/teams.dart';
import 'package:image_firebase/student/joinTeam.dart';
import 'package:image_firebase/student/profile.dart';
import 'package:image_firebase/admin/createTeams.dart';
import 'package:image_firebase/student/upload_studentprofile.dart';

class DashboardScreenStudent extends StatefulWidget {
  const DashboardScreenStudent({Key? key}) : super(key: key);

  @override
  State<DashboardScreenStudent> createState() => _DashboardScreenStudentState();
}

class _DashboardScreenStudentState extends State<DashboardScreenStudent> {
  //DashBoard Items
  Card makeDashboardItem(String title, String img, int index) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      elevation: 2,
      margin: const EdgeInsets.all(8),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          gradient: const LinearGradient(
              begin: FractionalOffset(0.0, 0.0),
              end: FractionalOffset(3.0, -1.0),
              colors: [Color(0xff004880), Color(0xffffffff)]),
          boxShadow: const [
            BoxShadow(
              color: Colors.white,
              blurRadius: 2,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: InkWell(
          onTap: () {
            if (index == 0) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => JoinTeams()));
            }
            if (index == 1) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Teams_leaderboard()));
            }
            if (index == 2) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => StudentGraph()));
            }

            if (index == 3) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => EditInfoStudent()));
            }
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            verticalDirection: VerticalDirection.down,
            children: [
              const SizedBox(height: 50),
              Center(
                child: Image.asset(
                  img,
                  height: 50,
                  width: 50,
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Text(title,
                    style: const TextStyle(
                        fontSize: 19,
                        color: Colors.white,
                        fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsUsed.backgroundColor,
      appBar: AppBar(
        title: Text("Dashboard"),
        backgroundColor: ColorsUsed.appBarColor,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          // Padding(
          //   padding: const EdgeInsets.only(left: 16, right: 16),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: [
          //       Column(
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         children: const [
          //           Text(
          //             'DashBoard',
          //             style: TextStyle(
          //               fontSize: 20,
          //               fontWeight: FontWeight.bold,
          //             ),
          //           ),
          //           SizedBox(height: 4),
          //           Text(
          //             'Options:',
          //             style: TextStyle(
          //               fontSize: 18,
          //               fontWeight: FontWeight.bold,
          //             ),
          //           ),
          //         ],
          //       ),
          //     ],
          //   ),
          // ),
          const SizedBox(height: 100),
          Expanded(
              child: GridView.count(
            crossAxisCount: 2,
            padding: const EdgeInsets.all(2),
            children: [
              makeDashboardItem("Join Teams", "images/join.jpg", 0),
              makeDashboardItem(
                  "View Leaderboard", "images/leaderboard.png", 1),
              makeDashboardItem("Analytics", "images/analytics.png", 2),
              makeDashboardItem("Edit Info", "images/editinfo.jpg", 3),
            ],
          )),
        ],
      ),
    );
  }
}
