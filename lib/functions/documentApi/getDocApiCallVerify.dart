import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

getDocApiCallVerify(String bookingId, String docType) async {
  var jsonData;
  try {
    final String documentApiUrl = dotenv.get('documentApiUrl');

    final response = await http.get(Uri.parse("$documentApiUrl/$bookingId"));

    jsonData = json.decode(response.body);
    for (var jsondata in jsonData["documents"]) {
      if (jsondata["documentType"][0] == docType) {
        if (jsondata["verified"] == false) {
          return false;
        }
      }
    }

    return true;
  } catch (e) {
    return e.toString();
  }
}
