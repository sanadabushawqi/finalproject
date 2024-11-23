import 'package:flutter/material.dart';

import '../Models/User.dart';
import '../Utils/DB.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key,});







  @override
  State<RegisterScreen> createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterScreen> {
  int _counter = 0;
  final TextEditingController _txtEmail = TextEditingController();
  final TextEditingController _txtPassword = TextEditingController();
  final TextEditingController _txtFirstName = TextEditingController();
  final TextEditingController _txtLastName = TextEditingController();
  final TextEditingController _txtStudentID = TextEditingController();
  final TextEditingController _txtPhone = TextEditingController();
  final TextEditingController _txtID = TextEditingController();
  final TextEditingController _txtBirthDate = TextEditingController();
  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(""),
      ),
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
            Text(
            'First name',
          ),
          TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'First name',
            ),
            controller: _txtFirstName,
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
            controller: _txtPassword,
          ),
          Text(
            'Last name',
          ),
          TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: ' Last name',
            ),
            controller: _txtLastName,
          ),
          Text(
            'Student ID',
          ),
          TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: ' Student id',
            ),
            controller: _txtStudentID,
          ),
          Text(
            'phone',
          ),
          TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: ' phone',
            ),
            controller: _txtPhone,
          ),
          Text(
            'ID',
          ),
          TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: ' ID',
            ),
            controller: _txtID,
          ),
          Text(
            'birthDate',
          ),
          TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: ' birthDate',
            ),
            controller: _txtBirthDate,
          ),
              TextButton(onPressed: () {
                var user = new User();
                user.firstName = _txtFirstName.text;
                user.lastName = _txtLastName.text;
                user.password = _txtPassword.text;
                insertUser(user);
              }, child: Text("register"))
        ],),
      ),
    );
  }
}
