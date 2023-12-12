import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

getInvoiceDocApiCall(String invoiceId, String docType) async {
  var jsonData;
  var invoiceDocLinks = [];
  try {
    final String documentApiUrl = dotenv.get('documentApiUrl');
    final response = await http.get(Uri.parse("$documentApiUrl/$invoiceId"));

    if (response.statusCode == 404) {
      return [];
    }
    jsonData = json.decode(response.body);
    for (var jsondata in jsonData["documents"]) {
      if (jsondata["documentType"][0] == docType) {
        invoiceDocLinks.add(jsondata["documentLink"]);
      }
    }
    return invoiceDocLinks;
  } catch (e) {
    return e.toString();
  }
}
