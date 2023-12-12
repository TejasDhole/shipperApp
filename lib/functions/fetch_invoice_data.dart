import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiService {
  static Future<List<dynamic>> getInvoiceData(
      String companyId, String from, String to) async {
    final String invoiceApi = dotenv.get('invoiceApiUrl');
    final response = await http.get(Uri.parse(
        '$invoiceApi?shipperId=$companyId&fromTimestamp=$from&toTimestamp=$to'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data;
    } else {
      debugPrint('Error Status Code: ${response.statusCode}');
      debugPrint('Error Response Body: ${response.body}');
      throw Exception('Failed to load invoice');
    }
  }
}
