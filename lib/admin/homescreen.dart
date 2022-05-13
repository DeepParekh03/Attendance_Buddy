import 'package:flutter/material.dart';
import 'package:image_firebase/admin/dashboard.dart';
import 'dart:ui' as ui;
import 'package:image_firebase/student/joinTeam.dart';
// import 'dart:io';
// import 'package:image_firebase/admin/teams.dart';
// import 'package:image_firebase/admin/profile.dart';
import 'package:image_firebase/admin/createTeams.dart';

class HomeScreenStudent extends StatefulWidget {
  const HomeScreenStudent({Key? key}) : super(key: key);

  @override
  State<HomeScreenStudent> createState() => _HomeScreenStudentState();
}

class _HomeScreenStudentState extends State<HomeScreenStudent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 244, 235, 220),
        appBar: AppBar(
          title: Text("Home Screen"),
        ),
        body: Container(
            child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                  padding: EdgeInsets.all((10)),
                  margin: EdgeInsets.all(5),
                  alignment: Alignment.topCenter,
                  child:
                      Image.asset(("images/a3.jpeg"), width: 500, height: 300)),
              SizedBox(height: 10),
              Text(
                'Features',
                style: TextStyle(
                    fontSize: 20,
                    foreground: Paint()
                      ..shader = ui.Gradient.linear(
                        const Offset(0, 20),
                        const Offset(150, 20),
                        <Color>[
                          Colors.deepPurpleAccent,
                          Colors.black,
                        ],
                      )),
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FloatingActionButton(
                    elevation: 0.0,
                    child: new Icon(Icons.receipt_long),
                    tooltip: "View Report",
                    backgroundColor: new Color(0xFFE57373),
                    onPressed: () {},
                  ),
                  FloatingActionButton(
                    elevation: 0.0,
                    child: new Icon(Icons.leaderboard),
                    tooltip: "LeaderBoard",
                    backgroundColor: new Color(0xFFE57373),
                    onPressed: () {},
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FloatingActionButton(
                    elevation: 0.0,
                    child: new Icon(Icons.add),
                    tooltip: "Create Teams",
                    backgroundColor: new Color(0xFFE57373),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Teams()));
                    },
                  ),
                  FloatingActionButton(
                    elevation: 0.0,
                    child: new Icon(Icons.auto_graph_outlined),
                    tooltip: "Graph analytics",
                    backgroundColor: new Color(0xFFE57373),
                    onPressed: () {},
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                'Edit Default User Info',
                style: TextStyle(
                    fontSize: 18,
                    foreground: Paint()
                      ..shader = ui.Gradient.linear(
                        const Offset(0, 20),
                        const Offset(150, 20),
                        <Color>[
                          Colors.deepPurpleAccent,
                          Colors.black,
                        ],
                      )),
              ),
              SizedBox(
                height: 10,
              ),
              RaisedButton(
                child: Text('Edit Info'),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Dashboard()));
                },
              ),
            ],
          ),
        )));
  }
}
