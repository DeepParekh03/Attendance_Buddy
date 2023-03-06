import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_firebase/admin/colors.dart';
// import 'dart:html';
import 'package:image_firebase/admin/theory_attendance.dart';
import 'package:image_firebase/admin/practical_attendance.dart';

class ButtonData extends StatefulWidget {
  const ButtonData({Key? key}) : super(key: key);

  @override
  State<ButtonData> createState() => _ButtonDataState();
}

class _ButtonDataState extends State<ButtonData> {
  String code = "";
  String theory_doc = "";
  String prac_doc = "";
  @override
  Widget build(BuildContext context) {
    final arg = ModalRoute.of(context)!.settings.arguments;
    code = arg.toString();
    return Scaffold(
      backgroundColor: ColorsUsed.backgroundColor,
      appBar: AppBar(
          title: Text("Theory"), backgroundColor: ColorsUsed.appBarColor),
      body: Row(
        children: [
          Padding(padding: EdgeInsets.all(15)),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('teamList')
                      .doc(code)
                      .collection('theory_attendance')
                      .snapshots(), // path to collection of documents that is listened to as a stream
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasData) {
                      List<String> prac_docs = [];
                      for (int i = 0; i < snapshot.data!.docs.length; i++) {
                        DocumentSnapshot snap = snapshot.data!.docs[i];

                        prac_docs.add(snap.id);
                      }
                      var selectedData;
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Image.asset(
                              "images/theory.jpeg",
                              height: 150,
                              width: 150,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            DropdownButton<String>(
                              items: prac_docs.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              value: selectedData,
                              onChanged: (prac) {
                                theory_doc = prac!;
                                final snackbar = SnackBar(
                                  content: Text("Selected value: $prac"),
                                );
                                ScaffoldMessenger.of(context).showSnackBar(snackbar);

                                setState(() {
                                  selectedData = prac.toString();
                                });
                              },
                              isExpanded: false,
                              hint: Text(
                                "Choose lecture",
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                          ],
                        ),
                      );
                    } else {
                      return Text("No data");
                    }
                  },
                ),
                  TextButton(
                  style:ButtonStyle(foregroundColor: MaterialStateProperty.all<Color>(ColorsUsed.uiColor)
                  ), 
                  child: Text(
                    "Theory Attendance",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () {
                    print(theory_doc);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TheoryPage(),
                            settings: RouteSettings(
                                arguments: DataArguments(code, theory_doc))));
                  },
                ),
              ],
            ),
          ),

          //practical_attendance

          Padding(padding: EdgeInsets.all(15)),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('teamList')
                      .doc(code)
                      .collection('practical_attendance')
                      .snapshots(), // path to collection of documents that is listened to as a stream
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasData) {
                      List<String> prac_docs = [];
                      for (int i = 0; i < snapshot.data!.docs.length; i++) {
                        DocumentSnapshot snap = snapshot.data!.docs[i];

                        prac_docs.add(snap.id);
                      }
                      var selectedData;
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Image.asset(
                              "images/practical.jpeg",
                              height: 150,
                              width: 150,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            DropdownButton<String>(
                              items: prac_docs.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              value: selectedData,
                              onChanged: (prac) {
                                prac_doc = prac!;
                                final snackbar = SnackBar(
                                  content: Text("Selected value: $prac"),
                                );
                                ScaffoldMessenger.of(context).showSnackBar(snackbar);

                                setState(() {
                                  selectedData = prac.toString();
                                });
                              },
                              isExpanded: false,
                              hint: Text(
                                "Choose lecture",
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                          ],
                        ),
                      );
                    } else {
                      return Text("No data");
                    }
                  },
                ),
                 TextButton(
                  style:ButtonStyle(foregroundColor: MaterialStateProperty.all<Color>(ColorsUsed.uiColor)
                  ), 
                  child: Text(
                    "Practical Attendance",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () {
                    print(theory_doc);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PracticalPage(),
                            settings: RouteSettings(
                                arguments: ScreenArguments(code, prac_doc))));
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ScreenArguments {
  final String code;
  final String prac_doc;

  ScreenArguments(this.code, this.prac_doc);
}

class DataArguments {
  final String code;
  final String theory_doc;

  DataArguments(this.code, this.theory_doc);
}
