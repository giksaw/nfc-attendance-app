import 'dart:convert';
import 'package:attend2/bloc/services/api.dart';
import 'package:attend2/pdftest/dTgenpdf.dart';
import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';

class HomeTeacher extends StatefulWidget {
  const HomeTeacher({Key? key}) : super(key: key);

  @override
  State<HomeTeacher> createState() => _HomeTeacherState();
}

class _HomeTeacherState extends State<HomeTeacher> {
  List<Map<String, dynamic>> studentList = [];
  List<String> itemList = [];
  final TextEditingController _courseCodeController = TextEditingController();
  bool isReading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Attendance Marker"),
        backgroundColor: const Color.fromARGB(
            255, 255, 255, 255), // Change AppBar background color
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0), // Add padding to the body
        child: Column(
          children: [
            TextField(
              controller: _courseCodeController,
              decoration: InputDecoration(
                labelText: 'Enter Course Code',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                      10.0), // Rounded corners for the text field
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    saveData(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo, // Change button color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.save, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        'Save',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    generatePDF(itemList, _courseCodeController.text);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green, // Change button color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.share, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        'Share',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20), // Add some space
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                      10.0), // Rounded corners for the list
                  border: Border.all(
                      color: Colors.grey.shade300), // Border around the list
                ),
                child: ListView.builder(
                  itemCount: itemList.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                        itemList[index],
                        style: const TextStyle(color: Colors.black),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _toggleReading();
        },
        label: Text(isReading ? 'Stop Reading' : 'Start Reading'),
        icon: Icon(isReading ? Icons.stop : Icons.nfc),
        backgroundColor: isReading ? Colors.red : Colors.green,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void _toggleReading() {
    setState(() {
      isReading = !isReading; // Toggle the reading state
    });
    if (isReading) {
      _startReading();
    } else {
      _stopReading();
    }
  }

  String _twoDigits(int n) {
    if (n >= 10) {
      return '$n';
    } else {
      return '0$n';
    }
  }

  void _startReading() {
    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      var result = tag.data;
      print('Read Data:');
      print(result);
      var text = extractTextRecords(result);

      // Get the current time
      DateTime now = DateTime.now();

      // Format the time without last colon
      String formattedTime =
          '${_twoDigits(now.hour)}:${_twoDigits(now.minute)}:${_twoDigits(now.second)}';
      createStudentList(text, formattedTime);
      // Create a formatted string with time and text
      var textWithTime = '$formattedTime $text';

      print('Extracted Text with Time:');
      print(textWithTime);

      setState(() {
        itemList.add(textWithTime); // Add text with time to itemList
      });

      // Keep reading until toggled off
    });
  }

  void _stopReading() {
    NfcManager.instance.stopSession();
    // print(itemList);
  }

  String extractTextRecords(Map<String, dynamic> nfcData) {
    List<String> textRecords = [];
    if (nfcData.containsKey('ndef')) {
      var ndef = nfcData['ndef'];
      if (ndef.containsKey('cachedMessage')) {
        var cachedMessage = nfcData['ndef']['cachedMessage'];
        if (cachedMessage.containsKey('records')) {
          var records = cachedMessage['records'];
          for (var record in records) {
            if (record['typeNameFormat'] == 1 &&
                record['type'] != null &&
                record['type'][0] == 84) {
              var payload = utf8.decode(record['payload']);
              if (payload.length > 2) {
                var truncatedPayload = payload.substring(2);
                var cleanedPayload = truncatedPayload
                    // .replaceFirst('e', '')
                    .replaceFirst('n', '');
                textRecords.add(cleanedPayload);
              }
            }
          }
        }
      }
    }
    return textRecords.join(' ');
  }

  // void saveData(BuildContext context) async {
  //   print('hi');
  //   var courseId =
  //       'CID123'; // Placeholder for the course ID, replace with actual value
  //   var date =
  //       '${DateTime.now().year}-${_twoDigits(DateTime.now().month)}-${_twoDigits(DateTime.now().day)}'; // Current date

  //   // Create a list of student data
  //   List<Map<String, dynamic>> studentList = [];
  //   for (var item in itemList) {
  //     // Split each item to get student ID and time
  //     var parts = item.split(' ');
  //     if (parts.length == 2) {
  //       var id = int.tryParse(parts[0]);
  //       var time = parts[1];

  //       // Check if parsing was successful
  //       if (id != null) {
  //         studentList.add({
  //           "id": id,
  //           "time": time,
  //         });
  //       }
  //       print("studentList $studentList");
  //     }
  //   }

  //   // Create the payload in the required format
  //   var payload = {
  //     "courseId": courseId,
  //     "date": date,
  //     "student": studentList,
  //   };
  //   print(payload);
  //   try {
  //     var response = await Api.saveATT(payload);
  //     var msg = response.getMsg();

  //     print("Message: $msg");

  //     if (msg == 'Attendance marked successfully.') {
  //       // If successful, navigate to the next page
  //       Navigator.of(context).pop();
  //     } else {
  //       // Display a popup message with the error message
  //       showDialog(
  //         context: context,
  //         builder: (BuildContext context) {
  //           return AlertDialog(
  //             title: Text('Error'),
  //             content: Text(msg),
  //             actions: [
  //               TextButton(
  //                 onPressed: () {
  //                   Navigator.of(context).pop();
  //                 },
  //                 child: Text('OK'),
  //               ),
  //             ],
  //           );
  //         },
  //       );
  //     }
  //   } catch (e) {
  //     print('Error entering attendance  ');
  //     // Display a generic error message
  //     showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return AlertDialog(
  //           title: Text('Error'),
  //           content: Text('An error occurred'),
  //           actions: [
  //             TextButton(
  //               onPressed: () {
  //                 Navigator.of(context).pop();
  //               },
  //               child: Text('OK'),
  //             ),
  //           ],
  //         );
  //       },
  //     );
  //   }
  // }
  void createStudentList(String text, String formattedTime) {
    print("hi");
    setState(() {
      print("text $text");
      studentList.add({
            "id": text,
            "time": formattedTime,
          });
            print("studentlist $studentList");
      // var parts = text.split(' ');
      // if (parts.length >= 2) {
      //   var id = int.tryParse(parts[0]); // Assuming ID is the first part
      //   if (id != null) {
      //     studentList.add({
      //       "id": id,
      //       "time": formattedTime,
      //     });
      //     print("studentlist $studentList");
      //   }
      // }
    });
  }

  void saveData(BuildContext context) async {
    print('hi');
    var courseId = _courseCodeController
        .text; // Placeholder for the course ID, replace with actual value
    var date =
        '${DateTime.now().year}-${_twoDigits(DateTime.now().month)}-${_twoDigits(DateTime.now().day)}'; // Current date

    // Create the payload in the required format
    var payload = {
      "courseId": courseId,
      "date": date,
      "student": studentList,
    };
    print(payload);
    try {
      var response = await Api.saveATT(payload);
      var msg = response.getMsg();

      print("Message: $msg");

      if (msg == 'Attendance marked successfully.') {
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
                    Navigator.of(context).pop();
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
      print('Error entering attendance  ');
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
