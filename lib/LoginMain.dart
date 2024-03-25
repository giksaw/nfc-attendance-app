import 'package:attend2/LoginStudent.dart';
import 'package:attend2/LoginTeacher.dart';
import 'package:flutter/material.dart';

class LoginMain extends StatefulWidget {
  const LoginMain({super.key});

  @override
  _LoginMainState createState() => _LoginMainState();
}

class _LoginMainState extends State<LoginMain> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Set background color to black
      body: Center(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 200, bottom: 150),
              child: Text(
                'AttenD', // Main Heading
                style: TextStyle(
                    color: Colors.white, // Text color is white
                    fontSize: 48, // Increased font size for main heading
                    fontWeight: FontWeight.bold,
                    backgroundColor: Color.fromARGB(255, 0, 0, 0)),
              ),
            ),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildUserButton(
                  'Host',
                  loginTeacher(),
                ),
                _buildUserButton(
                  'Client',
                  loginStudent(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserButton(String text, Widget page) {
    return ElevatedButton(
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => page),
        );
      },
      style: ElevatedButton.styleFrom(
        // primary: Colors.white, // Button background color
        // onPrimary: Colors.black, // Text color
        minimumSize: Size(150, 50), // Button size
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 24, // Font size for button text
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
