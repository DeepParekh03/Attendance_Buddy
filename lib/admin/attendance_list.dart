import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// import 'dart:html';
import 'package:firebase_core/firebase_core.dart';
import 'package:image_firebase/ServiceManager/AuthenticationService.dart';
import 'package:image_firebase/DatabaseManager/DatabaseManager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_firebase/admin/teams.dart';

class SecondPage extends StatefulWidget {
  const SecondPage({Key? key}) : super(key: key);

  @override
  State<SecondPage> createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  List viewMembers = [];

  String code = "";
  int i = 0;
  void initState() {
    super.initState();
    fetchDatabaseList(code);
  }

  final AuthenticationService _auth = AuthenticationService();
  fetchDatabaseList(code) async {
    dynamic result = await DatabaseManager().viewTeamMembers(code);
    if (result == null) {
      print('Unable to retrieve data');
    } else {
      setState(() {
        viewMembers = result;
      });
    }
  }

  getCheckbox() {
    // print("hello");
    bool isChecked = false;
    for (i; i < viewMembers.length; i++) {
      return Checkbox(
        value: isChecked,
        onChanged: (value) {
          setState(() {
            isChecked = value!;
          });
        },
      );
      // isChecked = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final arg = ModalRoute.of(context)!.settings.arguments;
    code = arg.toString();

    fetchDatabaseList(code);
    return Scaffold(
        appBar: AppBar(title: Text("Teams")),
        body: Container(
            child: ListView.builder(
                itemCount: viewMembers.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text(viewMembers[index]['name']),
                      subtitle: Text(viewMembers[index]['sap_id'].toString()),
                      leading: CircleAvatar(
                        // child: Image(
                        //   image: AssetImage('assets/Profile_Image.png'),
                        // ),
                        child: new Icon(Icons.account_box),
                      ),
                      trailing: getCheckbox(),
                      //
                    ),
                  );
                })));
  }
}