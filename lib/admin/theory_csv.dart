import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_firebase/ServiceManager/AuthenticationService.dart';
import 'package:image_firebase/admin/colors.dart';
import 'package:csv/csv.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ext_storage/ext_storage.dart';
import 'dart:io'; // for File
// import 'dart:html';

class THEORY_CSV extends StatefulWidget {
  const THEORY_CSV({Key? key}) : super(key: key);

  @override
  State<THEORY_CSV> createState() => _THEORY_CSVState();
}

class _THEORY_CSVState extends State<THEORY_CSV> {
  final AuthenticationService _auth = AuthenticationService();
  String url = "";
  String userID = "";
  String theory_doc = "";
  List<dynamic> data = [];
  CollectionReference teamList =
      FirebaseFirestore.instance.collection('teamList');

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      this.fetchUserInfo();
    });
  }

  String date = "";
  String code = "";
  String name = "";
  String subject = "";

  fetchSubject(code) async {
    await FirebaseFirestore.instance
        .collection("teamList")
        .doc(code)
        .get()
        .then((value) {
      subject = value.get('subject');
    });
  }

  fetchUserInfo() async {
    User getUser = FirebaseAuth.instance.currentUser!;
    userID = getUser.uid;
    if (getUser != null)
      await FirebaseFirestore.instance
          .collection("profilePhoto")
          .doc(userID)
          .get()
          .then((value) {
        url = value.get('imageURL');
      });
    await FirebaseFirestore.instance
        .collection('adminprofileList')
        .doc(userID)
        .get()
        .then((value) {
      name = value.get('name');
    });
  }

//csv
  getCsv() async {
    //create an element rows of type list of list. All the above data set are stored in associate list
//Let associate be a model class with attributes name,gender and age and associateList be a list of associate model class.
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
    ].request();

    List<List<dynamic>> rows = [];

    List<dynamic> row = [];

    row.add("Date");
    row.add("Index");
    row.add("SAP ID");
    row.add("Status");
    rows.add(row);
    for (int i = 0; i < data.length; i++) {
      List<dynamic> row = [];
      row.add(date.substring(6, date.indexOf("}")));
      row.add(i + 1);
      row.add(data[i].toString().substring(1, 12));
      row.add(data[i].toString().substring(14, 15));
      rows.add(row);
    }

    String csv = const ListToCsvConverter().convert(rows);

    String dir = await ExtStorage.getExternalStoragePublicDirectory(
        ExtStorage.DIRECTORY_DOWNLOADS);
    print("dir $dir");
    String file = "$dir";

    File f = File(file + "/finaldata.csv");

    f.writeAsString(csv);

    Fluttertoast.showToast(
      msg: "File Downloaded", // message
      toastLength: Toast.LENGTH_SHORT, // length
      gravity: ToastGravity.BOTTOM, // location
      // duration
    );
    Navigator.pop(context);

    setState(() {
      data.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final arg = ModalRoute.of(context)!.settings.arguments;
    code = arg.toString();
    return Scaffold(
      appBar: AppBar(
        title: Text("Report Download"),
        backgroundColor: ColorsUsed.appBarColor,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('teamList')
            .doc(code)
            .collection('theory_attendance')
            .snapshots(),
        // path to collection of documents that is listened to as a stream
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            List<String> theory_docs = [];
            for (int i = 0; i < snapshot.data!.docs.length; i++) {
              DocumentSnapshot snap = snapshot.data!.docs[i];

              theory_docs.add(snap.id);
            }
            var selectedData;
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FutureBuilder(
                    future: fetchUserInfo(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return Container(
                          child: CircleAvatar(
                              radius: 60, backgroundImage: NetworkImage(url)),
                        );
                      } else {
                        return CircularProgressIndicator();
                      }
                    },
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(15),
                      child: Text(
                        "Professor:",
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.bold,
                          color: ColorsUsed.uiColor,
                          fontSize: 22,
                        ),
                      ),
                    ),
                    FutureBuilder(
                        future: fetchUserInfo(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            return Text(
                              "$name",
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                color: ColorsUsed.uiColor,
                                fontSize: 20,
                              ),
                            );
                          } else {
                            return CircularProgressIndicator();
                          }
                        }),
                  ]),
                  Row(children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(15),
                      child: Text(
                        "Subject:",
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.bold,
                          color: ColorsUsed.uiColor,
                          fontSize: 22,
                        ),
                      ),
                    ),
                    FutureBuilder(
                        future: fetchSubject(code),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            return Text(
                              "$subject",
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                color: ColorsUsed.uiColor,
                                fontSize: 20,
                              ),
                            );
                          } else {
                            return CircularProgressIndicator();
                          }
                        }),
                  ]),
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(15),
                        child: Text(
                          "Lecture No:",
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.bold,
                            color: ColorsUsed.uiColor,
                            fontSize: 22,
                          ),
                        ),
                      ),
                      DropdownButton<String>(
                        items: theory_docs.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        value: selectedData,
                        onChanged: (theory) async {
                          theory_doc = theory!;
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => D_CSV(),
                          //         settings: RouteSettings(
                          //             arguments: Download(code, theory!))));

                          // await teamList
                          //     .doc(code)
                          //     .collection('theory_attendance')
                          //     .doc(theory)
                          //     .collection('data')
                          //     .get()
                          //     .then((querySnapshot) {
                          //   querySnapshot.docs.forEach((element) {
                          //     data.add(element.data().toString());
                          //   });
                          // });
                          // print(data);

                          final snackbar = SnackBar(
                            content: Text("Selected value: $theory"),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackbar);

                          setState(() {
                            selectedData = theory.toString();
                            data.clear();
                          });
                        },
                        isExpanded: false,
                        hint: Text(
                          "Choose lecture ",
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                    ],
                  ),

                  //download
                  TextButton(
                    style: ButtonStyle(
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.blue),
                    ),
                    onPressed: () async {
                      print(theory_doc);
                      await teamList
                          .doc(code)
                          .collection('theory_attendance')
                          .doc(theory_doc.toString())
                          .collection('data')
                          .get()
                          .then((querySnapshot) {
                        querySnapshot.docs.forEach((element) {
                          data.add(element.data().toString());
                        });
                      });

                      await teamList
                          .doc(code)
                          .collection('theory_attendance')
                          .doc(theory_doc.toString())
                          .get()
                          .then((querySnapshot) {
                        date = querySnapshot.data().toString();
                      });

                      print(date);
                      print(data);
                      getCsv();
                    },
                    child: Text('Download'),
                  )
                ],
              ),
            );
          } else {
            return Text("No data");
          }
        },
      ),
    );
  }
}

class Download {
  final String code;
  final String theory;

  Download(this.code, this.theory);
}
