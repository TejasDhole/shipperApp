import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shipper_app/functions/firebaseAuthentication/signIn.dart';
import 'package:shipper_app/screens/employee_list_with_roles_screen.dart';
import 'package:shipper_app/Web/screens/home_web.dart';
import 'package:shipper_app/screens/accountScreens/accountVerificationStatusScreen.dart';
import '../Widgets/alertDialog/CompletedDialog.dart';
import '../Widgets/alertDialog/orderFailedAlertDialog.dart';
import '../constants/screens.dart';
import '../controller/navigationIndexController.dart';
import '../screens/navigationScreen.dart';
import '/functions/alert_dialog.dart';
import 'shipperApis/isolatedShipperGetData.dart';

class AddUserFunctions {
  FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference ref = FirebaseDatabase.instance.ref();
  NavigationIndexController navigationIndexController =
      Get.put(NavigationIndexController());

  //TODO: The functions getUserByMail and getUserByPhone are used to get the uid of the required employee for adding him to the database.
  //TODO: These functions are called respectively whether employer given mailId or phone number of an employee.

  getUserByMail(String mail) async {
    final String uidApiMail = dotenv.get("getUidByMail");
    http.Response response = await http
        .get(Uri.parse("$uidApiMail/$mail"), headers: <String, String>{
      'Content-Type': 'application/json; charset = UTF-8',
    });
    debugPrint(mail);
    debugPrint("API Response Body: ${response.body}");

    var jsonData;

    if (response.body.contains("{")) {
      jsonData = json.decode(response.body);
      debugPrint("JSON Data: $jsonData");

      if (jsonData != null && jsonData["transportererrorresponse"] != null) {
        var debugMessage = jsonData["transportererrorresponse"]["debugMessage"];
        if (debugMessage != null &&
            debugMessage.contains("No user record found")) {
          //isError = true;
          return "No user Found";
        }
      }
    } else {
      //isError = true;
      return "Invalid response from the API";
    }
    if (jsonData != null && jsonData["uid"] != null) {
      return jsonData["uid"];
    }
  }

  getUserByPhone(String phoneNumber) async {
    final String uidApiPhone = dotenv.get("getUidByPhoneNumber");
    http.Response response =
        await http.get(Uri.parse("$uidApiPhone/+91$phoneNumber"));
    if (response.body.contains("{")) {
      var jsonData = json.decode(response.body);
      if (jsonData["transportererrorresponse"]["debugMessage"]
          .toString()
          .contains("No user record found")) {
        //isError = true;
        return "No user Found";
      }
    } else {
      //isError = true;
      return response.body;
    }
  }

//This function is used to fetch the shipperId of the user 
Future<String?> getShipperId(String? mail) async {
  final String shipperApi = dotenv.get("shipperApiUrl");
  http.Response response = await http.get(Uri.parse("$shipperApi?emailId=$mail"),
  headers: <String,String>{
    'Content-Type' : 'application/json; charset = UTF-8'
  },);

  if (response.statusCode == 200) {
    var jsonData = json.decode(response.body);
    if (jsonData is List && jsonData.isNotEmpty) {
      var firstShipper = jsonData[0];
      if (firstShipper["shipperId"] != null) {
        return firstShipper["shipperId"];
      }
    }
  }
  return null;
}

// This function is used to change the company name of the user(whom we are adding) with the owner's company name
  updateCompanyName(String? phoneOrMail,String companyName) async {
    String? sid;
    final String shipperApi = dotenv.get("shipperApiUrl");
    sid = await getShipperId(phoneOrMail!);
    final Map<String, dynamic> userData = {
      'companyName': companyName
    };
    http.Response response = await http.put(Uri.parse("$shipperApi/$sid"),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(userData),);
    debugPrint(response.body);
    if(response.statusCode == 200 || response.statusCode == 201){
      debugPrint("companyName Changed");
    }else{
     debugPrint("companyName not Changed");
    }
  }

  //TODO: This function is called for adding the employee to the company's database so that he can use employer's shipper Id
  addUser(String? phoneOrMail, String companyName,
      {required BuildContext context, required String role}) async {
    String? uid;
    // Changed the type to String?
    if (phoneOrMail.toString().isNumericOnly &&
        phoneOrMail.toString().length == 10) {
      uid = await getUserByPhone(phoneOrMail!);
    } else if (phoneOrMail.toString().isEmail) {
      uid = await getUserByMail(phoneOrMail!);
      if (uid == null) {
        debugPrint('data is not there');
      }
    }

    if (uid == null) {
      // Handle the case when the user is not found.
      alertDialog('Add Employee', 'Employee Not Found', context);
    } else {
      final newEmployeeRef =
          ref.child("companies/${companyName.capitalizeFirst}/members");
      newEmployeeRef.update({
        uid: "employee",
      }).then((value) {
        updateCompanyName(phoneOrMail, companyName);
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return completedDialog(
              upperDialogText: 'congratulations'.tr,
              lowerDialogText: 'You Have Successfully added employee',
            );
          },
        );
        Timer(
          const Duration(seconds: 3),
          () => {
            kIsWeb
                ? Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomeScreenWeb(
                        index: screens.indexOf(employeeListScreen),
                        selectedIndex:
                            screens.indexOf(accountVerificationStatusScreen),
                      ),
                    ),
                  )
                : Get.offAll(() => NavigationScreen()),
            navigationIndexController.updateIndex(2),
          },
        );
      }).catchError((error) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return OrderFailedAlertDialog();
          },
        );
        print("Error while updating employee: $error");
      });
    }
  }

//This function is used to fetch the role of the current user who is logged in.
  Future<bool> getCurrentUserRole(String? userEmail) async{
    String? uid;
    final bool role;
    uid = await getUserByMail(userEmail!);
    //print(_fetchUserRole(uid));
    role = await _fetchUserRole(uid) ;
    return role;
  }

//Fetch the role of the user from the firebase.
Future<bool> _fetchUserRole(uid) async {
  DatabaseReference ref = FirebaseDatabase.instance.ref();
  String userRole = " ";
  final employeeRef = await ref.child(
      "companies/${shipperIdController.companyName.value.capitalizeFirst}/members/$uid").get();
  try{ 
    if(employeeRef.exists){
      debugPrint(employeeRef.value as String?);
      userRole = employeeRef.value.toString();
      if(userRole == 'owner'){
        return true;
      }
    }}catch (error) {
      debugPrint("Error Occurred while fetching user data: $error");
    }
  return false;
}

}
