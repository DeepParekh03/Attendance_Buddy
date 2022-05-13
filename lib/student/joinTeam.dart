import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:image_firebase/ServiceManager/AuthenticationService.dart';
import 'package:image_firebase/DatabaseManager/DatabaseManager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const JoinTeams());
}

class JoinTeams extends StatefulWidget {
  const JoinTeams({Key? key}) : super(key: key);

  @override
  State<JoinTeams> createState() => _JoinTeamsState();
}

class _JoinTeamsState extends State<JoinTeams> {
  final AuthenticationService _auth = AuthenticationService();
  String userID = "";
  String name = "";
  double sap_id = 0;

  TextEditingController _codeContoller = TextEditingController();

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
          .collection('profileInfo')
          .doc(userID)
          .get()
          .then((ds) {
        name = ds.get('name');
        sap_id = ds.get('sap_id');
      }).catchError((e) {
        print(e.toString());
      });
  }

  JoinTeamsData(String code) async {
    await DatabaseManager().joinTeams(code, name, sap_id, userID);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Create Teams'),
        ),
        body: Padding(
            padding: EdgeInsets.all(15),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(15),
                  child: TextField(
                    controller: _codeContoller,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Team Code',
                      hintText: 'Enter Team Code',
                    ),
                  ),
                ),
                RaisedButton(
                  textColor: Colors.white,
                  color: Colors.blue,
                  child: Text('Join Teams'),
                  onPressed: () {
                    submit(context);
                  },
                )
              ],
            )));
  }

  submit(BuildContext context) {
    JoinTeamsData(_codeContoller.text);

    _codeContoller.clear();
  }
}
