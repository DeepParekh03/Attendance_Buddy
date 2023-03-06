// import 'dart:html';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:image_firebase/admin/colors.dart';

void main() {
  runApp(const email());
}

class email extends StatefulWidget {
  const email({Key? key}) : super(key: key);

  @override
  State<email> createState() => _emailState();
}

final nameController = TextEditingController();
final subjectController = TextEditingController();
final emailController = TextEditingController();
final messageController = TextEditingController();

Future sendEmail() async {
  final url = Uri.parse("https://api.emailjs.com/api/v1.0/email/send");
  const serviceID = "service_kctxbvi";
  const templateID = "template_vba304n";
  const userID = "ZO4u19w32GcMIW90W";
  final response = await http.post(
    url,
    headers: {
      'origin': 'https://localhost',
      'Content-Type': 'application/json',
    },
    body: json.encode({
      "service_id": serviceID,
      "template_id": templateID,
      "user_id": userID,
      "template_params": {
        // "user_name": nameController.text,
        "to_email": emailController.text,
        // "user_subject": subjectController.text,
        "user_message": messageController.text,
      },
    }),
  );
  print(response.body);
}

class _emailState extends State<email> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: ColorsUsed.appBarColor,
          title: const Text("Email"),
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
          child: Form(
            child: Column(
              children: [
                // TextFormField(
                //   controller: nameController,
                //   decoration: const InputDecoration(
                //       icon: Icon(Icons.account_circle,
                //           color: Color.fromARGB(255, 48, 71, 94)),
                //       hintText: "Name",
                //       labelText: "Name"),
                // ),
                // const SizedBox(
                //   height: 10,
                // ),
                // TextFormField(
                //   controller: subjectController,
                //   decoration: const InputDecoration(
                //       icon: Icon(Icons.subject_rounded,
                //           color: Color.fromARGB(255, 48, 71, 94)),
                //       hintText: "Subject",
                //       labelText: "Subject"),
                // ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                      icon: Icon(Icons.email,
                          color: Color.fromARGB(255, 48, 71, 94)),
                      hintText: "Email",
                      labelText: "Email"),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: messageController,
                  decoration: const InputDecoration(
                      icon: Icon(Icons.message,
                          color: Color.fromARGB(255, 48, 71, 94)),
                      hintText: "Message",
                      labelText: "Message"),
                ),
                const SizedBox(
                  height: 15,
                ),
                  TextButton(
                  style:ButtonStyle(foregroundColor: MaterialStateProperty.all<Color>(ColorsUsed.uiColor)
                  ), 
                  onPressed: () {
                    sendEmail();
                  },
                  child: Text(
                    "send",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
