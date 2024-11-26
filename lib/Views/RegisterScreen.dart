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
  int _counter = 0;
  final TextEditingController _txtEmail = TextEditingController();
  final TextEditingController _txtPassword = TextEditingController();
  final TextEditingController _txtFirstName = TextEditingController();
  final TextEditingController _txtLastName = TextEditingController();
  final TextEditingController _txtuserID = TextEditingController();
  final TextEditingController _txtcreatedDateTime = TextEditingController();


  void insertUserFunc()
  {
    if(_txtFirstName.text != "" && _txtEmail.text != "" && _txtPassword.text != "" && _txtLastName.text != "" && _txtuserID.text != "" && _txtcreatedDateTime.text != "" )
      {
        var user = new User();
        user.firstName = _txtFirstName.text;
        user.userID = _txtEmail.text;
        user.password = _txtPassword.text;
        user.lastName = _txtLastName.text;
        user.createdDateTime = _txtuserID.text;
        user.email = _txtEmail.text;
        insertUser(user);
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
            'ID',
          ),
          TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: ' ID',
            ),
            controller: _txtuserID,
          ),
          Text(
            'date time',
          ),
          TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: ' date time',
            ),
            controller: _txtcreatedDateTime,
          ),
              TextButton(
                  onPressed: () {
                      insertUserFunc();
                  },
                  child: Text("register"))
        ],),
      ),
    );
  }
}
