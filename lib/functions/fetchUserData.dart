import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

Future<List> fetchUserData(String uid) async {
  try {
    final String shipperApiUrl = dotenv.get('shipperApiUrl');

    http.Response response = await http.get(Uri.parse('$shipperApiUrl/$uid'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final email = jsonData['emailId'];
      final name = jsonData['shipperName'] ?? '';
      final role = jsonData['roles'] ?? 'VIEWER';

      return [name, email, role];
    } else {
      return [];
    }
  } catch (e) {
    return [];
  }
}
