// ignore_for_file: avoid_print, prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_local_variable, avoid_function_literals_in_foreach_calls, non_constant_identifier_names, prefer_typing_uninitialized_variables, deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_firebase/DatabaseManager/DatabaseManager.dart';
import 'package:image_firebase/ServiceManager/AuthenticationService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_firebase/admin/colors.dart';
import 'package:image_firebase/student/leaderboard_table_view.dart';

List data = [];
List attendanceData = [];
String sapNo = '';
List sapNoList = [];
List teamsListGraph = [];
List demo = [];
List finalList = [];
List sapValue = [];
List sapNoSet = [];
Future teamListData(teamCode, lectureType, context) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  CollectionReference allTeams =
      FirebaseFirestore.instance.collection('teamList');

  try {
    await allTeams.get().then((querySnapshot) {
      querySnapshot.docs.forEach((element) {
        teamsListGraph.add(element.data());
      });
    });
    print(teamsListGraph);
    for (int i = 0; i < teamsListGraph.length; i++) {
      if (teamsListGraph[i]['code'] == teamCode) {
        demo.add({
          'code': teamsListGraph[i]['code'].toString(),
          'subject': teamsListGraph[i]['subject'].toString(),
          'theoryHours': int.parse(teamsListGraph[i]['theory_hours']),
          'practicalHours': int.parse(teamsListGraph[i]['prac_hours'])
        });
      }
    }

    String code = demo[0]['code'];
    String subject = demo[0]['subject'];
    int theoryHours = demo[0]['theoryHours'];
    int practicalHours = demo[0]['practicalHours'];

    if (lectureType == 'theory_attendance') {
      for (int i = 1; i <= theoryHours; i++) {
        await allTeams
            .doc(demo[0]['code'])
            .collection(lectureType)
            .doc(i.toString())
            .collection('data')
            .get()
            .then((querySnapshot) {
          querySnapshot.docs.forEach((element) {
            attendanceData.add(element.data().toString());
          });
        });
      }

      String sap = '';
      int attendance = 0;
      for (int i = 0; i < attendanceData.length; i++) {
        sap = (attendanceData[i].toString().substring(1, 12));
        attendance = int.parse(attendanceData[i][14]);
        sapNoList.add(sap);
        sapValue.add({'sapID': sap, 'value': attendance});
      }

      int finalValue = 0;
      double percentage = 0.0;
      int percentageInt = 0;
      sapNoSet = sapNoList.toSet().toList();

      for (int i = 0; i < sapNoSet.length; i++) {
        finalValue = 0;
        for (int j = 0; j < sapValue.length; j++) {
          if (sapValue[j]['sapID'] == sapNoSet[i]) {
            finalValue = finalValue + sapValue[j]['value'] as int;
          }
        }
        percentage = (finalValue / theoryHours) * 100;
        percentageInt = percentage.round();
        finalList.add({
          'SAPID': sapNoSet[i],
          'Percentage': percentageInt,
          'Team_Code': teamCode
        });
      }

      data.clear();

      attendanceData.clear();
      sapNoList.clear();
      teamsListGraph.clear();
      demo.clear();
      sapValue.clear();
      sapNoSet.clear();
      print(finalList);

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => TableView(),
              settings: RouteSettings(arguments: finalList)));
    } /*else if (lectureType == 'practical_attendance') {*/
    else if (lectureType == 'practical_attendance') {
      for (int i = 1; i <= theoryHours; i++) {
        await allTeams
            .doc(demo[0]['code'])
            .collection(lectureType)
            .doc(i.toString())
            .collection('data')
            .get()
            .then((querySnapshot) {
          querySnapshot.docs.forEach((element) {
            attendanceData.add(element.data().toString());
          });
        });
      }

      String sap = '';
      int attendance = 0;
      for (int i = 0; i < attendanceData.length; i++) {
        sap = (attendanceData[i].toString().substring(1, 12));
        attendance = int.parse(attendanceData[i][14]);
        sapNoList.add(sap);
        sapValue.add({'sapID': sap, 'value': attendance});
      }

      int finalValue = 0;
      double percentage = 0.0;
      int percentageInt = 0;
      sapNoSet = sapNoList.toSet().toList();

      for (int i = 0; i < sapNoSet.length; i++) {
        finalValue = 0;
        for (int j = 0; j < sapValue.length; j++) {
          if (sapValue[j]['sapID'] == sapNoSet[i]) {
            finalValue = finalValue + sapValue[j]['value'] as int;
          }
        }
        percentage = (finalValue / theoryHours) * 100;
        percentageInt = percentage.round();
        finalList.add({
          'SAPID': sapNoSet[i],
          'Percentage': percentageInt,
          'Team_Code': teamCode
        });
      }

      data.clear();

      attendanceData.clear();
      sapNoList.clear();
      teamsListGraph.clear();
      demo.clear();
      sapValue.clear();
      sapNoSet.clear();
      print(finalList);

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => TableView(),
              settings: RouteSettings(arguments: finalList)));
    }
  } catch (e) {
    print(e.toString());
    return null;
  }
}

class Leaderboard extends StatefulWidget {
  const Leaderboard({Key? key}) : super(key: key);

  @override
  State<Leaderboard> createState() => _LeaderboardState();
}

class _LeaderboardState extends State<Leaderboard> {
  @override
  Widget build(BuildContext context) {
    String team = '';
    final arg = ModalRoute.of(context)!.settings.arguments;
    team = arg.toString();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Attendance Percentage',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Attendance Percentage'),
          backgroundColor: ColorsUsed.appBarColor,
        ),
        body: Row(
          children: [
            Padding(padding: EdgeInsets.all(15)),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "images/theory.jpeg",
                    height: 150,
                    width: 150,
                  ),
                  TextButton(
                  style:ButtonStyle(foregroundColor: MaterialStateProperty.all<Color>(ColorsUsed.uiColor)
                  ), 
                    child: Text(
                      "Theory Attendance",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      teamListData(team, 'theory_attendance', context);
                    },
                  ),
                ],
              ),
            ),
            Padding(padding: EdgeInsets.all(15)),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "images/practical.jpeg",
                    height: 150,
                    width: 150,
                  ),
                   TextButton(
                  style:ButtonStyle(foregroundColor: MaterialStateProperty.all<Color>(ColorsUsed.uiColor)
                  ), 
                    onPressed: () {
                      teamListData(team, 'practical_attendance', context);
                    },
                   
                    child: Text(
                      "Practical Attendance",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
