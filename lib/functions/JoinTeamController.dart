import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shipper_app/Widgets/showSnackBarTop.dart';
import 'package:shipper_app/constants/colors.dart';

//Fetch invite details like check whether inivte id is valid or not... and get some other data like company id, role etc
getInviteDetails(String id) async{
  String inviteEmail = dotenv.get('inviteEmails');

  Uri url = Uri.parse("$inviteEmail$id");
  http.Response response = await http.get(url);

  if(response.statusCode == 200){
    return json.decode(response.body);
  }
  else{
    return null;
  }
}

//add new employee to firebase under company member
addUserToCompany(String companyId, String shipperId, context) async{
  try {
    DocumentReference documentReference = FirebaseFirestore.instance.collection('/Companies').doc(companyId);

    debugPrint(shipperId);

    // Get the document snapshot
    await documentReference.update({
      //add transporter id at last index in transporter list array
      "members": FieldValue.arrayUnion([shipperId]),
    });

    //show successful message using snack-bar
    showSnackBar("Successfully Joined!!", truckGreen,
        const Icon(Icons.check_circle_outline_outlined), context);

  } catch (e) {
    debugPrint(e.toString());
    showSnackBar("Something went wrong!!", deleteButtonColor,
        const Icon(Icons.report_gmailerrorred_outlined), context);
  }
}

//create shipper account for new joinee .... if account exits then only update the account
Future<String?> createUpdateEmployee({
  required String emailId,
  required String shipperName,
  required String companyName,
  required String companyId,
  required String role,
}) async{

  final String shipperApiUrl = dotenv.get('shipperApiUrl');

  Map data = {
    "emailId": emailId,
    "shipperName": shipperName,
    "companyName": companyName,
    "companyId": companyId,
    "roles": role,
    "companyStatus": "verified",
  };

  String body = json.encode(data);
  final response = await http.post(Uri.parse(shipperApiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: body);


  if(response.statusCode == 201){
    var jsonData = json.decode(response.body);

    print('1');
    print(jsonData);

    if(jsonData['message'].toString() == 'Account already exist'){
      //update the shipper account
      //during update don't send email id in body

      var updatedData = json.encode({
        "shipperName": shipperName,
        "companyName": companyName,
        "companyId": companyId,
        "roles": role,
        "companyStatus": "verified",
      });


      final responseUpdate = await http.put(Uri.parse('$shipperApiUrl/${jsonData['shipperId']}'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: updatedData);

      print('2');
      print(responseUpdate.body);

      if(responseUpdate.statusCode == 200){
        return jsonData['shipperId'];
      }
      else{
        return null;
      }

    }
    else{
      return jsonData['shipperId'];
    }
  }
  else{
    return null;
  }

}

//delete the invite id so that same like can't be used multiple times
deleteInviteLink(String id) async{
  String deleteInvite = dotenv.get('deleteInvite');

  Uri url = Uri.parse("$deleteInvite$id");
  http.Response response = await http.delete(url);

  if(response.statusCode == 200){
    return json.decode(response.body);
  }
  else{
    return null;
  }
}