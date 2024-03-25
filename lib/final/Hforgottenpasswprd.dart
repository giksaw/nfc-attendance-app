import 'package:attend2/bloc/services/api.dart';
import 'package:attend2/final/loginTeacherf.dart';
import 'package:flutter/material.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Forgot Password',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       home: ForgotPasswordPage(),
//     );
//   }
// }

class hForgotPasswordPage extends StatefulWidget {
  @override
  _hForgotPasswordPageState createState() => _hForgotPasswordPageState();
}

class _hForgotPasswordPageState extends State<hForgotPasswordPage> {
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  // void _resetPassword() {
  //   String id = _emailController.text;
  //   // Implement your logic to send password reset link to the provided email
  //   print('Reset Password for Email: $id');
  //   // Here you can send an email or navigate to a confirmation page
  //   // For demonstration purposes, we are just printing the email to reset
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          // title: Text('Forgot Password'),
          ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Forgot Password?',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Enter ID',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
            ),
            SizedBox(height: 24.0),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  //  _registerUser(context);
                  Hforget(context);
                  // Navigator.of(context).push(
                  //   MaterialPageRoute(
                  //       builder: (context) => const teacherloginf()),
                  // );
                },
                child: Text('Reset Password'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void Hforget(BuildContext context) async {
    var id = _emailController.text;

    var type = "host";

    var pdata = {
      "id": id,
      "type": type,
    };
    print("Message: $pdata");
    try {
      var response = await Api.forgotpas(pdata);
      var msg = response.getMsg();

      print("Message: $msg");

      if (msg == 'reset password link sent') {
        // If successful, navigate to the next page
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Success'),
              content: Text(msg),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => teacherloginf(),
                      ),
                    );
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        // Display a popup message with the error message
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text(msg),
              actions: [
                TextButton(
                  onPressed: () {
                  Navigator.of(context).pop();
                },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      print('Error registering user: $e');
      // Display a generic error message
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('An error occurred'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }
}
