import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/status/http_status.dart';
import 'package:shipper_app/controller/shipperIdController.dart';
import 'package:http/http.dart' as http;

void updateShipperTransporterList(transporterList, diaLogContext) async {
  try {
    ShipperIdController shipperIdController = Get.put(ShipperIdController());
    String shipperId = shipperIdController.shipperId.value;
    Map<String, dynamic> data = {
      "transporterList": transporterList,
    };
    String body = json.encode(data);
    final String shipperApiUrl = dotenv.get("shipperApiUrl");
    http.Response response = await http.put(
      Uri.parse('$shipperApiUrl/$shipperId'),
      body: body,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == HttpStatus.ok) {
      Navigator.of(diaLogContext).pop();
    }
  } catch (e) {
    print('error $e');
  }
}
