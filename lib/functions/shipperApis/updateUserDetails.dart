import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

//update user details Fuction

Future<void> updateUserDetails({
  required String uniqueID,
  required String name,
  required String companyName,
}) async {
  final String shipperApiUrl = dotenv.get('shipperApiUrl');
  final url = Uri.parse('$shipperApiUrl/$uniqueID');

  final body = {
    'shipperName': name,
    'companyName': companyName,
  };

  final headers = {
    'Content-Type': 'application/json',
  };

  final response =
      await http.put(url, headers: headers, body: jsonEncode(body));

  if (response.statusCode == 200) {
    print('User details updated successfully');
  } else {
    print('Failed to update user details');
  }
}

void showMySnackBar(BuildContext context, String message) {
  final snackBar = SnackBar(
    backgroundColor: Colors.black,
    content: Text(
      message,
      style: TextStyle(color: Colors.white),
    ),
  );

  // Show the SnackBar using the provided context
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
