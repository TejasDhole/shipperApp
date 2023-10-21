import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shipper_app/controller/shipperIdController.dart';
// import 'package:flutter_config/flutter_config.dart';
import '/functions/shipperApis/runShipperApiPost.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<String?> createUserTraccar(String? mobileNum) async {
  ShipperIdController shipperIdController = Get.put(ShipperIdController());
  final String shipperApiUrl = dotenv.get('shipperApiUrl');
  final String traccarUser = dotenv.get('traccarUser');
  final String traccarPass = dotenv.get('traccarPass');
  final String traccarApi = dotenv.get('traccarApi');
  String ownerEmailId = '';

  //fetch email of owner
  http.Response response = await http.get(Uri.parse(
      '$shipperApiUrl/${shipperIdController.ownerShipperId.toString()}'));
  var jsonData = json.decode(response.body);
  if (response.statusCode == 200 || response.statusCode == 201) {
    ownerEmailId = jsonData["emailId"].toString();
    shipperIdController.updateOwnerEmailId(ownerEmailId);
  }


  //create User Account in traccar
  //email will be owner email
  //name will be company name

  String basicAuth =
      'Basic ' + base64Encode(utf8.encode('$traccarUser:$traccarPass'));

  Map data = {
    "name": shipperIdController.companyName.toString(),
    "password": traccarPass,
    "email": ownerEmailId,
    "attributes": {"timezone": "Asia/Kolkata"}
  };
  String body = json.encode(data);

  var responseUser = await http.post(Uri.parse("$traccarApi/users"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'authorization': basicAuth,
      },
      body: body);
  if (responseUser.statusCode == 200) {
    var decodedResponse = json.decode(responseUser.body);
    String id = decodedResponse["id"].toString();
    sidstorage
        .write("traccarUserId", id)
        .then((value) => print("traccarUserId \" $id \" saved in cache"));
    return id;
  } else if (response.statusCode == 400) {
    return null;
  }
  return null;
}
