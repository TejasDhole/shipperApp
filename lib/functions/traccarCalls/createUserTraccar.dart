import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shipper_app/controller/shipperIdController.dart';
import 'package:shipper_app/functions/encryptDecrypt.dart';

// import 'package:flutter_config/flutter_config.dart';
import '/functions/shipperApis/runShipperApiPost.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<String?> createUserTraccar(String? mobileNum) async {
  ShipperIdController shipperIdController = Get.put(ShipperIdController());
  final String traccarUser = dotenv.get('traccarUser');
  final String traccarPass = decrypt(dotenv.get('traccarPass'));
  final String traccarApi = dotenv.get('traccarApi');
  String companyEmailId = '';

  //fetching company emailId from firebase firestore
  final DocumentReference documentRef = FirebaseFirestore.instance
      .collection('/Companies')
      .doc(shipperIdController.companyId.value);

  await documentRef.get().then((doc) {
    if (doc.exists) {
      Map data = doc.data() as Map;
      companyEmailId =
          data!["company_details"]["contact_info"]["company_email"].toString();

      //update cache and getx variable
      sidstorage
          .write("companyEmailId", companyEmailId)
          .then((value) => print("Written company email Id"));

      shipperIdController.updateOwnerEmailId(companyEmailId);

    } else {
      debugPrint('No such document!');
    }
  });

  //create User Account in traccar
  //email will be company email
  //name will be company name

  String basicAuth =
      'Basic ' + base64Encode(utf8.encode('$traccarUser:$traccarPass'));

  Map data = {
    "name": shipperIdController.companyName.toString(),
    "password": traccarPass,
    "email": companyEmailId,
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
  } else if (responseUser.statusCode == 400) {
    return null;
  }
  return null;
}
