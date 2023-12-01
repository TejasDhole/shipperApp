import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:shipper_app/functions/get_role_of_employee.dart';
import 'package:shipper_app/functions/traccarCalls/createUserTraccar.dart';
import '../create_company_database.dart';
import '../shipperId_fromCompaniesDatabase.dart';
import '/controller/shipperIdController.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

GetStorage sidstorage = GetStorage('ShipperIDStorage');

Future<String?> runShipperApiPost({
  required String emailId,
  String? phoneNo,
  String? shipperName,
  String? companyName,
  String? gst,
  String? address,
  String? userLocation,
  String? companyId,
  String? role,
}) async {
  try {
    ShipperIdController shipperIdController =
        Get.put(ShipperIdController(), permanent: true);

    final String shipperApiUrl = dotenv.get('shipperApiUrl');

    Map data = userLocation != null
        ? {"emailId": emailId, "shipperLocation": userLocation}
        : {
            "emailId": emailId,
            "phoneNo": phoneNo,
            "shipperName": shipperName,
            "companyName": companyName,
            "companyId": companyId,
            "roles": role,
            "GST": gst,
            "companyStatus": "verified",
            "shipperLocation": address,
          };

    String body = json.encode(data);
    final response = await http.post(Uri.parse(shipperApiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // HttpHeaders.authorizationHeader: firebaseToken!
        },
        body: body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      var decodedResponse = json.decode(response.body);
      print(decodedResponse);
      if (decodedResponse["shipperId"] != null) {
        String shipperId = decodedResponse["shipperId"];

        // debugPrint(shipperId);
        bool companyApproved =
            decodedResponse["companyApproved"].toString() == "true";
        bool accountVerificationInProgress =
            decodedResponse["accountVerificationInProgress"].toString() ==
                "true";
        String shipperLocation = decodedResponse["shipperLocation"] ?? " ";
        String name = decodedResponse["shipperName"] ?? " ";
        String companyName = decodedResponse["companyName"] ?? " ";
        String companyStatus = decodedResponse["companyStatus"] ?? " ";
        String mobileNum = decodedResponse["phoneNo"] ?? " ";
        shipperIdController.updateShipperId(shipperId);
        sidstorage
            .write("shipperId", shipperId)
            .then((value) => print("Written shipperId"));
        shipperIdController.updateCompanyApproved(companyApproved);
        sidstorage
            .write("companyApproved", companyApproved)
            .then((value) => print("Written companyApproved"));

        shipperIdController.updateCompanyStatus(companyStatus);
        sidstorage
            .write("companyStatus", companyStatus)
            .then((value) => print("Written companyStatus"));
        shipperIdController.updateEmailId(emailId);
        sidstorage
            .write("emailId", emailId)
            .then((value) => print("Written emailId"));
        shipperIdController.updateMobileNum(mobileNum);
        sidstorage
            .write("mobileNum", mobileNum)
            .then((value) => print("Written mobile number"));
        shipperIdController
            .updateAccountVerificationInProgress(accountVerificationInProgress);
        sidstorage
            .write(
                "accountVerificationInProgress", accountVerificationInProgress)
            .then((value) => print("Written accountVerificationInProgress"));
        shipperIdController.updateShipperLocation(shipperLocation);
        sidstorage
            .write("shipperLocation", shipperLocation)
            .then((value) => print("Written shipperLocation"));
        shipperIdController.updateName(name);
        sidstorage.write("name", name).then((value) => print("Written name"));
        shipperIdController.updateCompanyName(companyName);
        sidstorage
            .write("companyName", companyName)
            .then((value) => print("Written companyName"));
        shipperIdController
            .updateCompanyId(decodedResponse["companyId"].toString());

        shipperIdController.updateRole(decodedResponse["roles"].toString());

        if (decodedResponse["token"] != null) {
          shipperIdController
              .updateJmtToken(decodedResponse["token"].toString());
        }

        if (FirebaseAuth.instance.currentUser != null) {
          createUserTraccar(phoneNo);
        }
        return shipperId;
      } else {
        return null;
      }
    } else {
      return null;
    }
  } catch (e) {
    print(e);
    return null;
  }
}
