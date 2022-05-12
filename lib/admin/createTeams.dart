import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:image_firebase/ServiceManager/AuthenticationService.dart';
import 'package:image_firebase/DatabaseManager/DatabaseManager.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const Teams());
}

class Teams extends StatefulWidget {
  const Teams({Key? key}) : super(key: key);

  @override
  State<Teams> createState() => _TeamsState();
}

class _TeamsState extends State<Teams> {
  final AuthenticationService _auth = AuthenticationService();

  TextEditingController _codeContoller = TextEditingController();
  TextEditingController _nameController = TextEditingController();

  String userID = "";

  @override
  void initState() {
    super.initState();
    fetchUserInfo();
  }

  fetchUserInfo() {
    User getUser = FirebaseAuth.instance.currentUser!;
    userID = getUser.uid;
  }

  createTeamsData(String name, String code, String id) async {
    await DatabaseManager().createTeams(name, code, id);
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
                    controller: _nameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Team Name',
                      hintText: 'Enter Team Name',
                    ),
                  ),
                ),
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
                  child: Text('Create'),
                  onPressed: () {
                    submit(context);
                  },
                )
              ],
            )));
  }

  submit(BuildContext context) {
    createTeamsData(_nameController.text, _codeContoller.text, userID);
    _nameController.clear();
    _codeContoller.clear();
  }
}
