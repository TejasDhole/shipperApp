import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:shipper_app/functions/shipperApis/runShipperApiPost.dart';
import 'package:shipper_app/models/CompanyModel.dart';
import 'package:uuid/uuid.dart';

createCompany(String u_name,String c_name, String c_email, String? c_phnNo, String address,
    String city, String state, String pinCode, String gstn, String cin, String adminEmail) async{

  try{
    //creating uuid for company
    final String c_uuid = 'Company:${Uuid().v1()}';

    //first create a shipper
    //role of the company creator is ADMIN by default
    final adminShipperId = await runShipperApiPost(emailId: FirebaseAuth.instance.currentUser!.email!, shipperName: u_name, companyId: c_uuid, companyName: c_name, role: 'ADMIN');

    //creating company json
    var companyDoc = CompanyModel(c_name, c_email, address, null, city, state, gstn, cin, pinCode, c_phnNo, c_uuid, [adminShipperId], []).toJson();

    //creating json in firebase
    final CollectionReference postsRef = FirebaseFirestore.instance.collection('/Companies');

    await postsRef.doc(c_uuid).set(companyDoc);
    return true;
  }
  catch(error){
    debugPrint(error.toString());
    return false;
  }
}
