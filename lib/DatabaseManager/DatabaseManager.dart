// import 'dart:js';
// import 'dart:convert';
// import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';

class DatabaseManager {
  CollectionReference profileList =
      FirebaseFirestore.instance.collection('profileInfo');

  CollectionReference recordAttendance =
      FirebaseFirestore.instance.collection('Attendance');

  CollectionReference teamList =
      FirebaseFirestore.instance.collection('teamList');

  CollectionReference adminprofileList =
      FirebaseFirestore.instance.collection('adminprofileList');

  CollectionReference teams = FirebaseFirestore.instance.collection('team');

  //create Admin Dummy Data

  Future<void> createAdminData(String name, String gender, String department,
      double sap_id, String uid, String email) async {
    return await adminprofileList.doc(uid).set({
      'name': name,
      'gender': gender,
      'department': department,
      'sap_id': sap_id,
      'email': email
    });
  }

//create student dummy data
  Future<void> createUserData(String name, String gender, int semester,
      String department, int ad_year, double sap_id, String uid) async {
    return await profileList.doc(uid).set({
      'name': name,
      'gender': gender,
      'semester': semester,
      'department': department,
      'ad_year': ad_year,
      'sap_id': sap_id
    });
  }

  //update admin profile

  Future updateAdminList(
      String gender, String department, double sap_id, String uid) async {
    return await adminprofileList
        .doc(uid)
        .update({'gender': gender, 'department': department, 'sap_id': sap_id});
  }

//update student profile
  Future updateUserList(String gender, int ad_year, String department,
      int semester, String uid) async {
    return await profileList.doc(uid).update({
      'gender': gender,
      'ad_year': ad_year,
      'department': department,
      'semester': semester,
    });
  }

  //create teams
  Future<void> createTeams(
      String name,
      String code,
      String id,
      String department,
      String subject,
      String prac_hours,
      String theory_hours) async {
    teamList
        .doc(code)
        .set({
          'name': name,
          'code': code,
          'id': id,
          'department': department,
          'subject': subject,
          'prac_hours': prac_hours,
          'theory_hours': theory_hours,
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));

    teamList.doc(code).collection("team_members").add({});

    for (int i = 1; i <= int.parse(prac_hours) / 2; i++) {
      teamList
          .doc(code)
          .collection("practical_attendance")
          .doc(i.toString())
          .set({});
    }
    //teamList.doc(code).collection("theory_attendance").add({});
    for (int i = 1; i <= int.parse(theory_hours); i++) {
      teamList
          .doc(code)
          .collection("theory_attendance")
          .doc(i.toString())
          .set({});
    }
  }

  //join teams student

  Future joinTeams(String code, String name, double sap_id, String uid) async {
    await teams.add({"user": uid, "code": code}).then(
        (value) => print("Student added"));

    teamList
        .doc(code)
        .collection("team_members")
        .doc(uid)
        .set({"sap_id": sap_id, "name": name, 'userid': uid}).then(
            (value) => print("Student added"));

    // var val = teamList.doc(code).collection("theory_attendance").get();
    // final data=val[0].

//     Query theory_hours = teamList.where("theory_hours");
//     final parsedJson = jsonDecode(theory_hours as String);
// // 3. print the type and value
// //print('${parsedJson.runtimeType} : $parsedJson');
//     print(parsedJson);

    teamList
        .doc(code)
        .collection("theory_attendance")
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((element) {
        teamList
            .doc(code)
            .collection("theory_attendance")
            .doc(element.id)
            .collection("data")
            .doc(sap_id.toString().substring(0, 11))
            .set({sap_id.toString().substring(0, 11): 1},
                SetOptions(merge: true)).then((value) {
          print("Value added");
        });
      });
    });

    teamList
        .doc(code)
        .collection("practical_attendance")
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((element) {
        teamList
            .doc(code)
            .collection("practical_attendance")
            .doc(element.id)
            .collection("data")
            .doc(sap_id.toString().substring(0, 11))
            .set({sap_id.toString().substring(0, 11): 2},
                SetOptions(merge: true)).then((value) {
          print("Value added");
        });
      });
    });
  }

  //view teams admin

  Future viewTeams(uid) async {
    List itemsList = [];

    try {
      await teamList.where("id", isEqualTo: uid).get().then((querySnapshot) {
        querySnapshot.docs.forEach((element) {
          itemsList.add(element.data());
        });
      });
      return itemsList;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //view teams student

  Future viewTeamsStudent(uid) async {
    List studentTeamList = [];
    try {
      print(uid);
      await teams.where("user", isEqualTo: uid).get().then((querySnapshot) {
        querySnapshot.docs.forEach((element) {
          studentTeamList.add(element.data());
        });
      });

      return studentTeamList;
    } catch (e) {
      print(e.toString());
    }
    // var code = "MIS123";

    //       .doc(code)
    //       .collection('team_members')
    //       .get()
    //       .then((querySnapshot) {});
    //   return studentTeamList;
    //   //print(studentTeamList);
    //   //return studentTeamList;
    // } catch (e) {
    //   print(e.toString());
    //   return null;
    // }
  }

  //read sub collection(practical_attendance)
  Future viewmembersPracticals(code, prac) async {
    List members = [];

    try {
      await teamList
          .doc(code)
          .collection('practical_attendance')
          .doc(prac)
          .collection("data")
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((element) {
          members.add(element.data());
        });
      });

      return members;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future viewmembersTheory(code, prac) async {
    List members = [];

    try {
      await teamList
          .doc(code)
          .collection('theory_attendance')
          .doc(prac)
          .collection("data")
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((element) {
          members.add(element.data().toString().substring(1, 12));
        });
      });
      // print(members);
      return members;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
