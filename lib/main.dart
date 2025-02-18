import 'dart:io';

import 'package:flutter/material.dart';
import 'package:untitled/Models/User.dart';
import 'package:untitled/Utils/Utils.dart';
import 'package:untitled/Utils/constants.dart';
import 'package:untitled/Views/RegisterScreen.dart';

import 'Utils/DB.dart';
import 'Views/thefirstpage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home:  WelcomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  final TextEditingController _txtEmail = TextEditingController();
  final TextEditingController _txtpassword = TextEditingController();
  final TextEditingController _txtFirstname = TextEditingController();
  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarcolor,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'first name',
            ),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'First name',
              ),
              controller: _txtFirstname,
            ),
            Text(
              'Email',
            ),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: ' Email',
              ),
              controller: _txtEmail,
            ),
            Text(
              'password',
            ),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: ' password',
              ),
              controller: _txtpassword,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: () {
                      insertUser(new User());
                      Utils uti = new Utils();
                      uti.showMyDialog(context, _txtFirstname.text, _txtEmail.text);
                      // insertUser("firstName", "secondName", "passWord");
                    },
                    child: Text("log in")),
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RegisterPage()),
                      );
                    },
                    child: Text("sign up"))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
