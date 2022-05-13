import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_firebase/DatabaseManager/DatabaseManager.dart';
import 'package:image_firebase/ServiceManager/AuthenticationService.dart';
import 'package:image_firebase/main.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final AuthenticationService _auth = AuthenticationService();

  TextEditingController _genderContoller = TextEditingController();
  TextEditingController _departmentContoller = TextEditingController();
  TextEditingController _sapController = TextEditingController();

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

  updateData(
      String gender, String department, double sap_id, String userID) async {
    await DatabaseManager().updateAdminList(gender, department, sap_id, userID);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Information Screen"),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            child: Column(children: [
              TextField(
                controller: _sapController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Enter SAP ID',
                    hintText: 'Enter Your sap_id'),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: _genderContoller,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Enter Gender',
                    hintText: 'Enter Your Gender'),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: _departmentContoller,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Enter Department',
                    hintText: 'Enter Your Department'),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FlatButton(
                    child: Text('Update'),
                    onPressed: () {
                      submitAction(context);
                    },
                    color: Colors.deepPurpleAccent,
                  ),
                  FlatButton(
                    child: Text('Cancel'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    color: Colors.deepPurpleAccent,
                  )
                ],
              ),
            ]),
          ),
        ),
      ),
    );
  }

  submitAction(BuildContext context) {
    updateData(_genderContoller.text, _departmentContoller.text,
        double.parse(_sapController.text), userID);
    _genderContoller.clear();

    _departmentContoller.clear();
    _sapController.clear();
  }
}
