import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

Future<List> fetchUserData(String uid) async {
    try {
      final String uidApiEmail = dotenv.get("getUid");
      final response = await http
          .get(Uri.parse("$uidApiEmail/$uid"), headers: <String, String>{
        'Content-Type': 'application/json; charset = UTF-8',
      });

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final email = jsonData['email'];
        final name = jsonData['name'] ?? '';

        return [name, email];
      } else {
        //print('Request failed with status: ${response.statusCode}.');
        return [];
      }
    } catch (e) {
      //print('Error fetching user data: $e');
      return [];
    }
}