import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shipper_app/controller/shipperIdController.dart';
import 'package:http/http.dart' as http;

class TransporterListFromShipperApi {
  final String shipperApiUrl = dotenv.get('shipperApiUrl');
  ShipperIdController shipperIdController = Get.put(ShipperIdController());

  Future getTransporterListFromShipperApi() async {
    try {
      String shipperId = shipperIdController.shipperId.value;

      final response = await http.get(
        Uri.parse('$shipperApiUrl/$shipperId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        var body = jsonDecode(response.body);
        var transporterList = body['transporterList'];
        return transporterList;
      } else {
        return [];
      }
    } catch (e) {
      print(e);
      return [];
    }
  }
}
