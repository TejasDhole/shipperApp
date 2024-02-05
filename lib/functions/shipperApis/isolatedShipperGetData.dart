import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shipper_app/controller/myLoadFilterController.dart';
import 'package:shipper_app/functions/shipperId_fromCompaniesDatabase.dart';
import 'package:shipper_app/functions/traccarCalls/createUserTraccar.dart';
import '../get_role_of_employee.dart';
import '/controller/shipperIdController.dart';

// import 'package:flutter_config/flutter_config.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

ShipperIdController shipperIdController =
    Get.put(ShipperIdController(), permanent: true);
bool exe = true;

int count = 0;

late Timer timer;

isolatedShipperGetData() {
  exe = true;
  timer = Timer.periodic(
      Duration(seconds: 2),
      (Timer t) => exe
          ? runShipperApiPostIsolated(
              emailId: FirebaseAuth.instance.currentUser!.email!)
          : timer.cancel());
}

GetStorage sidstorage = GetStorage('ShipperIDStorage');

Future<String?> runShipperApiPostIsolated(
    {required String emailId, String? userLocation, String? phoneNo}) async {
  try {
    MyLoadsFilterController myLoadsFilterController = Get.put(MyLoadsFilterController());
    ShipperIdController shipperIdController =
        Get.put(ShipperIdController(), permanent: true);

    final String shipperApiUrl = dotenv.get('shipperApiUrl');

    final response = await http.get(
        Uri.parse('$shipperApiUrl/?emailId=$emailId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        });

    if (response.statusCode == 200 || response.statusCode == 201) {
      var decodedResponse = json.decode(response.body)[0];
      if (decodedResponse["shipperId"] != null) {
        String shipperId = decodedResponse["shipperId"];

        shipperIdController
            .updateCompanyId(decodedResponse["companyId"].toString());

        sidstorage
            .write("companyId", shipperIdController.companyId.value)
            .then((value) => print("Written company Id"));

        shipperIdController.updateRole(decodedResponse["roles"].toString());

        sidstorage
            .write("role", shipperIdController.role.value)
            .then((value) => print("Written role"));

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
        myLoadsFilterController.updateRefreshBuilder(true);

        if (decodedResponse["token"] != null) {
          shipperIdController
              .updateJmtToken(decodedResponse["token"].toString());
        }

        if (FirebaseAuth.instance.currentUser != null) {
          createUserTraccar(phoneNo);
        }
        exe = false;
        return shipperId;
      } else {
        return null;
      }
    } else {
      shipperIdController.shipperId.value = sidstorage
                  .read("shipperId") ?? '';

      shipperIdController.companyId.value = sidstorage
          .read("companyId") ?? '';

      shipperIdController.role.value = sidstorage
          .read("role") ?? 'VIEWER';

      shipperIdController.updateName(sidstorage.read("name") ?? '');
      shipperIdController.updateCompanyName(sidstorage.read("companyName")??'');
      shipperIdController.updateEmailId(sidstorage.read("emailId") ?? "");
      shipperIdController.updateOwnerEmailId(sidstorage.read("companyEmailId") ?? '');

      return null;
    }
  } catch (e) {
    print("from runShipperApiPostIsolated: $e");
    return null;
  }
}

@override
void dispose() {
  timer.cancel();
  // super.dispose();
}
