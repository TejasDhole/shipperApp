import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

getInvoiceDocApiCall(String invoiceId, String docType) async {
  try {
    final String documentApiUrl = dotenv.get('documentApiUrl');
    final response = await http.get(Uri.parse("$documentApiUrl/$invoiceId"));

    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      var invoiceDocLinks = [];
      for (var jsondata in jsonData["documents"]) {
        if (jsondata["documentType"][0] == docType) {
          invoiceDocLinks.add(jsondata["documentLink"]);
        }
      }
      return invoiceDocLinks;
    } else {
      return [];
    }
  } catch (e) {
    debugPrint("Error fetching document links: $e");
    return [];
  }
}
