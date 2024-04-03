import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ApiResponse {
  final int statusCode;
  final dynamic body;

  ApiResponse(this.statusCode, this.body);

  String getMsg() {
    if (body is Map && body.containsKey('msg')) {
      return body['msg'];
    }
    return 'Unknown error';
  }
}

class Api {
  static const baseUrl = "https://nfc-attendence.onrender.com/";

  static Future<ApiResponse> registerUser(Map<String, dynamic> pdata) async {
    var url = Uri.parse("${baseUrl}client/register");

    try {
      final res = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(pdata), // Encode pdata to JSON string
      );

      var data = jsonDecode(res.body);
      print(data);
      print(res.statusCode);

      return ApiResponse(res.statusCode, data);
    } catch (e) {
      debugPrint(e.toString());
      return ApiResponse(500, "Something went wrong");
    }
  }

  static Future<ApiResponse> loginclient(Map<String, dynamic> pdata) async {
    var url = Uri.parse("${baseUrl}client/login");

    try {
      final res = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(pdata), // Encode pdata to JSON string
      );

      var data = jsonDecode(res.body);
      print(data);
      print(res.statusCode);

      return ApiResponse(res.statusCode, data);
    } catch (e) {
      debugPrint(e.toString());
      return ApiResponse(500, "Something went wrong");
    }
  }

  static Future<ApiResponse> registerHost(Map<String, dynamic> pdata) async {
    var url = Uri.parse("${baseUrl}host/register");

    try {
      final res = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(pdata), // Encode pdata to JSON string
      );

      var data = jsonDecode(res.body);
      print(data);
      print(res.statusCode);

      return ApiResponse(res.statusCode, data);
    } catch (e) {
      debugPrint(e.toString());
      return ApiResponse(500, "Something went wrong");
    }
  }

  static Future<ApiResponse> loginhost(Map<String, dynamic> pdata) async {
    var url = Uri.parse("${baseUrl}host/login");

    try {
      final res = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(pdata), // Encode pdata to JSON string
      );

      var data = jsonDecode(res.body);
      print(data);
      print(res.statusCode);

      return ApiResponse(res.statusCode, data);
    } catch (e) {
      debugPrint(e.toString());
      return ApiResponse(500, "Something went wrong");
    }
  }

  static Future<ApiResponse> forgotpas(Map<String, dynamic> pdata) async {
    var url = Uri.parse("${baseUrl}forgotpassword");

    try {
      final res = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(pdata), // Encode pdata to JSON string
      );

      var data = jsonDecode(res.body);
      print(data);
      print(res.statusCode);

      return ApiResponse(res.statusCode, data);
    } catch (e) {
      debugPrint(e.toString());
      return ApiResponse(500, "Something went wrong");
    }
  }

  static Future<ApiResponse> saveATT(Map<String, dynamic> pdata) async {
    var url = Uri.parse("${baseUrl}host/markattendance");

    try {
      final res = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(pdata), // Encode pdata to JSON string
      );

      var data = jsonDecode(res.body);
      print(data);
      print(res.statusCode);

      return ApiResponse(res.statusCode, data);
    } catch (e) {
      debugPrint(e.toString());
      return ApiResponse(500, "Something went wrong");
    }
  }

  static Future<ApiResponse> checkATT(Map<String, dynamic> pdata) async {
    var url = Uri.parse("${baseUrl}client/checkattendence");

    try {
      final res = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(pdata), // Encode pdata to JSON string
      );

      var data = jsonDecode(res.body);
      print(data);
      print(res.statusCode);

      return ApiResponse(res.statusCode, data);
    } catch (e) {
      debugPrint(e.toString());
      return ApiResponse(500, "Something went wrong");
    }
  }



static Future<List<String>> viewATT(Map<String, dynamic> pdata) async {
  var url = Uri.parse("${baseUrl}client/viewattendance");

  try {
    final res = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(pdata), // Encode pdata to JSON string
    );

    var data = jsonDecode(res.body);
    print(data);
    print(res.statusCode);

    // Check if the 'courses' key exists in the response
    if (data['courses'] != null && data['courses'] is List) {
      // If 'courses' key exists and is a List, return it
      List<String> courses = List<String>.from(data['courses']);
      return courses;
    } else {
      // If 'courses' key does not exist or is not a List, return an empty list
      return [];
    }
  } catch (e) {
    // If an exception occurs, print the error and return an empty list
    debugPrint('Error in viewATT: $e');
    return [];
  }
}

}
