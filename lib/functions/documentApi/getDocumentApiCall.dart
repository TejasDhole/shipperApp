import 'dart:convert';
import 'package:http/http.dart' as http;
// import 'package:flutter_config/flutter_config.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

getDocumentApiCall(String bookingId, String docType) async {
  // shipperIdController tIdController = Get.put(shipperIdController());
  bool dataExist = false;
  var jsonData;
  var docLinks = [];
  try {
    final String documentApiUrl = dotenv.get('documentApiUrl');
    final response = await http.get(Uri.parse("$documentApiUrl/$bookingId"));
    // headers: <String, String>{
    //   'Content-Type': 'application/json; charset=UTF-8',
    // },
    // body: body);
    if (response.statusCode == 404) {
      return [];
    }
    jsonData = json.decode(response.body);
    for (var jsondata in jsonData["documents"]) {
      if (jsondata["documentType"][0] == docType) {
        docLinks.add(jsondata["documentLink"]);
      }
    }

    return docLinks;
  } catch (e) {
    return e.toString();
  }
}
