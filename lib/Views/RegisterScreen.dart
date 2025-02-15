import 'package:flutter/material.dart';
import 'package:untitled/Models/Student.dart';
import 'package:untitled/Models/Student.dart';
import 'package:untitled/Utils/Utils.dart';
import 'package:untitled/Utils/constants.dart';
import '../Models/Student.dart';
import '../Models/User.dart';
import '../Utils/DB.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../Utils/clientConfeg.dart';
import 'teacherhomepage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _CreadtedDateTimeController = TextEditingController();
  final _userIDController = TextEditingController();

  bool _isSubmitting = false;
  bool _registrationSuccessful = false;

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    if (!emailRegex.hasMatch(value)) {
      return 'Invalid email format';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    return null;
  }
  String? _validatefirstName(String? value) {
    if (value == null || value.isEmpty) {
      return 'firstName is required';
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    if (!emailRegex.hasMatch(value)) {
      return 'Invalid firstName format';
    }
    return null;
  }
  String? _validatelastName(String? value) {
    if (value == null || value.isEmpty) {
      return 'lastName is required';
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    if (!emailRegex.hasMatch(value)) {
      return 'Invalid lastName format';
    }
    return null;
  }
  String? _validateuserID(String? value) {
    if (value == null || value.isEmpty) {
      return 'userID is required';
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    if (!emailRegex.hasMatch(value)) {
      return 'Invalid userID format';
    }
    return null;
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSubmitting = true;
      });

      try {
        // Simulated registration process
        await Future.delayed(const Duration(seconds: 2));
        setState(() {
          _registrationSuccessful = true;
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registration failed')),
        );
      } finally {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Future insertUser(BuildContext context, String firstName, String lastName, String email) async {

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? getInfoDeviceSTR = prefs.getString("getInfoDeviceSTR");
      var url = "users/insertUser.php?firstName=" + firstName + "&lastName=" + lastName + "&userID=" + '11' + "&email=" + email  + getInfoDeviceSTR!;
      final response = await http.get(Uri.parse(serverPath + url));
      // print(serverPath + url);
      setState(() { });
      Navigator.pop(context);
    }
    if (_registrationSuccessful) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 100,
              ),
              const SizedBox(height: 20),
              const Text(
                'Registration Successful!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _registrationSuccessful = false;
                  });
                },
                child: const Text('Back to Registration'),
              ),
            ],
          ),
        ),
      ).animate().fadeIn();
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor:appBarcolor,
        title: Text(""),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFE6F2FF),
              Color(0xFFF0E6FF),
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.person_add,
                          size: 60,
                          color: Colors.blue,
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Create Account',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          controller: _firstNameController,
                          decoration: InputDecoration(
                            labelText: 'first Name',
                            prefixIcon: const Icon(Icons.person),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          validator: _validatefirstName,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          controller: _lastNameController,
                          decoration: InputDecoration(
                            labelText: 'lastName',
                            prefixIcon: const Icon(Icons.person),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          validator: _validatelastName,
                          keyboardType: TextInputType.emailAddress,
                        ),

                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _userIDController,
                          decoration: InputDecoration(
                            labelText: 'User ID',
                            prefixIcon: const Icon(Icons.person),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'User ID is required';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            prefixIcon: const Icon(Icons.email),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          validator: _validateEmail,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          controller: _CreadtedDateTimeController,
                          decoration: InputDecoration(
                            labelText: 'Creadted Date Time',
                            prefixIcon: const Icon(Icons.person),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          validator: _validatefirstName,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            prefixIcon: const Icon(Icons.lock),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          validator: _validatePassword,
                          obscureText: true,
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          controller: _confirmPasswordController,
                          decoration: InputDecoration(
                            labelText: 'Confirm Password',
                            prefixIcon: const Icon(Icons.lock),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          validator: (value) {
                            if (value != _passwordController.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                          obscureText: true,
                        ),
                        const SizedBox(height: 20),

                        ElevatedButton(
                          onPressed:() {
                              _isSubmitting ? null : _submitForm;
                              //dasdasdadsfsdgghfdg
                            var user = new User();
                            user.firstName = _firstNameController.text;
                              user.lastName = _lastNameController.text;
                              user.email = _emailController.text;
                              user.userID = _userIDController.text;
                              user.createdDateTime = _CreadtedDateTimeController.text;
                            user.password = _passwordController.text;
                            insertUser(context,_firstNameController.text,_lastNameController.text, _emailController.text);
                            Navigator.push(context, MaterialPageRoute(builder: (context) => teacherHomeScreen()));
                            },
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: _isSubmitting
                              ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                              : const Text(
                            'Register',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        const SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Already have an account?'),
                            TextButton(
                              onPressed: () {
                                // Navigate to login page
                              },
                              child: const Text('Log In'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    ).animate().fadeIn();
  }
}