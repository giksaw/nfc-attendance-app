import 'package:flutter/material.dart';

class SharedData extends ChangeNotifier {
  late String _sharedVariable;

  SharedData() {
    // Set an initial value if it's not assigned
    _sharedVariable = 'Empty Tag';
  }

  String get sharedVariable => _sharedVariable;

  set sharedVariable(String value) {
    _sharedVariable = value;
    notifyListeners();
  }
}
