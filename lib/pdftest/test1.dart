import 'package:flutter/material.dart';
//import 'package:attend2/pdftest/genpdf.dart'; // Import your PDF generation file

class MyWidget extends StatefulWidget {
  const MyWidget({Key? key}) : super(key: key);

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  List<String> items = ['Item 1', 'Item 2', 'Item 3']; // Your list of items

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List View to PDF'),
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(items[index]),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //generatePDF(context,items); // Pass your list of items here
        },
        child: Icon(Icons.picture_as_pdf),
      ),
    );
  }
}
