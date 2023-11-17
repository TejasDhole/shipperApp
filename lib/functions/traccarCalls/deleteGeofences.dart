import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:shipper_app/controller/shipperIdController.dart';

Future<bool> deleteGeofences(String id) async {
  ShipperIdController shipperIdController = Get.put(ShipperIdController());
  String traccarApi = dotenv.get('traccarApi');
  String traccarUser = shipperIdController.ownerEmailId.value;
  String traccarPass = dotenv.get('traccarPass');
  String basicAuth =
      'Basic ' + base64Encode(utf8.encode('$traccarUser:$traccarPass'));

  var response = await http.delete(
    Uri.parse("$traccarApi/geofences/$id"),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'authorization': basicAuth,
    },
  );
  if (response.statusCode == 204) {
    return true;
  } else {
    return false;
  }
}
