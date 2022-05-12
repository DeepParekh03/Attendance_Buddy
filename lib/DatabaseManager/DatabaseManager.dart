// import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class DatabaseManager {
  CollectionReference profileList =
      FirebaseFirestore.instance.collection('profileInfo');

  CollectionReference teamList =
      FirebaseFirestore.instance.collection('teamList');

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

  Future joinTeams(String code, String name, double sap_id) async {
    teamList
        .doc(code)
        .collection("team_memebers")
        .add({"sap_id": sap_id, "name": name});
  }
}
