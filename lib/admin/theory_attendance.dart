import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// import 'dart:html';
import 'package:firebase_core/firebase_core.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_firebase/ServiceManager/AuthenticationService.dart';
import 'package:image_firebase/DatabaseManager/DatabaseManager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_firebase/admin/bottombar.dart';
import 'package:image_firebase/admin/colors.dart';
import 'package:image_firebase/admin/dashboardtrial.dart';
import 'package:image_firebase/admin/teams.dart';
import 'package:image_firebase/admin/teams_next.dart';
import 'package:intl/intl.dart';

class TheoryPage extends StatefulWidget {
  const TheoryPage({Key? key}) : super(key: key);

  @override
  State<TheoryPage> createState() => _TheoryPageState();
}

class _TheoryPageState extends State<TheoryPage> {
  List viewMembers = [];
  List data = [];
  List present = [];
  List absent = [];
  List list = [];
  late List<bool> isChecked =
      List.generate(viewMembers.length, (index) => false);

  String code = "";
  String prac = "";
  int count_true = 0;
  int count_false = 0;

  void initState() {
    super.initState();
    fetchDatabaseList(code, prac);
  }

  final AuthenticationService _auth = AuthenticationService();
  fetchDatabaseList(code, prac) async {
    dynamic result = await DatabaseManager().viewmembersTheory(code, prac);
    if (result == null) {
      print('Unable to retrieve data');
    } else {
      setState(() {
        viewMembers = result;
      });
    }
    ;
  }

  @override
  Widget build(BuildContext context) {
    final arg = ModalRoute.of(context)!.settings.arguments as DataArguments;

    fetchDatabaseList(arg.code.toString(), arg.theory_doc.toString());

    return Scaffold(
      backgroundColor: ColorsUsed.backgroundColor,
      appBar:
          AppBar(title: Text("Teams"), backgroundColor: ColorsUsed.appBarColor),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: viewMembers.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text(viewMembers[index].toString()),
                      leading: CircleAvatar(
                        backgroundColor: ColorsUsed.uiColor,
                        // child: Image(
                        //   image: AssetImage('assets/Profile_Image.png'),
                        // ),
                        child: new Icon(
                          Icons.account_box,
                          color: Colors.white,
                        ),
                      ),
                      trailing: Checkbox(
                        onChanged: (checked) {
                          setState(
                            () {
                              isChecked[index] = checked!;

                              getdata(index);
                            },
                          );
                        },
                        value: isChecked[index],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 70.0),
              child: ElevatedButton(
               
                onPressed: () {
                  // print(data);
                  // print(list);
                  //   viewMembers.forEach((element) {
                  //data.add(element);
                  // });
                  // print(data);
                  isChecked.forEach((check) {
                    if (check == true) {
                      getdata(index) {
                        list.add(index);
                      }

                      // present.add(check);
                      count_true += 1;
                    } else {
                      count_false += 1;
                    }
                  });
                  // print(present);
                  //print(list);
                  print(count_true);
                  print(count_false);
                  setState(() {
                    count_false = 0;
                    count_true = 0;
                    // present.clear();
                    //list.clear();
                  });
                  submit(arg.code.toString(), arg.theory_doc.toString());

                  //   //
                },
                child: Text(
                  'Submit',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
    // getCheckbox((value) {
    //   setState(() {
    //     print('hi');
    //     val = value!;
    //   });
    // },),
    //
  }

  Future submit(code, prac) async {
    print(list);
    DateTime now = DateTime.now();
    String formattedDate = DateFormat.yMMMMd().format(now);
    try {
      for (int i = 0; i < list.length; i++) {
        print(code);
        print(prac);
        await FirebaseFirestore.instance
            .collection("teamList")
            .doc(code)
            .collection("theory_attendance")
            .doc(prac)
            .collection("data")
            .doc(list[i])
            .set({list[i].toString(): 0});

        FirebaseFirestore.instance
            .collection("teamList")
            .doc(code)
            .collection("theory_attendance")
            .doc(prac)
            .set({'date': formattedDate});

        Fluttertoast.showToast(
          msg: "Attendance Submitted", // message
          toastLength: Toast.LENGTH_SHORT, // length
          gravity: ToastGravity.BOTTOM, // location
          // duration
        );

        Navigator.push(
            context, MaterialPageRoute(builder: (context) => BottomBar()));
      }
    } catch (e) {
      print(e.toString());
    }
    setState(() {
      list.clear();
    });
  }

  getdata(index) {
    if (!list.contains(viewMembers[index])) {
      list.add(viewMembers[index]);
    }
  }
}
