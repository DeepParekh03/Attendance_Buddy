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
  TextEditingController _yearController = TextEditingController();
  TextEditingController _departmentContoller = TextEditingController();
  TextEditingController _semesterController = TextEditingController();
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

  updateData(String gender, int ad_year, String department, int semester,
      double sap_id, String userID) async {
    await DatabaseManager()
        .updateUserList(gender, ad_year, department, semester, sap_id, userID);
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
                controller: _yearController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Enter Year',
                    hintText: 'Enter Your Year'),
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
              TextField(
                controller: _semesterController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Enter Your Semester',
                    hintText: 'Enter Your Semester'),
              ),
              SizedBox(
                height: 30,
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
    updateData(
        _genderContoller.text,
        int.parse(_yearController.text),
        _departmentContoller.text,
        int.parse(_semesterController.text),
        double.parse(_sapController.text),
        userID);
    _genderContoller.clear();
    _yearController.clear();
    _departmentContoller.clear();
    _semesterController.clear();
    _sapController.clear();
  }
}
