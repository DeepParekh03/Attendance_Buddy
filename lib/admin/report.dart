import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// import 'dart:html';
import 'package:firebase_core/firebase_core.dart';
import 'package:image_firebase/ServiceManager/AuthenticationService.dart';
import 'package:image_firebase/DatabaseManager/DatabaseManager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_firebase/admin/colors.dart';
import 'package:image_firebase/admin/report_button.dart';
import 'package:image_firebase/admin/teams_next.dart';
import 'package:image_firebase/admin/createTeams.dart';

class Report extends StatefulWidget {
  const Report({Key? key}) : super(key: key);

  @override
  State<Report> createState() => _ReportState();
}

class _ReportState extends State<Report> {
  String userID = "";
  String prac = "";
  String code = "";
  final AuthenticationService _auth = AuthenticationService();
  List viewTeamList = [];

  @override
  void initState() {
    super.initState();
    fetchUserInfo();
    fetchDatabaseList();
  }

  fetchUserInfo() async {
    User getUser = FirebaseAuth.instance.currentUser!;
    userID = getUser.uid;
  }

  fetchDatabaseList() async {
    dynamic result = await DatabaseManager().viewTeams(userID);
    if (result == null) {
      print('Unable to retrieve data');
    } else {
      setState(() {
        viewTeamList = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorsUsed.backgroundColor,
        appBar: AppBar(
          title: Text("Teams"),
          backgroundColor: ColorsUsed.appBarColor,
        ),
        body: Container(
            child: ListView.builder(
                itemCount: viewTeamList.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text(viewTeamList[index]['name']),
                      subtitle: Text(viewTeamList[index]['code']),
                      leading: CircleAvatar(
                        backgroundColor: ColorsUsed.uiColor,
                        child: new Icon(
                          Icons.group,
                          color: Colors.white,
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Button(),
                                settings: RouteSettings(
                                    arguments: viewTeamList[index]['code']
                                        .toString())));
                      },
                    ),
                  );
                })));
  }
}
