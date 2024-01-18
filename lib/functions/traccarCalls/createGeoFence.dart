import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shipper_app/controller/facilityController.dart';
import 'package:shipper_app/controller/shipperIdController.dart';
import 'package:shipper_app/functions/encryptDecrypt.dart';

createFacility() async {
  FacilityController facilityController = Get.put(FacilityController());
  //first fetch lat long of entered address using place_id
  List<double> latLng = [0, 0];

  if (facilityController.placeId.value != '') {
    latLng = await getLatLong();
  } else if (facilityController.lat.value.isNotEmpty &&
      facilityController.long.value.isNotEmpty) {
    latLng = [
      double.parse(facilityController.lat.value),
      double.parse(facilityController.long.value)
    ];
  }

  //then create  or update  geo fence in user traccar account
  if (facilityController.create.value == true) {
    return createGeoFence(latLng[0], latLng[1]);
  } else {
    return updateGeoFence(latLng[0], latLng[1]);
  }
}

getLatLong() async {
  FacilityController facilityController = Get.put(FacilityController());
  String placeId = facilityController.placeId.value;

  String kGoogleApiKey = dotenv.get('mapKey');
  String proxyServer = dotenv.get('placeAutoCompleteProxy');

  //Google place detail api
  http.Response response = await http.get(
    Uri.parse('${proxyServer}'
        'https://maps.googleapis.com/maps/api/place/details/json?'
        'place_id=$placeId&key=$kGoogleApiKey'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      "Accept": "application/json",
      "Access-Control_Allow_Origin": "*",
      "Access-Control-Allow-Credentials":
          "true", // Required for cookies, authorization headers with HTTPS
      "Access-Control-Allow-Headers":
          "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
    },
  );

  var address = await jsonDecode(response.body);

  if (response.statusCode == 200) {
    address = address["result"]["geometry"]["location"];

    return [
      double.parse(address["lat"].toString()),
      double.parse(address["lng"].toString())
    ];
  } else {
    throw Exception('Latitude and Longitude Not Found');
  }
}

createGeoFence(lat, long) async {
  ShipperIdController shipperIdController = Get.put(ShipperIdController());
  FacilityController facilityController = Get.put(FacilityController());

  String traccarApi = dotenv.get('traccarApi');
  String traccarUser = shipperIdController.ownerEmailId.value;
  String traccarPass = decrypt(dotenv.get('traccarPass'));
  String basicAuth =
      'Basic ' + base64Encode(utf8.encode('$traccarUser:$traccarPass'));

  Map data = {
    "attributes": {
      "pinCode": facilityController.pinCode.value.toString(),
      "address": facilityController.address.value.toString(),
      "city": facilityController.city.value.toString(),
      "state":
          "${facilityController.state.value.toString()}, ${facilityController.country.value.toString()}",
    },
    "name": facilityController.partyName.value.toString(),
    "area": "CIRCLE ($lat $long, ${facilityController.facilityRadius.value.toString()})"
  };
  String body = json.encode(data);

  var response = await http.post(Uri.parse("$traccarApi/geofences"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'authorization': basicAuth,
      },
      body: body);

  if (response.statusCode == 200) {
    return true;
  } else {
    return false;
  }
}

updateGeoFence(lat, long) async {
  ShipperIdController shipperIdController = Get.put(ShipperIdController());
  FacilityController facilityController = Get.put(FacilityController());
  String id = facilityController.id.value;
  String traccarApi = dotenv.get('traccarApi');
  String traccarUser = shipperIdController.ownerEmailId.value;
  String traccarPass = decrypt(dotenv.get('traccarPass'));
  String basicAuth =
      'Basic ' + base64Encode(utf8.encode('$traccarUser:$traccarPass'));

  Map data = {
    "attributes": {
      "pinCode": facilityController.pinCode.value.toString(),
      "address": facilityController.address.value.toString(),
      "city": facilityController.city.value.toString(),
      "state":
          "${facilityController.state.value.toString()}, ${facilityController.country.value.toString()}",
    },
    "name": facilityController.partyName.value.toString(),
    "area": "CIRCLE ($lat $long, ${facilityController.facilityRadius.value.toString()})",
    "id": int.parse(id),
  };
  String body = json.encode(data);

  var response = await http.put(Uri.parse("$traccarApi/geofences/$id"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'authorization': basicAuth,
      },
      body: body);

  if (response.statusCode == 200) {
    return true;
  } else {
    return false;
  }
}
