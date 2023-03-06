import 'package:flutter/material.dart';
import 'package:image_firebase/admin/colors.dart';
import 'package:image_firebase/admin/practical_csv.dart';

import 'package:image_firebase/admin/report.dart';
// import 'dart:html';
import 'package:image_firebase/admin/theory_csv.dart';

class Button extends StatefulWidget {
  const Button({Key? key}) : super(key: key);

  @override
  State<Button> createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  String prac = "";
  @override
  Widget build(BuildContext context) {
    final arg = ModalRoute.of(context)!.settings.arguments;
    prac = arg.toString();
    print(prac);
    return Scaffold(
        backgroundColor: ColorsUsed.backgroundColor,
        appBar: AppBar(
            title: Text("Theory"), backgroundColor: ColorsUsed.appBarColor),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Padding(padding: EdgeInsets.all(50)),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "images/theory.jpeg",
                      height: 150,
                      width: 150,
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
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => THEORY_CSV(),
                                settings:
                                    RouteSettings(arguments: prac.toString())));
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(padding: EdgeInsets.all(15)),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "images/practical.jpeg",
                      height: 150,
                      width: 150,
                    ),
                      TextButton(
                  style:ButtonStyle(foregroundColor: MaterialStateProperty.all<Color>(ColorsUsed.uiColor)
                  ), 
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PRACTICAL_CSV(),
                                settings:
                                    RouteSettings(arguments: prac.toString())));
                      },
                     
                      child: Text(
                        "Practical Attendance",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
