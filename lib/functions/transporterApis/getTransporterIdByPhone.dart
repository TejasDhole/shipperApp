import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

//This function get transporter details using phone if no transporter is present with this phone number then it will create a new transporter and will return it's details
Future<String> getTransporterIdByPhone(
    String phoneNo, String emailId, String transporterName) async {
  try {
    Map<String, dynamic> data = {
      "phoneNo": phoneNo,
      "transporterName": transporterName,
      "emailId": emailId,
    };
    String body = json.encode(data);

    final String transporterApiUrl = dotenv.get("transporterApiUrl");
    http.Response response = await http.post(
      Uri.parse(transporterApiUrl),
      body: body,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    var jsonData = json.decode(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonData['transporterId'] ?? 'Na';
    }
    return 'NA';
  } catch (e) {
    debugPrint('error $e');
    return "NA";
  }
}
