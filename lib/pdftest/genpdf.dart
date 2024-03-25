import 'dart:io';

import 'package:attend2/pdftest/test101.dart';
// import 'package:flutter/material.dart';
// import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'dart:typed_data'; // Add this import for Uint8List
import 'package:permission_handler/permission_handler.dart';

Future<void> generatePDF(List<String> items) async {
  final pdf = pw.Document();

  pdf.addPage(
    pw.Page(
      build: (context) {
        return pw.ListView(
          children: items.map((item) => pw.Text(item)).toList(),
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

Future<bool> requestStoragePermission() async {
  if (await Permission.storage.request().isGranted) {
    return true;
  } else {
    return false;
  }
}

Future<String> getLocalDirectoryPath() async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

Future<void> savePdfToLocalStorage(Uint8List pdfBytes) async {
  // Request storage permission for Android
  if (Platform.isAndroid) {
    final isPermissionGranted = await requestStoragePermission();
    if (!isPermissionGranted) {
      return;
    }
  }

  // Get the local storage directory path
  final localDirectoryPath = await getLocalDirectoryPath();

  // Create a file name for the PDF
  final fileName = 'example.pdf';

  // Construct the file path
  final filePath = '$localDirectoryPath/$fileName';

  // Save the PDF file to the local storage
  final file = File(filePath);
  await file.writeAsBytes(pdfBytes);

  // You can show a success message or do any other necessary actions
  print('PDF saved to $filePath');
}
