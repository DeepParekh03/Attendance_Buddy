import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_firebase/admin/colors.dart';
import 'package:image_firebase/student/student_registration.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:image_firebase/ServiceManager/AuthenticationService.dart';
import 'package:image_firebase/student/bottombar_student.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    initialRoute: '/login',
    routes: {
      '/login': (context) => LoginScreenStudent(),
      '/register': (context) => RegistrationScreenStudent(),
    },
  ));
}

class LoginScreenStudent extends StatefulWidget {
  const LoginScreenStudent({Key? key}) : super(key: key);

  @override
  State<LoginScreenStudent> createState() => _LoginScreenStudentState();
}

class _LoginScreenStudentState extends State<LoginScreenStudent> {
  final AuthenticationService _auth = AuthenticationService();

  TextEditingController _emailContoller = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  Widget _buildlogo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(bottom: 30),
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
      padding: EdgeInsets.all(8),
      child: TextFormField(
        controller: _emailContoller,
        keyboardType: TextInputType.emailAddress,
        onChanged: (value) {
          // setState(() {
          //   _emailContoller.text = value;
          // });
        },
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
      padding: EdgeInsets.all(8),
      child: TextFormField(
        controller: _passwordController,
        keyboardType: TextInputType.text,
        obscureText: true,
        onChanged: (value) {
          // setState(() {
          //   _passwordController.text = value;
          // });
        },
        decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.lock,
              color: ColorsUsed.uiColor,
            ),
            labelText: 'Password'),
      ),
    );
  }

  Widget _buildContainer() {
    return SingleChildScrollView(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.6,
              width: MediaQuery.of(context).size.width * 0.8,
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
                        "Login",
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.height / 30,
                        ),
                      )
                    ],
                  ),
                  _buildEmail(),
                  _buildPassword(),
                  _buildLoginButton(),
                  _buildOrRow(),
                  _buildSignUpButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          height: 1.4 * (MediaQuery.of(context).size.height / 20),
          width: 5 * (MediaQuery.of(context).size.width / 10),
          margin: EdgeInsets.only(bottom: 20, top: 30),
          child: ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Processing Data')));
              signInUser();
            },
            child: Text(
              "Login",
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

  Widget _buildSignUpButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 15),
          child: TextButton(
            onPressed: () {
              Navigator.of(context).push(CupertinoPageRoute(
                  fullscreenDialog: true,
                  builder: (context) => RegistrationScreenStudent()));
            },
            child: RichText(
              text: TextSpan(children: [
                TextSpan(
                  text: "Dont have an account?",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: MediaQuery.of(context).size.height / 40,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                TextSpan(
                  text: "SignUP",
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
          margin: EdgeInsets.only(top: 17),
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
    future:
    Firebase.initializeApp();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xfff2f3f7),
      appBar: AppBar(
        title: Text("Login Screen"),
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

  void signInUser() async {
    dynamic authResult =
        await _auth.loginUser(_emailContoller.text, _passwordController.text);
    if (authResult == null) {
      Fluttertoast.showToast(
        msg: "Incorrect Email or Password", // message
        toastLength: Toast.LENGTH_SHORT, // length
        gravity: ToastGravity.BOTTOM, // location
        // duration
      );
      print('Sign in error. could not be able to login');
    } else {
      Fluttertoast.showToast(
        msg: "Logged in successfully", // message
        toastLength: Toast.LENGTH_SHORT, // length
        gravity: ToastGravity.BOTTOM, // location
        // duration
      );
      _emailContoller.clear();
      _passwordController.clear();
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => BottomBarStudent()));
    }
  }
}
