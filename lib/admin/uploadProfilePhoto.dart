import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_firebase/DatabaseManager/DatabaseManager.dart';
import 'package:image_firebase/ServiceManager/AuthenticationService.dart';
import 'package:image_firebase/admin/colors.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class ProfilePhoto extends StatefulWidget {
  const ProfilePhoto({Key? key}) : super(key: key);

  @override
  State<ProfilePhoto> createState() => _ProfilePhotoState();
}

class _ProfilePhotoState extends State<ProfilePhoto> {
  File? image;
  String url = "";
  final ImagePicker _picker = ImagePicker();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: ColorsUsed.appBarColor,
          title: Text("Upload Profile")),
      body: Column(
        children: <Widget>[
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
          Expanded(
              child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(15),
                  child: TextField(
                    controller: _sapController,
                    decoration: InputDecoration(
                      icon: Icon(Icons.verified_user),
                      border: OutlineInputBorder(),
                      labelText: 'SAP ID',
                      hintText: 'Enter SAP ID',
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: EdgeInsets.all(15),
                  child: TextField(
                    controller: _genderContoller,
                    decoration: InputDecoration(
                      icon: Icon(Icons.person),
                      border: OutlineInputBorder(),
                      labelText: 'Gender',
                      hintText: 'Enter Gender',
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: EdgeInsets.all(15),
                  child: TextField(
                    controller: _departmentContoller,
                    decoration: InputDecoration(
                      icon: Icon(Icons.corporate_fare_outlined),
                      border: OutlineInputBorder(),
                      labelText: 'Department',
                      hintText: 'Enter Department',
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                   TextButton(
                      child: Text('Update',
                          style: TextStyle(
                            color: Colors.white,
                          )),
                      onPressed: () {
                        uploadfile();
                        submitAction(context);
                      },
                      
                    ),
                   TextButton(
                      child: Text('Cancel',
                          style: TextStyle(
                            color: Colors.white,
                          )),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      )
                  ],
                ),
              ],
            ),
          ))
        ],
      ),
    );
  }

  updateData(
      String gender, String department, double sap_id, String userID) async {
    await DatabaseManager().updateAdminList(gender, department, sap_id, userID);
  }

  submitAction(BuildContext context) {
    updateData(_genderContoller.text, _departmentContoller.text,
        double.parse(_sapController.text), userID);
    _genderContoller.clear();

    _departmentContoller.clear();
    _sapController.clear();
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
