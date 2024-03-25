import 'package:attend2/TeacherHome.dart';
import 'package:attend2/registerTeacher.dart';
import 'package:flutter/material.dart';

class loginTeacher extends StatefulWidget {
  const loginTeacher({Key? key}) : super(key: key);

  @override
  State<loginTeacher> createState() => _loginTeacherState();
}

class _loginTeacherState extends State<loginTeacher> {
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      // Set background color to black
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 75, bottom: 100),
              child: Text(
                'AttenD', // Main Heading
                style: TextStyle(
                  color: Colors.white, // Text color is white
                  fontSize: 48, // Increased font size for main heading
                  fontWeight: FontWeight.bold,
                  backgroundColor: Color.fromARGB(255, 0, 0, 0),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
                obscureText: true,
              ),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                // Implement your forgot password logic here
                print('Forgot Password');
              },
              child: const Text(
                'Forgot Password?',
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Implement your login logic here
                print('Username: ${_usernameController.text}');
                print('Password: ${_passwordController.text}');
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => teacherHome()),
                );
              },
              style: ElevatedButton.styleFrom(
                // primary: Colors.white,
                // onPrimary: Colors.black,
                minimumSize: Size(150, 50),
              ),
              child: const Text('Login'),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                 Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const RegisterTeacher(),
                  ),
                );
                // Implement your register logic here
                print('Register');
              },
              child: const Text(
                'Register',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
