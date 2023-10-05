import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<Map<String, dynamic>> fetchDataFromLoadApi(String? loadId) async {
  try {
    String loadApiUrl = dotenv.get('loadApiUrl');

    final response = await http.get(
      Uri.parse('$loadApiUrl/$loadId'),
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return jsonData;
    } else {
      throw Exception(
          'API request failed with status code ${response.statusCode}');
    }
  } catch (error) {
    throw Exception('Error: $error');
  }
}
