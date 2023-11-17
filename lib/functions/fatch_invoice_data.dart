import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiService {
  static Future<List<dynamic>> getInvoiceData(String shipperId) async {
    final String invoiceApi = dotenv.get('invoiceApiUrl');
    final response = await http.get(Uri.parse('$invoiceApi?shipperId=$shipperId'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data;
    } else {
      throw Exception('Failed to load invoice');
    }
  }
}
