import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_firebase/ServiceManager/AuthenticationService.dart';
import 'package:image_firebase/admin/admin_login.dart';
import 'package:image_firebase/admin/colors.dart';

class RegistrationScreenStudent extends StatefulWidget {
  @override
  _RegistrationScreenStudentState createState() =>
      _RegistrationScreenStudentState();
}

class _RegistrationScreenStudentState extends State<RegistrationScreenStudent> {
  final AuthenticationService _auth = AuthenticationService();

  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailContoller = TextEditingController();
  TextEditingController _sapContoller = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmpasswordController = TextEditingController();

  Widget _buildName() {
    return Padding(
      padding: EdgeInsets.all(5),
      child: TextFormField(
        keyboardType: TextInputType.text,
        controller: _nameController,
        decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.person,
              color: ColorsUsed.uiColor,
            ),
            labelText: 'Name'),
      ),
    );
  }

  Widget _buildlogo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(bottom: 0),
          child: Text(
            "Attendance Buddy",
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.height / 25,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmail() {
    return Padding(
      padding: EdgeInsets.all(5),
      child: TextFormField(
        keyboardType: TextInputType.emailAddress,
        controller: _emailContoller,
        decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.email,
              color: ColorsUsed.uiColor,
            ),
            labelText: 'E-mail'),
      ),
    );
  }

  Widget _buildPassword() {
    return Padding(
      padding: EdgeInsets.all(5),
      child: TextFormField(
        keyboardType: TextInputType.text,
        obscureText: true,
        controller: _passwordController,
        decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.lock,
              color: ColorsUsed.uiColor,
            ),
            labelText: 'Password'),
      ),
    );
  }

  Widget _buildsap() {
    return Padding(
      padding: EdgeInsets.all(5),
      child: TextFormField(
        keyboardType: TextInputType.text,
        controller: _sapContoller,
        decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.domain_verification,
              color: ColorsUsed.uiColor,
            ),
            labelText: 'SAP ID'),
      ),
    );
  }

  Widget _buildConfirmPassword() {
    return Padding(
      padding: EdgeInsets.all(5),
      child: TextFormField(
        keyboardType: TextInputType.text,
        obscureText: true,
        controller: _confirmpasswordController,
        decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.lock,
              color: ColorsUsed.uiColor,
            ),
            labelText: 'Confirm Password'),
      ),
    );
  }

  Widget _buildContainer() {
    return Expanded(
        child: SingleChildScrollView(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.72,
              width: MediaQuery.of(context).size.width * 0.86,
              decoration: BoxDecoration(
                color: ColorsUsed.backgroundColor,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Sign - Up",
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.height / 30,
                        ),
                      )
                    ],
                  ),
                  _buildName(),
                  _buildEmail(),
                  _buildsap(),
                  _buildPassword(),
                  _buildConfirmPassword(),
                  _buildSignUpButton(),
                  _buildOrRow(),
                  _buildLoginButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    ));
  }

  Widget _buildSignUpButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          height: 1.4 * (MediaQuery.of(context).size.height / 20),
          width: 4 * (MediaQuery.of(context).size.width / 10),
          margin: EdgeInsets.only(bottom: 20, top: 30),
          child: ElevatedButton(
           
            onPressed: () {
              createUser();
            },
            child: Text(
              "Sign - Up",
              style: TextStyle(
                color: Colors.white,
                letterSpacing: 1.5,
                fontSize: MediaQuery.of(context).size.height / 40,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 5),
          child: TextButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => LoginScreen()));
            },
            child: RichText(
              text: TextSpan(children: [
                TextSpan(
                  text: "Already Have An Account?",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: MediaQuery.of(context).size.height / 40,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                TextSpan(
                  text: "Log In",
                  style: TextStyle(
                    color: Color.fromARGB(255, 105, 128, 221),
                    fontSize: MediaQuery.of(context).size.height / 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ]),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOrRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 5),
          child: Text(
            "-OR-",
            style: TextStyle(
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Color(0xfff2f3f7),
      appBar: AppBar(
        title: Text("Registration Screen"),
        backgroundColor: ColorsUsed.appBarColor,
      ),
      body: Stack(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height * 0.7,
            width: MediaQuery.of(context).size.width,
            child: Container(
              decoration: BoxDecoration(
                color: ColorsUsed.uiColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: const Radius.circular(70),
                  bottomRight: const Radius.circular(70),
                ),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _buildlogo(),
              _buildContainer(),
              // _buildLoginButton(),
              // _buildOrRow(),
            ],
          ),
        ],
      ),
    );
  }

  void createUser() async {
    if (_passwordController.text.length > 6) {
      if (_passwordController.text == _confirmpasswordController.text) {
        if (_sapContoller.text.length > 10 && _sapContoller.text.length < 12) {
          dynamic result = await _auth.createNewUser(
              _nameController.text,
              _emailContoller.text,
              _passwordController.text,
              double.parse(_sapContoller.text));

          if (result == null) {
            Fluttertoast.showToast(
              msg: "Email is not valid", // message
              toastLength: Toast.LENGTH_SHORT, // length
              gravity: ToastGravity.BOTTOM, // location
              // duration
            );
            print('Email is not valid');
          } else {
            Fluttertoast.showToast(
              msg: "Prolie created", // message
              toastLength: Toast.LENGTH_SHORT, // length
              gravity: ToastGravity.BOTTOM, // location
              // duration
            );
            print(result.toString());
            _nameController.clear();
            _passwordController.clear();
            _emailContoller.clear();
            _sapContoller.clear();
            Navigator.pop(context);
          }
        } else {
          Fluttertoast.showToast(
            msg: "Incorrect SAP ID", // message
            toastLength: Toast.LENGTH_SHORT, // length
            gravity: ToastGravity.BOTTOM, // location
            // duration
          );
        }
      } else {
        Fluttertoast.showToast(
          msg: "Password do not match", // message
          toastLength: Toast.LENGTH_SHORT, // length
          gravity: ToastGravity.BOTTOM, // location
          // duration
        );
      }
    } else {
      Fluttertoast.showToast(
        msg: "Password length should be greate than 6", // message
        toastLength: Toast.LENGTH_SHORT, // length
        gravity: ToastGravity.BOTTOM, // location
        // duration
      );
    }
  }
}
