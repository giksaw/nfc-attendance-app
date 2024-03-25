import 'package:pdf/widgets.dart' as pw;
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import 'package:printing/printing.dart';

Future<void> generatePDF(List<String> items, String courseCode) async {
  final pdf = pw.Document();

  // Add a page to the PDF
  pdf.addPage(
    pw.Page(
      build: (pw.Context context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            // Add a header for the current date
            pw.Text('Date: ${DateTime.now().toString()}'),
            // Add a header for the course code
            pw.Text('Course Code: $courseCode'),
            pw.SizedBox(height: 20), // Spacer

            // Generate a list of items from the itemList
            pw.ListView(
              children: items.map((item) => pw.Text(item)).toList(),
            ),
          ],
        );
      },
    ),
  );

  final Uint8List? output = await pdf.save();

 
  if (output != null) {
    await Printing.sharePdf(bytes: output);
  }
//   final pdfBytes = output; // Obtain the PDF bytes from your code
// await savePdfToLocalStorage(pdfBytes!);
}

Future<void> savePdfToLocalStorage(Uint8List pdfBytes) async {
  // Get the local storage directory path
  final localDirectory = await getApplicationDocumentsDirectory();

  // Create a file name for the PDF
  final fileName = 'attendance.pdf';

  // Construct the file path
  final filePath = '${localDirectory.path}/$fileName';

  // Save the PDF file to the local storage
  final file = File(filePath);
  await file.writeAsBytes(pdfBytes);

  // You can show a success message or do any other necessary actions
  print('PDF saved to $filePath');
}
