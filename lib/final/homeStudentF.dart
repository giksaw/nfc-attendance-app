import 'dart:convert';

import 'package:attend2/bloc/model/checkattendance.dart';
import 'package:attend2/bloc/services/api.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Home Student',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomeStudentPage(
        ids: '',
      ),
    );
  }
}

class HomeStudentPage extends StatefulWidget {
  final String
      ids; // This should match the name of the variable in the constructor

  const HomeStudentPage({Key? key, required this.ids}) : super(key: key);
  @override
  _HomeStudentPageState createState() => _HomeStudentPageState();
}

class _HomeStudentPageState extends State<HomeStudentPage> {
  String _selectedDate = '';
  String _courseCode = '';
  String _greeting = '';
  late TextEditingController _dateController;

  @override
  void initState() {
    super.initState();
    _setGreeting();
    _dateController = TextEditingController();
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  void _setGreeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      setState(() {
        _greeting = 'Good morning';
      });
    } else if (hour < 17) {
      setState(() {
        _greeting = 'Good afternoon';
      });
    } else {
      setState(() {
        _greeting = 'Good evening';
      });
    }
  }

  void checkattendace(BuildContext context, String ids) async {
    var date = _selectedDate;
    var cc = _courseCode;

    var pdata = {"course": cc, "date": date, "id": ids}; // Pass ids here
    print(pdata);
    try {
      var response = await Api.checkATT(pdata);
      var msg = response.getMsg();

      print("Message: $msg");

      if (msg == 'client present') {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('success'),
              content: Text(msg),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomeStudentPage(
                            ids: ids), // Pass ids to HomeStudentPage
                      ),
                    );
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );

        // If successful, navigate to the next page
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) =>
        //         HomeStudentPage(ids: ids), // Pass ids to HomeStudentPage
        //   ),
        // );
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
      print('Error while trying to login user: $e');
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

  void viewAttendance(BuildContext context, String ids) async {
  var date = _selectedDate;
  var studentID = _courseCode;

  var pdata = {"id": studentID, "date": date}; // Pass ids here
  print(pdata);
  try {
    var response = await Api.viewATT(pdata);

    // This function returns a List<String> of courses attended or an empty list
    List<String> coursesAttended = await Api.viewATT(pdata);

    if (coursesAttended.isNotEmpty) {
      var coursesString = coursesAttended.join(', ');
      var msg = "Student attended classes for: $coursesString";

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
                      builder: (context) => HomeStudentPage(
                        ids: ids, // Pass ids to HomeStudentPage
                      ),
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
      // Display a popup message indicating no classes attended
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('No Classes Attended'),
            content: Text('Student attended no classes.'),
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
  } on FormatException catch (e) {
    print('Error while trying to view attendance: $e');
    // Display a generic error message for format exception
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text('An error occurred while trying to view attendance.'),
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
  } catch (e) {
    print('Error while trying to view attendance: $e');
    // Display a generic error message
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text('An error occurred while trying to view attendance.'),
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$_greeting Student'),
        automaticallyImplyLeading: false, // Remove back button
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Check Attendance',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _dateController,
              readOnly: true, // Make it read-only
              decoration: InputDecoration(
                labelText: 'Select Date',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.calendar_today),
              ),
              onTap: () async {
                final selectedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2025),
                );
                if (selectedDate != null) {
                  setState(() {
                    _selectedDate =
                        '${selectedDate.year}-${selectedDate.month}-${selectedDate.day}';
                    _dateController.text =
                        _selectedDate; // Update the text field
                  });
                }
              },
            ),
            SizedBox(height: 16.0),
            TextField(
              decoration: InputDecoration(
                labelText: 'Enter Student Id',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.book),
              ),
              onChanged: (value) {
                setState(() {
                  _courseCode = value;
                });
              },
            ),
            SizedBox(height: 24.0),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  print('student id: $_courseCode');
                  print('Password: $_selectedDate');

                  viewAttendance(context, widget.ids); // Pass widget.ids
                  // Navigator.of(context).push(
                  //   MaterialPageRoute(builder: (context) => HomeStudentPage()),
                  // );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  //onPrimary: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                child: Text(
                  'Check Attendance',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
