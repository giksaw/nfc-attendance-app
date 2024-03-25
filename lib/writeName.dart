import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:provider/provider.dart';
import 'package:attend2/sharedData.dart';
//import 'package:attend2/loginMain.dart'; // Import the LoginMain page

class RegisteredPage extends StatefulWidget {
  final String name;

  const RegisteredPage({Key? key, required this.name}) : super(key: key);

  @override
  _RegisteredPageState createState() => _RegisteredPageState();
}

class _RegisteredPageState extends State<RegisteredPage> {
  bool _isNFCAvailable = false;

  @override
  void initState() {
    super.initState();
    _checkNFCStatus();
  }

  Future<void> _checkNFCStatus() async {
    try {
      _isNFCAvailable = await NfcManager.instance.isAvailable();
    } catch (e) {
      print('Error checking NFC status: $e');
      _isNFCAvailable = false;
    }
    // Check if the widget is mounted before calling setState
    if (mounted) {
      setState(() {});
    }
  }

  void _showWritingCompleteDialog(BuildContext context) {
    var sharedData = Provider.of<SharedData>(context, listen: false);
    sharedData.sharedVariable = widget.name; // Update shared data to student name

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Writing Complete'),
          content: const Text('NFC tag has been successfully written.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                Navigator.of(context).pop();
                Navigator.of(context).pop();  // Go back to the LoginMain page
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_isNFCAvailable) {
      // NFC is not available, show message to turn it on
      return Scaffold(
        appBar: AppBar(
          title: const Text('Registered Page'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'NFC is not available',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Go Back'),
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      // NFC is available, show registered name
      return Scaffold(
        appBar: AppBar(
          title: const Text('Registered Page'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Place near an NFC tag to write',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Registered Name:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  widget.name,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () => _showWritingCompleteDialog(context),
                      child: Container(
                        width: 150,
                        height: 50,
                        color: Colors.transparent,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

  void _showNFCDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Turn On NFC'),
          content: const Text('Please turn on NFC to continue.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
