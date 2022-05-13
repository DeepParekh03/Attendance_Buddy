import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_firebase/student/student_login.dart';
import 'package:image_firebase/admin/admin_login.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    home: BaseScreen(),
  ));
}

class BaseScreen extends StatefulWidget {
  @override
  _BaseScreenState createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Base Screen"),
      ),
      body: Container(
        color: Colors.deepPurpleAccent,
        child: Center(
          child: Column(children: [
            RaisedButton(
              child: Text('Admin'),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              },
            ),
            SizedBox(
              height: 30,
            ),
            RaisedButton(
              child: Text('Student'),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => LoginScreenStudent()));
              },
            ),
          ]),
        ),
      ),
    );
  }
}
