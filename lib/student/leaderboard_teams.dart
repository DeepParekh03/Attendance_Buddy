import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// import 'dart:html';
import 'package:firebase_core/firebase_core.dart';
import 'package:image_firebase/ServiceManager/AuthenticationService.dart';
import 'package:image_firebase/DatabaseManager/DatabaseManager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_firebase/admin/colors.dart';
import 'package:image_firebase/admin/teams_next.dart';
import 'package:image_firebase/admin/createTeams.dart';
import 'package:image_firebase/student/leaderboard_evaluation.dart';

class Teams_leaderboard extends StatefulWidget {
  const Teams_leaderboard({Key? key}) : super(key: key);

  @override
  State<Teams_leaderboard> createState() => _Teams_leaderboardState();
}

class _Teams_leaderboardState extends State<Teams_leaderboard> {
  String userID = "";
  String code = "";
  final AuthenticationService _auth = AuthenticationService();
  List viewTeamList = [];

  @override
  void initState() {
    super.initState();
    fetchUserInfo();
  }

  fetchUserInfo() async {
    User getUser = FirebaseAuth.instance.currentUser!;
    userID = getUser.uid;
    fetchDatabaseList();
  }

  fetchDatabaseList() async {
    dynamic result = await DatabaseManager().viewTeamsStudent(userID);
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
                      title: Text(viewTeamList[index]["code"]),
                      leading: CircleAvatar(
                        backgroundColor: ColorsUsed.uiColor,
                        // child: Image(
                        //   image: AssetImage('assets/Profile_Image.png'),
                        // ),
                        child: new Icon(
                          Icons.group,
                          color: Colors.white,
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Leaderboard(),
                                settings: RouteSettings(
                                    arguments: viewTeamList[index]['code']
                                        .toString())));
                      },
                    ),
                  );
                })));
  }
}
