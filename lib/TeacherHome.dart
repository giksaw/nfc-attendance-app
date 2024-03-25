import 'package:attend2/notFinished.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:attend2/sharedData.dart';

class teacherHome extends StatefulWidget {
  const teacherHome({super.key});

  @override
  State<teacherHome> createState() => _teacherHomeState();
}

class _teacherHomeState extends State<teacherHome> {
  List<String> itemList = []; // List to hold items
  bool isScanActive = false; // Variable to track scan status

  @override
  Widget build(BuildContext context) {
    var sharedData = Provider.of<SharedData>(context);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 247, 247, 247),
        title: const Row(
          children: [
            // IconButton(
            //   icon: const Icon(Icons.arrow_back),
            //   onPressed: () {
            //     Navigator.of(context).pop();
            //   },
            // ),
            Text(
              'AttenD',
              style:
                  TextStyle(fontSize: 20, color: Color.fromARGB(255, 0, 0, 0)),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              // Add profile button functionality
              print('Profile button pressed');
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Add invisible "Add" button on the top-left part of the body
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 20),
              child: GestureDetector(
                onTap: () {
                  // Add functionality for "Add" button
                  setState(() {
                    // Update the list with shared variable
                    itemList.add(sharedData.sharedVariable);
                  });
                },
                child: Container(
                  width: 150,
                  height: 50,
                  color: Colors.transparent,
                ),
              ),
            ),
            const SizedBox(height: 20),
            RawMaterialButton(
              onPressed: () {
                // Toggle scan status
                setState(() {
                  isScanActive = !isScanActive;
                });
                // Add scan attendance functionality
                print('Scan Attendance');
              },
              elevation: 2.0,
              fillColor: Colors.blue,
              shape: const CircleBorder(),
              child: Container(
                width: 150, // Smaller width
                height: 150, // Smaller height
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 255, 255, 255),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        isScanActive ? 'Scan Active' : 'Scan Deactive',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: isScanActive ? Colors.green : Colors.red,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Scan\nAttendance',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontSize: 18, // Adjusted font size
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: itemList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      itemList[index],
                      style: TextStyle(color: Colors.white), // Set text color to white
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Add functionality for "Save" button
                print('Save button pressed');
                 Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => NotFinishedPage()),
                );
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
