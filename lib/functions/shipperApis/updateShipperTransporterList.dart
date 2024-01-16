import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/status/http_status.dart';
import 'package:shipper_app/Widgets/showSnackBarTop.dart';
import 'package:shipper_app/constants/colors.dart';
import 'package:shipper_app/controller/addLocationDrawerToggleController.dart';
import 'package:shipper_app/controller/shipperIdController.dart';
import 'package:http/http.dart' as http;

// This function add new transporter in companies transporter list
void updateCompanyTransporterList(transporterId, dialogContext) async {
  try {
    AddLocationDrawerToggleController addLocationDrawerToggleController = Get.put(AddLocationDrawerToggleController());
    ShipperIdController shipperIdController = Get.put(ShipperIdController());
    String companyId = shipperIdController.companyId.value;

    DocumentReference documentReference = FirebaseFirestore.instance.collection('/Companies').doc(companyId);

    debugPrint(transporterId);

    // Get the document snapshot
   await documentReference.update({
     //add transporter id at last index in transporter list array
      "transporters": FieldValue.arrayUnion([transporterId]),
    });

  //show successful message using snack-bar
  showSnackBar("Transporter added Successfully!!", truckGreen,
      Icon(Icons.check_circle_outline_outlined), dialogContext);
  addLocationDrawerToggleController.toggleAddTransporter(false);

  } catch (e) {
    debugPrint(e.toString());
    showSnackBar("Something went wrong!!", deleteButtonColor,
        Icon(Icons.report_gmailerrorred_outlined), dialogContext);
  }
}
