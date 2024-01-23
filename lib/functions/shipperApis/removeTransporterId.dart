import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shipper_app/Widgets/showSnackBarTop.dart';
import 'package:shipper_app/constants/colors.dart';
import 'package:shipper_app/controller/shipperIdController.dart';

// This function is used to remove transporter Id from  companies transporter list
void removeTransporterList(transporterId, dialogContext) async {
  try {
    ShipperIdController shipperIdController = Get.put(ShipperIdController());
    String companyId = shipperIdController.companyId.value;

    CollectionReference companyReference =
        FirebaseFirestore.instance.collection('/Companies');
    DocumentReference transporterReference = companyReference.doc(companyId);

    await transporterReference.update({
      // Delete transporter id in  transporter list array
      'transporters': FieldValue.arrayRemove([transporterId])
    });

    // Show successful message using snack-bar
    showSnackBar("Transporter deleted Successfully!!", truckGreen,
        Icon(Icons.check_circle_outline_outlined), dialogContext);
  } catch (e) {
    debugPrint(e.toString());
    showSnackBar("Something went wrong!!", deleteButtonColor,
        Icon(Icons.report_gmailerrorred_outlined), dialogContext);
  }
}
