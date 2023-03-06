import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_firebase/ServiceManager/AuthenticationService.dart';
import 'package:image_firebase/DatabaseManager/DatabaseManager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_firebase/admin/colors.dart';
import 'package:image_firebase/student/dashboard_student.dart';
import 'package:image_firebase/student/upload_studentprofile.dart';
import 'package:image_picker/image_picker.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const Profile());
}

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final AuthenticationService _auth = AuthenticationService();

  var _image;
  final ImagePicker _picker = ImagePicker();
  String userID = "";

  int ad_year = 0;
  String url = "";
  String name = " ";
  String department = "";
  String gender = "";
  int semester = 0;
  double sap_id = 0.0;

  @override
  void initState() {
    super.initState();
    fetchUserInfo();
  }

  fetchUserInfo() async {
    User getUser = FirebaseAuth.instance.currentUser!;
    userID = getUser.uid;
    if (getUser != null)
      await FirebaseFirestore.instance
          .collection("profilePhoto")
          .doc(userID)
          .get()
          .then((value) {
        url = value.get('imageURL');
        print(url);
      });

    await FirebaseFirestore.instance
        .collection('profileInfo')
        .doc(userID)
        .get()
        .then((ds) {
      ad_year = ds.get('ad_year');
      name = ds.get('name');
      department = ds.get('department');
      gender = ds.get('gender');
      semester = ds.get('semester');
      sap_id = ds.get('sap_id');
      print(ad_year);
      print(name);
      print(sap_id);
      print(department);
      print(gender);
    }).catchError((e) {
      print(e.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsUsed.backgroundColor,
      appBar: AppBar(
          title: Text("Profile Screen"),
          backgroundColor: ColorsUsed.appBarColor),
      body: Container(
        child: FutureBuilder(
          future: fetchUserInfo(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return SingleChildScrollView(
                child: Container(
                  child: Column(children: [
                    Column(children: [
                      Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage("images/profile_back.png"),
                                fit: BoxFit.cover)),
                        child: Container(
                          width: double.infinity,
                          height: 200,
                          child: Stack(
                            alignment: Alignment(0.0, 2.5),
                            children: <Widget>[
                              CircleAvatar(
                                  radius: 60,
                                  backgroundImage: NetworkImage(url)),
                            ],
                          ),
                        ),
                      ),
                    ]),
                    SizedBox(
                      height: 40,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 5),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "SAP ID ",
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.bold,
                            color: ColorsUsed.uiColor,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 5),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "$sap_id",
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            color: ColorsUsed.uiColor,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 5),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Semester ",
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.bold,
                            color: ColorsUsed.uiColor,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 5),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "$semester",
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            color: ColorsUsed.uiColor,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 5),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Department ",
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.bold,
                            color: ColorsUsed.uiColor,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 5),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "$department",
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            color: ColorsUsed.uiColor,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 5),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Name ",
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.bold,
                            color: ColorsUsed.uiColor,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 5),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "$name",
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            color: ColorsUsed.uiColor,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 5),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Gender ",
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.bold,
                            color: ColorsUsed.uiColor,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 5),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "$gender",
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            color: ColorsUsed.uiColor,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Align(
                        alignment: Alignment.center,
                        child:   TextButton(
                  style:ButtonStyle(foregroundColor: MaterialStateProperty.all<Color>(ColorsUsed.uiColor)
                  ), 
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EditInfoStudent()));
                          },
                          child: Text(
                            "Edit ",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        )),
                  ]),
                ),
              );
            }
            return Text("Loading");
          },
        ),
      ),
    );
  }
}
