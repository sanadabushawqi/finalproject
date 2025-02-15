import 'package:flutter/material.dart';
import 'RegisterScreen.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue.shade400,
              Colors.blue.shade900,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              // App Logo
              Icon(
                Icons.car_rental,
                size: 100,
                color: Colors.white,
              ),
              const SizedBox(height: 24),
              // App Title
              const Text(
                "Welcome to\nDriving Learning App",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              // App Description
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  "Start your journey to learn driving with the best professional instructors",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
              ),
              const Spacer(),
              // Navigation Buttons
              Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  children: [
                    // Teacher Button
                    ElevatedButton(
                      onPressed: () {
                        // Navigate to teacher page
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.blue.shade900,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 48,
                          vertical: 16,
                        ),
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: TextButton(
                        onPressed: () => {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterPage()))
                        },
                        child: const Text("Start as Teacher",
                          style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        )),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Student Button
                    ElevatedButton(
                      onPressed: () {
                        // Navigate to student page
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade900,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 48,
                          vertical: 16,
                        ),
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: const BorderSide(color: Colors.white, width: 2),
                      ),
                      child: const Text(
                        "Start as Student",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}