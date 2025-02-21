import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:shipper_app/controller/shipperIdController.dart';
import 'package:http/http.dart' as http;
import 'package:shipper_app/controller/transporterController.dart';

class TransporterListFromCompany {
  final String transporterApiUrl = dotenv.get('transporterApiUrl');
  ShipperIdController shipperIdController = Get.put(ShipperIdController());

  //This function fetches transporter list using company id.
  Future getTransporterListUsingCompanyId(String txt) async {
    String companyId = shipperIdController.companyId.value;

    //get transporterList from company table firebase
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('/Companies').doc(companyId);

    try {
      // Get the document snapshot
      DocumentSnapshot documentSnapshot = await documentReference.get();

      // Check if the document exists
      if (documentSnapshot.exists) {
        // Access a transporter List
        List transporterIdList = documentSnapshot['transporters'] ?? [];
        var transporterDataList = [];
        var filteredTransporterList = [];

        if (transporterIdList.isEmpty) {
          return [];
        }
        //fetch transporter details using transporter id
        for (int i = 0; i < transporterIdList.length; i++) {
          final response = await http.get(
            Uri.parse('$transporterApiUrl/${transporterIdList[i]}'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
          );

          if (response.statusCode == 200 || response.statusCode == 201) {
            var body = jsonDecode(response.body);
            List transporterData = [
              body['emailId'] ?? '',
              body['transporterName'] ?? '',
              body['phoneNo'] ?? '',
              body['transporterId'] ?? '',
              body['panNumber'] ?? '',
              body['gstNumber'] ?? '',
              body['vendorCode'] ?? ' '
            ];
            //[[email, name, phone, transporterId, panNumber, GSTno, vendorCode], [email, name, phone, transporterId, panNumber, GSTno, vendorCode]]
            transporterDataList.add(transporterData);
          }
        }

        if (txt == '') {
          return transporterDataList;
        } else {
          txt = txt.toLowerCase();

          for (List transporter in transporterDataList) {
            if (transporter[1].toString().toLowerCase().contains(txt)) {
              filteredTransporterList.add(transporter);
            }
          }
          return filteredTransporterList;
        }
      } else {
        debugPrint('document doesn\'t exits for transporter list');
        return [];
      }
    } catch (e) {
      debugPrint('Error fetching document: $e');
      return [];
    }
  }

  // This functions  is used to delete transporter details using transporter id
  Future<bool> deleteTransporter(String id) async {
    var response = await http.delete(
      Uri.parse('$transporterApiUrl/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 204) {
      return true;
    } else {
      return false;
    }
  }

  // This function is used to update the transporter details using transporter id
  updateTransporterList(
    String id,
  ) async {
    TransporterController transporterController =
        Get.put(TransporterController());
    Map data = {
      "transporterName": transporterController.name.toString(),
      "vendorCode": transporterController.vendorCode.toString(),
      "panNumber": transporterController.panNo.toString(),
      "gstNumber": transporterController.gstNo.toString(),
    };
    String body = json.encode(data);

    var response = await http.put(Uri.parse("$transporterApiUrl/$id"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: body);

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
