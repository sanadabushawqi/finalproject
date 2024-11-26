import 'package:flutter/material.dart';
import 'package:untitled/Models/Student.dart';
import 'package:untitled/Models/Student.dart';
import 'package:untitled/Utils/Utils.dart';
import '../Models/Student.dart';
import '../Models/User.dart';
import '../Utils/DB.dart';




class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key,});


  @override
  State<RegisterScreen> createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterScreen> {

  final TextEditingController _txtEmail = TextEditingController();
  final TextEditingController _txtPassword = TextEditingController();
  final TextEditingController _txtFirstName = TextEditingController();
  final TextEditingController _txtLastName = TextEditingController();
  final TextEditingController _txtStudentID = TextEditingController();
  final TextEditingController _txtPhone = TextEditingController();
  final TextEditingController _txtID = TextEditingController();
  final TextEditingController _txtBirthDate = TextEditingController();


  void insertUserFunc()
  {
    if(_txtFirstName.text != "" && _txtEmail.text != "" && _txtPassword.text != "" && _txtLastName.text != "" && _txtID.text != "" && _txtPhone.text != "" && _txtBirthDate.text != "")
      {
        var student = new Student();
        student.firstName = _txtFirstName.text;
        student.email = _txtEmail.text;
        student.password = _txtPassword.text;
        student.lastName = _txtLastName.text;
        student.ID = _txtID.text;
        student.phone = _txtPhone.text;
        student.birthDate = _txtBirthDate.text;
        inserStudent(student);
      }
    else
      {
        Utils uti = new Utils();
        uti.showMyDialog(context, "Required", "כל השדות חובה");


      }
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

                insertUserFunc();
              }, child: Text("register"))
        ],),
      ),
    );
  }
}
