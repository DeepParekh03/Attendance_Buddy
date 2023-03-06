import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_firebase/ServiceManager/AuthenticationService.dart';
import 'package:image_firebase/DatabaseManager/DatabaseManager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_firebase/admin/colors.dart';
import 'package:image_firebase/admin/uploadProfilePhoto.dart';
import 'package:image_picker/image_picker.dart';

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
  String name = " ";
  String department = "";
  String gender = "";
  double sap_id = 0.0;
  String url = "";

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
        .collection('adminprofileList')
        .doc(userID)
        .get()
        .then((ds) {
      name = ds.get('name');
      department = ds.get('department');
      gender = ds.get('gender');
      sap_id = ds.get('sap_id');
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
                return Container(
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
                      height: 50,
                    ),
                    Align(
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
                    Align(
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
                    SizedBox(
                      height: 20,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Department \n$department",
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 20,
                            color: ColorsUsed.uiColor,
                          )),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Name \n$name",
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 20,
                            color: ColorsUsed.uiColor,
                          ),
                        )),
                    SizedBox(
                      height: 20,
                    ),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Gender\n$gender",
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 20,
                            color: ColorsUsed.uiColor,
                          ),
                        )),
                    SizedBox(
                      height: 20,
                    ),
                    Align(
                        alignment: Alignment.center,
                        child:  TextButton(
                  style:ButtonStyle(foregroundColor: MaterialStateProperty.all<Color>(ColorsUsed.uiColor)
                  ), 
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProfilePhoto()));
                          },
                          child: Text(
                            "Edit ",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        )),
                  ]),
                );
              }
              return Text("Loading");
            },
          ),
        ));
  }
}
