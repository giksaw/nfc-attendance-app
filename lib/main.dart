import 'package:attend2/final/homeTeacher.dart';
import 'package:attend2/final/loginmain.dart';

import 'package:attend2/sharedData.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => SharedData(),
      child: MaterialApp(
        home: LoginPagef(),
      ),
    ),
  );
}
