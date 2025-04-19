import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Models/CheckLogin.dart';
import '../Utils/Utils.dart';
import '../Utils/clientConfeg.dart';
import 'StudentListPage.dart';
import 'package:http/http.dart' as http;



// This class defines a stateful login page widget
class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Form key for validation
  final _formKey = GlobalKey<FormState>();

  // Controllers for the text fields
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Variables for UI states
  bool _isPasswordVisible = false;
  bool _rememberMe = false;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    // Clean up controllers when the widget is disposed
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Method to handle login process
  Future<void> _login() async {

    //   SharedPreferences prefs = await SharedPreferences.getInstance();
    //  String? getInfoDeviceSTR = prefs.getString("getInfoDeviceSTR");
    var url = "login/checkLogin.php?email=" + _emailController.text + "&password=" + _passwordController.text;
    final response = await http.get(Uri.parse(serverPath + url));
    print(serverPath + url);
    // setState(() { });
    // Navigator.pop(context);
    if(checkLoginModel.fromJson(jsonDecode(response.body)).userID == 0)
    {
      // return 'ת.ז ו/או הסיסמה שגויים';
      var uti = new Utils();
      uti.showMyDialog(context, "error", "email or password is incorrect");
    }
    else
    {
      print("rrr:${checkLoginModel.fromJson(jsonDecode(response.body)).userID}");
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setInt('token', checkLoginModel.fromJson(jsonDecode(response.body)).userID!);
      // await prefs.setString('userType', checkLoginModel.fromJson(jsonDecode(response.body)).userTypeID!);
      // return null;

      Navigator.push(context, MaterialPageRoute(builder: (context) => teacherHomeScreen()));

    }


    // Hide any previous error messages
    // setState(() {
    //   _errorMessage = null;
    // });
    //
    // // Validate the form first
    // if (!_formKey.currentState!.validate()) {
    //   return;
    // }
    //
    // // Show loading indicator
    // setState(() {
    //   _isLoading = true;
    // });
    //
    // try {
    //   // Simulate network delay (In real app, you would connect to your database here)
    //   await Future.delayed(const Duration(seconds: 2));
    //
    //   // Here you would check credentials against your database
    //   // For now, we'll just return success for demo purposes
    //
    //   // If login is successful, navigate to home page
    //   // In a real app, you'd navigate to your home screen like this:
    //   // Navigator.of(context).pushReplacement(
    //   //   MaterialPageRoute(builder: (context) => HomePage()),
    //   // );
    //
    //   // For demo purposes, we'll just show a success message
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(
    //       content: Text('Login successful! Redirecting...'),
    //       backgroundColor: Colors.green,
    //     ),
    //   );
    //   Navigator.push(context, MaterialPageRoute(builder: (context) => teacherHomeScreen()));
    // } catch (e) {
    //   // Show error message if login fails
    //   setState(() {
    //     _errorMessage = 'Failed to login. Please check your credentials.';
    //   });
    // } finally {
    //   // Hide loading indicator
    //   setState(() {
    //     _isLoading = false;
    //   });
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // App Logo
                  Icon(
                    Icons.directions_car,
                    size: 80,
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(height: 16),

                  // App Name
                  Text(
                    'Driving Instructor',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Subtitle
                  const Text(
                    'Login to your account',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 48),

                  // Error message (if any)
                  if (_errorMessage != null) ...[
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red.shade200),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.error, color: Colors.red),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              _errorMessage!,
                              style: TextStyle(color: Colors.red.shade800),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Email Field
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      hintText: 'Enter your email',
                      prefixIcon: const Icon(Icons.email),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade50,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Password Field
                  TextFormField(
                    controller: _passwordController,
                    obscureText: !_isPasswordVisible,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      hintText: 'Enter your password',
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade50,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),

                  // Remember me & Forgot password
                  Row(
                    children: [
                      // Remember me checkbox
                      Checkbox(
                        value: _rememberMe,
                        onChanged: (value) {
                          setState(() {
                            _rememberMe = value ?? false;
                          });
                        },
                      ),
                      const Text('Remember me'),
                      const Spacer(),

                      // Forgot password button
                      TextButton(
                        onPressed: () {
                          // Navigate to forgot password page
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Forgot password functionality will be implemented later'),
                            ),
                          );
                        },
                        child: const Text('Forgot Password?'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Login Button
                  ElevatedButton(
                    onPressed: _isLoading ? null : _login,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                        :  Text(
                      'LOGIN',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Register Option
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account?"),
                      TextButton(
                        onPressed: () {
                          // Navigate to register page
                          // In a real app:
                          // Navigator.of(context).push(
                          //   MaterialPageRoute(builder: (context) => RegisterPage()),
                          // );
                          Navigator.push(context, MaterialPageRoute(builder: (context) => teacherHomeScreen()));

                          // For demo purposes
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Navigate to Register Page'),
                            ),
                          );
                        },
                        child: const Text('Register'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Example usage in main.dart
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Driving Instructor App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const LoginPage(),
    );
  }
}