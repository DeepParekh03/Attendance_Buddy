import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:image_firebase/ServiceManager/AuthenticationService.dart';
import 'package:image_firebase/DatabaseManager/DatabaseManager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_firebase/admin/colors.dart';

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
  TextEditingController _subjectController = TextEditingController();
  TextEditingController _departmentController = TextEditingController();
  TextEditingController _theoryController = TextEditingController();
  TextEditingController _practicalController = TextEditingController();
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

  createTeamsData(String name, String code, String id, String department,
      String subject, String theory_hours, String prac_hours) async {
    await DatabaseManager().createTeams(
        name, code, id, department, subject, theory_hours, prac_hours);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorsUsed.backgroundColor,
        // Color.fromARGB(255, 236, 236, 236),
        appBar: AppBar(
          backgroundColor: ColorsUsed.appBarColor,
          title: Text('Create Teams'),
        ),
        body: SingleChildScrollView(
          child: Padding(
              padding: EdgeInsets.all(15),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(15),
                    child: TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        icon: Icon(Icons.group, color: ColorsUsed.uiColor),
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
                        icon: Icon(Icons.check_circle_outline_rounded,
                            color: ColorsUsed.uiColor),
                        border: OutlineInputBorder(),
                        labelText: 'Team Code',
                        hintText: 'Enter Team Code',
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(15),
                    child: TextField(
                      controller: _subjectController,
                      decoration: InputDecoration(
                        icon: Icon(Icons.chrome_reader_mode_outlined,
                            color: ColorsUsed.uiColor),
                        border: OutlineInputBorder(),
                        labelText: 'Subject',
                        hintText: 'Enter the Subject',
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(15),
                    child: TextField(
                      controller: _departmentController,
                      decoration: InputDecoration(
                        icon: Icon(Icons.corporate_fare_outlined,
                            color: ColorsUsed.uiColor),
                        border: OutlineInputBorder(),
                        labelText: 'Department',
                        hintText: 'Enter your Department',
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(15),
                    child: TextField(
                      controller: _theoryController,
                      decoration: InputDecoration(
                        icon:
                            Icon(Icons.access_time, color: ColorsUsed.uiColor),
                        border: OutlineInputBorder(),
                        labelText: 'Enter theory hours',
                        hintText: 'Theory Hours',
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(15),
                    child: TextField(
                      controller: _practicalController,
                      decoration: InputDecoration(
                        icon:
                            Icon(Icons.access_time, color: ColorsUsed.uiColor),
                        border: OutlineInputBorder(),
                        labelText: 'Enter practical hours',
                        hintText: 'Practical Hours',
                      ),
                    ),
                  ),
                  ElevatedButton(
                  
                    child: Text('Create'),
                    onPressed: () {
                      submit(context);
                    },
                  )
                ],
              )),
        ));
  }

  submit(BuildContext context) {
    createTeamsData(
        _nameController.text,
        _codeContoller.text,
        userID,
        _departmentController.text,
        _subjectController.text,
        _theoryController.text,
        _practicalController.text);
    _nameController.clear();
    _codeContoller.clear();
    _departmentController.clear();
    _subjectController.clear();
    _theoryController.clear();
    _practicalController.clear();
  }
}
