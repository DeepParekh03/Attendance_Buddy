// import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class DatabaseManager {
  CollectionReference profileList =
      FirebaseFirestore.instance.collection('profileInfo');

  CollectionReference teamList =
      FirebaseFirestore.instance.collection('teamList');

  CollectionReference adminprofileList =
      FirebaseFirestore.instance.collection('adminprofileList');

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
      int semester, double sap_id, String uid) async {
    return await profileList.doc(uid).update({
      'gender': gender,
      'ad_year': ad_year,
      'department': department,
      'semester': semester,
      'sap_id': sap_id
    });
  }

  //create teams
  Future<void> createTeams(String name, String code, String id) {
    return teamList
        .doc(code)
        .set({
          'name': name,
          'code': code,
          'id': id,
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
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

  //join teams student

  Future joinTeams(String code, String name, double sap_id, String uid) async {
    teamList
        .doc(code)
        .collection("team_members")
        .add({"sap_id": sap_id, "name": name, 'userid': uid});
  }

  //view teams student

  Future viewTeamsStudent(uid) async {
    List itemsList = [];

    try {
      await teamList.get().then((querySnapshot) {
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
}
