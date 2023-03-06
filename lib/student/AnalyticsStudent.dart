// ignore_for_file: avoid_print, prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_local_variable, avoid_function_literals_in_foreach_calls, non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_firebase/DatabaseManager/DatabaseManager.dart';
import 'package:image_firebase/ServiceManager/AuthenticationService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_firebase/admin/colors.dart';
import 'package:image_firebase/student/StudentGraph.dart';

List teamsListGraph = [];
List demo = [];
List data = [];
List codeList = [];
String sapNo = '';
List sapNoList = [];
List valueList = [];
List bestList = [];
List theoryHourList = [];
double percentage = 0.0;
List lastList = [];
int present = 0;
int absent = 0;
int finalValue = 0;
List practicalLastList = [];

void refresh() {
  teamsListGraph.clear();
  demo.clear();
  data.clear();
  codeList.clear();
  sapNoList.clear();
  valueList.clear();
  bestList.clear();
  theoryHourList.clear();
  lastList.clear();
  practicalLastList.clear();
}

Future teamListData(sapid, lectureType, context) async {
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

    for (int i = 0; i < teamsListGraph.length; i++) {
      demo.add({
        'code': teamsListGraph[i]['code'].toString(),
        'subject': teamsListGraph[i]['subject'].toString(),
        'theoryHours': int.parse(teamsListGraph[i]['theory_hours']),
        'practicalHours': int.parse(teamsListGraph[i]['prac_hours'])
      });
    }
    if (lectureType == 'theory_attendance') {
      for (int i = 0; i < demo.length; i++) {
        for (int j = 1; j <= demo[i]['theoryHours']; j++) {
          await allTeams
              .doc(demo[i]['code'])
              .collection('theory_attendance')
              .doc(j.toString())
              .collection('data')
              .get()
              .then((querySnapshot) {
            querySnapshot.docs.forEach((element) {
              data.add({
                'TeamCode': demo[i]['code'],
                'value': element.data().toString()
              });
              codeList.add(demo[i]['code']);
            });
          });
        }
      }
      codeList = codeList.toSet().toList();
      for (int i = 0; i < data.length; i++) {
        sapNo = data[i]['value'].toString().substring(1, 12);
        int valueAtt = int.parse(data[i]['value'][14]);
        bestList.add(
            {'code': data[i]['TeamCode'], 'sapid': sapNo, 'value': valueAtt});
      }

      for (int i = 0; i < codeList.length; i++) {
        int finalValue = 0;
        absent = 0;
        for (int j = 0; j < bestList.length; j++) {
          if (bestList[j]['code'] == codeList[i]) {
            if (bestList[j]['sapid'] == sapid) {
              if (bestList[j]['value'] == 0) {
                absent++;
              }
              finalValue = bestList[j]['value'] + finalValue;
            }
          }
          percentage = (finalValue / (absent + finalValue)) * 100;
        }
        lastList.add({
          'code': codeList[i],
          'sapID': sapid,
          'Present': finalValue,
          'Absent': absent,
          'Total': finalValue + absent,
          'Percentage': percentage.round()
        });
      }
      print(lastList);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => StudentAttendanceCharts(),
              settings: RouteSettings(arguments: lastList)));
    } else if (lectureType == 'practical_attendance') {
      for (int i = 0; i < demo.length; i++) {
        for (int j = 1; j <= demo[i]['practicalHours']; j++) {
          await allTeams
              .doc(demo[i]['code'])
              .collection('practical_attendance')
              .doc(j.toString())
              .collection('data')
              .get()
              .then((querySnapshot) {
            querySnapshot.docs.forEach((element) {
              data.add({
                'TeamCode': demo[i]['code'],
                'value': element.data().toString()
              });
              codeList.add(demo[i]['code']);
            });
          });
        }
      }
      codeList = codeList.toSet().toList();
      for (int i = 0; i < data.length; i++) {
        sapNo = data[i]['value'].toString().substring(1, 12);
        int valueAtt = int.parse(data[i]['value'][14]);
        bestList.add(
            {'code': data[i]['TeamCode'], 'sapid': sapNo, 'value': valueAtt});
      }
      print('here');
      for (int i = 0; i < codeList.length; i++) {
        int finalValue = 0;
        absent = 0;
        for (int j = 0; j < bestList.length; j++) {
          if (bestList[j]['code'] == codeList[i]) {
            if (bestList[j]['sapid'] == sapid) {
              if (bestList[j]['value'] == 0) {
                absent++;
              }
              finalValue = bestList[j]['value'] + finalValue;
            }
          }
          percentage = (finalValue / (absent + finalValue)) * 100;
        }
        practicalLastList.add({
          'code': codeList[i],
          'sapID': sapid,
          'Present': finalValue,
          'Absent': absent,
          'Total': finalValue + absent,
          'Percentage': percentage.round()
        });
      }
      print(practicalLastList);
    }
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => StudentAttendanceCharts(),
            settings: RouteSettings(arguments: practicalLastList)));
  } catch (e) {
    print(e.toString());
    return null;
  }
}
// class BarAttendanceChart {
//   Widget BarChart() {
//     return Chart(
//       data: attendanceData,
//       variables: {
//         'Team': Variable(
//           accessor: (Map map) => map['Team'] as String,
//         ),
//         'Attended': Variable(
//           accessor: (Map map) => map['Attended'] as num,
//         ),
//       },
//       elements: [IntervalElement()],
//       axes: [
//         Defaults.horizontalAxis,
//         Defaults.verticalAxis,
//       ],
//     );
//   }
// }

class StudentGraph extends StatefulWidget {
  const StudentGraph({Key? key}) : super(key: key);

  @override
  State<StudentGraph> createState() => _StudentGraphState();
}

class _StudentGraphState extends State<StudentGraph> {
  TextEditingController sapIdInput = TextEditingController();
  TextEditingController subjectInput = TextEditingController();
  List subList = [];
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Attendance Percentage',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Attendance Percentage'),
          backgroundColor: ColorsUsed.appBarColor,
        ),
        body: Center(
          child: Column(children: [
            SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: sapIdInput,
                decoration: InputDecoration(
                  icon: Icon(Icons.domain_verification,
                      color: ColorsUsed.uiColor),
                  border: OutlineInputBorder(),
                  labelText: 'Sap ID',
                  hintText: 'Enter SAP ID',
                ),
              ),
            ),
            SizedBox(height: 50),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 200,
                    height: 50,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: ColorsUsed.uiColor),
                        onPressed: () {
                          teamListData(
                              sapIdInput.text, 'theory_attendance', context);
                          print(sapIdInput.text);
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => FinalGraph()));
                        },
                        child: Text('Theory Attendance')),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 200,
                    height: 50,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: ColorsUsed.uiColor),
                        onPressed: () {
                          teamListData(
                              sapIdInput.text, 'practical_attendance', context);
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => FinalGraph()));
                        },
                        child: Text('Practical Attendance')),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 50,
                    width: 200,
                    child: ElevatedButton(
                      style:
                          ElevatedButton.styleFrom(primary: ColorsUsed.uiColor),
                      onPressed: () {
                        refresh();
                      },
                      child: Text('Refresh'),
                    ),
                  ),
                )
              ],
            )
          ]),
        ),
      ),
    );
  }
}
