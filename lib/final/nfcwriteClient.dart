import 'package:attend2/final/homeStudentF.dart';
import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';


class NfcWriteClient extends StatefulWidget {
  final String registeredId;

   NfcWriteClient({Key? key, required this.registeredId}) : super(key: key);

  @override
  _NfcWriteClientState createState() => _NfcWriteClientState();
}

class _NfcWriteClientState extends State<NfcWriteClient> {
  bool _isWritingTag = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Write NFC Tag'),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                'Registered ID: ${widget.registeredId}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
            _isWritingTag
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : ElevatedButton(
                    onPressed: _writeNfcTag,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Write NFC Tag',
                      style: TextStyle(fontSize: 18 ,color: Colors.white),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Future<void> _writeNfcTag() async {
    setState(() {
      _isWritingTag = true;
    });

    try {
      NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
        var ndef = Ndef.from(tag);
        if (ndef == null || !ndef.isWritable) {
          _showDialog('Tag is not NDEF writable');
          NfcManager.instance.stopSession();
          return;
        }

        NdefMessage message = NdefMessage([
          NdefRecord.createText(widget.registeredId),
        ]);

        await ndef.write(message);
        _showDialog('Writing successful');
        NfcManager.instance.stopSession();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) =>  HomeStudentPage(ids: widget.registeredId,)),
        );
      });
    } catch (e) {
      _showDialog('Error: $e');
    } finally {
      setState(() {
        _isWritingTag = false;
      });
    }
  }

  void _showDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('NFC Tag Write'),
          content: Text(message),
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