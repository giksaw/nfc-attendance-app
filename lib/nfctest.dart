import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';

class Nfc2 extends StatefulWidget {
  const Nfc2({Key? key}) : super(key: key);

  @override
  State<Nfc2> createState() => _NfcState();
}

class _NfcState extends State<Nfc2> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController? controllerOne = TextEditingController();
  TextEditingController? controllerTwo = TextEditingController();
  var result;
  String? tagData = '';
  bool? status = false;

  @override
  void initState() {
    checkAvailability();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("NFC"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(14),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  'NFC - ${status! ? "Supported" : "Not supported on this device"}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            SizedBox(height: 5),
            TextButton(
              onPressed: () => setState(() {}),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.refresh),
                  SizedBox(width: 15),
                  Text("Refresh")
                ],
              ),
            ),
            SizedBox(height: 15),
            Divider(),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                TextButton(
                  onPressed: () => _tagRead(),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.nfc),
                      SizedBox(width: 15),
                      Text("Read Tag")
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 15),
            Divider(),
            SizedBox(height: 15),

            TextFormField(
              controller: controllerOne,
              decoration: InputDecoration(
                hintText: "Type here...",
                label: Text("Create text"),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return "This field is required";
                }
                return null;
              },
            ),
            SizedBox(height: 20),

            TextFormField(
              controller: controllerTwo,
              validator: (value) {
                if (value!.isEmpty) {
                  return "This field is required";
                } else if (value.isNotEmpty && !Uri.parse(value).isAbsolute) {
                  return 'Enter a valid URI';
                }

                return null;
              },
              decoration: InputDecoration(
                hintText: "https://google.co.in",
                label: Text("Url"),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                TextButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      ndefWrite(controllerOne!.text, controllerTwo!.text);
                    }
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.edit_note_rounded),
                      SizedBox(width: 15),
                      Text("Write Tag")
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),

            // Area to display NFC tag data
            Text(
              'NFC Tag Data:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                tagData ?? 'Tag data will appear here',
                style: TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }

  checkAvailability() async {
    status = await NfcManager.instance.isAvailable();
  }

  void _tagRead() {
    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      result = tag.data;
      var text = extractTextRecords(result);
      setState(() {
        tagData = text;
      });
      NfcManager.instance.stopSession();
    });
  }

  void ndefWrite(String text, [String? uri]) {
    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      var ndef = Ndef.from(tag);
      if (ndef == null || !ndef.isWritable) {
        result.value = 'Tag is not ndef writable';
        NfcManager.instance.stopSession(errorMessage: result.value);
        return;
      }

      NdefMessage message = NdefMessage([
        NdefRecord.createText(text),
        NdefRecord.createUri(Uri.parse(uri ?? "https://google.co.in")),
      ]);

      try {
        controllerOne!.clear();
        controllerTwo!.clear();
        await ndef.write(message);
        result.value = 'Success to "Ndef Write"';
        NfcManager.instance.stopSession();
      } catch (e) {
        NfcManager.instance
            .stopSession(errorMessage: "something went wrong $e");
        return;
      }
    });
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
                    .replaceFirst('e', '')
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
}
