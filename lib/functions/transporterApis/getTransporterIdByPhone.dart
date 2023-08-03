import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<String> getTransporterIdByPhone(String phoneNo) async {
  try {
    Map<String, dynamic> data = {
      "phoneNo": phoneNo,
    };
    String body = json.encode(data);

    final String transporterApiUrl = dotenv.get("transporterApiUrl");
    http.Response response = await http.post(
      Uri.parse('$transporterApiUrl'),
      body: body,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    var jsonData = json.decode(response.body);
    return jsonData['transporterId'] != null ? jsonData['transporterId'] : 'Na';
  } catch (e) {
    print('error $e');
    return "";
  }
}
