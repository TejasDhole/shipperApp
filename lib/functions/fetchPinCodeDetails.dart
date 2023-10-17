import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shipper_app/controller/facilityController.dart';

Future<bool> fetchPinCodeDetails(int pinCode) async{
  String proxyServer = dotenv.get('placeAutoCompleteProxy');
  FacilityController facilityController = Get.put(FacilityController());
  var response = await http.get(Uri.parse("${proxyServer}https://api.postalpincode.in/pincode/$pinCode"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      });

  var data = jsonDecode(response.body);

  // for both, request found and not found status code 200 so we will need to check the Message field
  if(response.statusCode == 200 && data[0]["Message"] != "No records found"){
    List postOffices = data[0]["PostOffice"] as List;
    facilityController.updatePinCode(pinCode.toString());
    facilityController.updateState(postOffices[0]["State"].toString());
    facilityController.updateCountry('India');
    return true;
  }
  else{
    return false;
  }
}