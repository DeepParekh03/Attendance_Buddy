// ignore_for_file: avoid_print, prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_local_variable, avoid_function_literals_in_foreach_calls, non_constant_identifier_names, avoid_unnecessary_containers

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_firebase/DatabaseManager/DatabaseManager.dart';
import 'package:image_firebase/ServiceManager/AuthenticationService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_firebase/admin/colors.dart';
import 'package:image_firebase/student/StudentBarChart.dart';

class StudentAttendanceCharts extends StatefulWidget {
  const StudentAttendanceCharts({Key? key}) : super(key: key);

  @override
  State<StudentAttendanceCharts> createState() =>
      _StudentAttendanceChartsState();
}

class _StudentAttendanceChartsState extends State<StudentAttendanceCharts> {
  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(minutes: 1, seconds: 4), () {
      print("Executed after 1 minute 4 seconds");
    });

    List studentdataList = [];

    final arg = ModalRoute.of(context)!.settings.arguments as List;
    studentdataList = arg;

    print(studentdataList);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Student Attendance Table",
      home: Scaffold(
        appBar: AppBar(
          title: Text('Student Table View'),
          backgroundColor: ColorsUsed.appBarColor,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Column(
              children: [
                Container(
                  child: DataTable(
                    border:
                        TableBorder.all(color: ColorsUsed.uiColor, width: 1),
                    columns: [
                      DataColumn(label: Text('Team Code(Subject)')),
                      DataColumn(label: Text('Present')),
                      DataColumn(label: Text('Absent')),
                      DataColumn(label: Text('Total')),
                      DataColumn(label: Text('Percentage'))
                    ],
                    rows: [
                      for (var cols in studentdataList)
                        DataRow(cells: [
                          DataCell(Text(cols['code'].toString())),
                          DataCell(Text(cols['Present'].toString())),
                          DataCell(Text(cols['Absent'].toString())),
                          DataCell(Text(cols['Total'].toString())),
                          DataCell(Text(cols['Percentage'].toString())),
                        ])
                    ],
                  ),
                ),
                SizedBox(height: 50),
                Padding(
                  padding: const EdgeInsets.only(right: 200),
                  child: Center(
                    child: ElevatedButton(
                      style:
                          ElevatedButton.styleFrom(primary: ColorsUsed.uiColor),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => StudentBar(),
                                settings:
                                    RouteSettings(arguments: studentdataList)));
                      },
                      child: Text(
                        'Graph View',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
