import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:shipper_app/controller/shipperIdController.dart';
import 'package:shipper_app/functions/encryptDecrypt.dart';

Future<List> fetchAllGeoFences() async {
  try {
    ShipperIdController shipperIdController = Get.put(ShipperIdController());

    String traccarApi = dotenv.get('traccarApi');
    String traccarUser = shipperIdController.ownerEmailId.value;
    String traccarPass = decrypt(dotenv.get('traccarPass'));

    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$traccarUser:$traccarPass'));

    var response = await http
        .get(Uri.parse("$traccarApi/geofences/"), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'authorization': basicAuth,
    });

    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);

      return body;
    } else {
      return [];
    }
  } catch (error) {
    return [];
  }
}
