import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_firebase/DatabaseManager/DatabaseManager.dart';
import 'package:image_firebase/ServiceManager/AuthenticationService.dart';
import 'package:image_firebase/admin/colors.dart';
import 'package:image_firebase/admin/profile.dart';
import 'package:image_firebase/main.dart';
import 'package:image_picker/image_picker.dart';

class EditInfoStudent extends StatefulWidget {
  const EditInfoStudent({Key? key}) : super(key: key);

  @override
  State<EditInfoStudent> createState() => _EditInfoStudentState();
}

class _EditInfoStudentState extends State<EditInfoStudent> {
  final AuthenticationService _auth = AuthenticationService();

  TextEditingController _genderContoller = TextEditingController();
  TextEditingController _yearController = TextEditingController();
  TextEditingController _departmentContoller = TextEditingController();
  TextEditingController _semesterController = TextEditingController();
  TextEditingController _sapController = TextEditingController();

  String userID = "";
  File? image;
  String url = "";
  final ImagePicker _picker = ImagePicker();
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
      String userID) async {
    await DatabaseManager()
        .updateUserList(gender, ad_year, department, semester, userID);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Information Screen"),
        backgroundColor: ColorsUsed.appBarColor,
      ),
      body: Column(children: [
        SizedBox(
          height: 30,
        ),
        Center(
          child: CircleAvatar(
            radius: 60,
            backgroundImage: image != null
                ? FileImage(File(image!.path))
                : AssetImage("images/a1.jpg") as ImageProvider,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 0, bottom: 0, left: 80),
          child: InkWell(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: ((builder) => bottom()),
                );
              },
              child: const Icon(Icons.camera_alt,
                  color: Colors.black, size: 28.0)),
        ),
        Padding(
          padding: EdgeInsets.all(20),
          child: TextField(
            controller: _genderContoller,
            decoration: InputDecoration(
                icon: Icon(
                  Icons.person,
                  color: ColorsUsed.uiColor,
                ),
                border: OutlineInputBorder(),
                labelText: 'Enter Gender',
                hintText: 'Enter Your Gender'),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(20),
          child: TextField(
            controller: _yearController,
            decoration: InputDecoration(
                icon: Icon(
                  Icons.timeline,
                  color: ColorsUsed.uiColor,
                ),
                border: OutlineInputBorder(),
                labelText: 'Enter Year',
                hintText: 'Enter Your Year'),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(20),
          child: TextField(
            controller: _departmentContoller,
            decoration: InputDecoration(
                icon: Icon(
                  Icons.corporate_fare_outlined,
                  color: ColorsUsed.uiColor,
                ),
                border: OutlineInputBorder(),
                labelText: 'Enter Department',
                hintText: 'Enter Your Department'),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(20),
          child: TextField(
            controller: _semesterController,
            decoration: InputDecoration(
                icon: Icon(
                  Icons.note_alt_outlined,
                  color: ColorsUsed.uiColor,
                ),
                border: OutlineInputBorder(),
                labelText: 'Enter Your Semester',
                hintText: 'Enter Your Semester'),
          ),
        ),
        SizedBox(
          height: 30,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
                  style:ButtonStyle(foregroundColor: MaterialStateProperty.all<Color>(ColorsUsed.uiColor)
                  ), 
              child: Text('Update', style: TextStyle(color: Colors.white)),
              onPressed: () {
                uploadfile();
                submitAction(context);
                Fluttertoast.showToast(
                  msg: "Profile Updated", // message
                  toastLength: Toast.LENGTH_SHORT, // length
                  gravity: ToastGravity.BOTTOM, // location
                  // duration
                );
                Navigator.pop(context);
              },
            
            ),
             TextButton(
                  style:ButtonStyle(foregroundColor: MaterialStateProperty.all<Color>(ColorsUsed.uiColor)
                  ), 
              child: Text('Cancel', style: TextStyle(color: Colors.white)),
              onPressed: () {
                Navigator.pop(context);
              },
              
            )
          ],
        ),
      ]),
    );
  }

  submitAction(BuildContext context) {
    updateData(_genderContoller.text, int.parse(_yearController.text),
        _departmentContoller.text, int.parse(_semesterController.text), userID);
    _genderContoller.clear();
    _yearController.clear();
    _departmentContoller.clear();
    _semesterController.clear();
  }

  uploadfile() async {
    String name = DateTime.now().millisecondsSinceEpoch.toString();
    var imageFile = FirebaseStorage.instance.ref().child(name).child("/.jpg");
    UploadTask task = imageFile.putFile(image!);
    TaskSnapshot snapshot = await task;
    url = await snapshot.ref.getDownloadURL();
    await FirebaseFirestore.instance
        .collection("profilePhoto")
        .doc(userID)
        .set({"imageURL": url});
    print(url);
  }

  void takePhoto(ImageSource source) async {
    final pickedFile = await _picker.pickImage(
      source: source,
    );
    setState(() {
      image = File(pickedFile!.path);
    });
  }

  Widget bottom() {
    return SizedBox(
      height: 100.0,
      width: 300.0,
      child: Column(children: <Widget>[
        const Text("Choose Profile Photo"),
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextButton.icon(
                onPressed: () {
                  takePhoto(ImageSource.camera);
                },
                icon: const Icon(Icons.camera),
                label: const Text("Camera")),
            TextButton.icon(
                onPressed: () {
                  takePhoto(ImageSource.gallery);
                },
                icon: const Icon(Icons.image),
                label: const Text("Gallery "))
          ],
        )
      ]),
    );
  }
}
