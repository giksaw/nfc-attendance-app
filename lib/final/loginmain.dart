
import 'package:attend2/final/loginTeacherf.dart';
import 'package:attend2/final/loginstudentf.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(LoginPagef());
}

class LoginPagef extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Page',
      home: Scaffold(
        body: LoginBodyf(),
      ),
    );
  }
}

class LoginBodyf extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Background Image
        Expanded(
          child: Image.asset(
            'assets/loginmainbg.jpg',
            fit: BoxFit.cover,
            width: double.infinity,
          ),
        ),
        // Content
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App Name and Description

              Column(
                children: [
                  Text(
                    'Attend',
                    style: TextStyle(
                      fontSize: 60,
                      fontFamily:
                          'Montserrat', // You might need to import this font
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      // foreground: Paint()
                      //   ..style = PaintingStyle.stroke
                      //   ..strokeWidth = 2
                      //   ..color = Colors.white,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Attendance made simpler',
                    style: TextStyle(
                      fontSize: 24,
                      fontFamily:
                          'OpenSans', // You might need to import this font
                      fontWeight: FontWeight.w300,
                      color: Colors.black,
                      letterSpacing: 2.0,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20),
              // Buttons

              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Handle Client Button
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => StudentLoginPage(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green, // Background color
                        foregroundColor: Colors.white, // Text color
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(30.0), // Rounded corners
                        ),
                        padding: EdgeInsets.symmetric(
                            horizontal: 30, vertical: 15), // Increased padding
                        elevation: 5, // Button shadow
                      ),
                      child: Text(
                        'Client',
                        style: TextStyle(
                          fontSize: 18, // Increased font size
                          fontWeight: FontWeight.bold, // Bold text
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Handle Host Button
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => teacherloginf(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue, // Background color
                        foregroundColor: Colors.white, // Text color
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(30.0), // Rounded corners
                        ),
                        padding: EdgeInsets.symmetric(
                            horizontal: 30, vertical: 15), // Increased padding
                        elevation: 5, // Button shadow
                      ),
                      child: Text(
                        'Host',
                        style: TextStyle(
                          fontSize: 18, // Increased font size
                          fontWeight: FontWeight.bold, // Bold text
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
