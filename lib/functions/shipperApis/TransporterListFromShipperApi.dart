import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:shipper_app/controller/shipperIdController.dart';
import 'package:http/http.dart' as http;

class TransporterListFromCompany {
  final String transporterApiUrl = dotenv.get('transporterApiUrl');
  ShipperIdController shipperIdController = Get.put(ShipperIdController());

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
              body['emailId'] ?? 'NA',
              body['transporterName'] ?? 'NA',
              body['phoneNo'] ?? 'NA',
              body['transporterId'] ?? 'NA'
            ];
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
      }
      else{
        debugPrint('document doesn\'t exits for transporter list');
        return [];
      }
    } catch (e) {
      debugPrint('Error fetching document: $e');
      return [];
    }
  }
}
