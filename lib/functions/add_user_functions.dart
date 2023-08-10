import 'dart:async';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shipper_app/screens/employee_list_with_roles_screen.dart';
import 'package:shipper_app/Web/screens/home_web.dart';
import 'package:shipper_app/screens/accountScreens/accountVerificationStatusScreen.dart';
import '../Widgets/alertDialog/CompletedDialog.dart';
import '../Widgets/alertDialog/orderFailedAlertDialog.dart';
import '../constants/screens.dart';
import '../controller/navigationIndexController.dart';
import '../screens/navigationScreen.dart';
import '/functions/alert_dialog.dart';

class AddUserFunctions {
  FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference ref = FirebaseDatabase.instance.ref();
  NavigationIndexController navigationIndexController =
      Get.put(NavigationIndexController());
      //bool isError = false; 

  //TODO: The functions getUserByMail and getUserByPhone are used to get the uid of the required employee for adding him to the database.
  //TODO: These functions are called respectively whether employer given mailId or phone number of an employee.

  // getUserByMail(String mail) async {
  //   final String uidApiMail = dotenv.get("getUidByMail");
  //   http.Response response = await http.get(Uri.parse("$uidApiMail/$mail"));
  //   if (response.body.contains("{")) {
  //     var jsonData = json.decode(response.body);
  //     print(jsonData);
  //     // if (jsonData["transportererrorresponse"]["debugMessage"]
  //     //     .toString()
  //     //     .contains("No user record found")) {
  //     //   return "No user Found";
  //     // }
  //     if (jsonData != null && jsonData["transportererrorresponse"] != null) {
  //     var debugMessage = jsonData["transportererrorresponse"]["debugMessage"];
  //     if (debugMessage != null && debugMessage.contains("No user record found")) {
  //       return "No user Found";
  //     }
  //   }
  //   } else {
  //     //print('response.body');
  //     return "Invalid response from the API";
  //   }
  //   return null;
  // }

  getUserByMail(String mail) async {
  final String uidApiMail = dotenv.get("getUidByMail");
  http.Response response = await http.get(Uri.parse("$uidApiMail/$mail"), headers: <String, String>{
      'Content-Type' : 'application/json; charset = UTF-8',
    });
    print(mail);
  print("API Response Body: ${response.body}");

  var jsonData;

  if (response.body.contains("{")) {
    jsonData = json.decode(response.body);
    print("JSON Data: $jsonData");

    if (jsonData != null && jsonData["transportererrorresponse"] != null) {
      var debugMessage = jsonData["transportererrorresponse"]["debugMessage"];
      if (debugMessage != null && debugMessage.contains("No user record found")) {
        //isError = true;
        return "No user Found";
      }
      
    }
  } else {
    //isError = true;
    return "Invalid response from the API";
  }
  if (jsonData != null && jsonData["uid"] != null) {
    print(jsonData["uid"]);
    print(jsonData["name"]);
    print(jsonData["email"]);
    print(jsonData["status"]);
    return jsonData["uid"];
    
  }

  // return null;
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

  //TODO: This function is called for adding the employee to the company's database so that he can use employer's shipper Id
  // addUser(String? phoneOrMail, String companyName, {required BuildContext context}) async {
  //   String uid = '';
  //   //TODO: Before adding the user, we will look for him accordingly either by mail Id or mobile number of an employee
  //   // And accordingly the functions are being called to get the uid for the required employee
  //   if (phoneOrMail.toString().isNumericOnly && phoneOrMail.toString().length == 10) {
  //     uid = await getUserByPhone(phoneOrMail!);
  //   } else if(phoneOrMail.toString().isEmail){
  //     uid = await getUserByMail(phoneOrMail!);
  //   }
  //   if (uid == "No user Found") {
  //     alertDialog('Add Employee', 'Employee Not Found', context);
  //   } else {
  //     //TODO: When user is already log in, we can get his uid and we are adding it to the company's database
  //     final newEmployeeRef = ref.child(
  //         "companies/${companyName.capitalizeFirst}/members"); //Database Path for Adding employee
  //     newEmployeeRef
  //         .update({
  //           uid: "employee",
  //         })
  //         .then((value) => {
  //               showDialog(
  //                 context: context,
  //                 builder: (BuildContext context) {
  //                   return completedDialog(
  //                       upperDialogText: 'congratulations'.tr,
  //                       lowerDialogText:
  //                           'You Have Successfully added employee');
  //                 },
  //               ),
  //               Timer(
  //                   const Duration(seconds: 3),
  //                   () => {
  //                         kIsWeb
  //                             ? Navigator.pushReplacement(
  //                                 context,
  //                                 MaterialPageRoute(
  //                                     builder: (context) => HomeScreenWeb(
  //                                           index: screens
  //                                               .indexOf(employeeListScreen),
  //                                           selectedIndex: screens.indexOf(
  //                                               accountVerificationStatusScreen),
  //                                         )))
  //                             : Get.offAll(() => NavigationScreen()),
  //                         navigationIndexController.updateIndex(2),
  //                       }),
  //               //  alertDialog("Added Employee","Employee Added Successfully",context)
  //             })
  //         .catchError((error) {
  //           return showDialog(
  //             context: context,
  //             builder: (BuildContext context) {
  //               return OrderFailedAlertDialog();
  //             },
  //           );
  //           // return alertDialog("Error", "Try After Some Time", context);
  //           // return alertDialog("Error", "$error", context);
  //         });
  //   }
  // }
  addUser(String? phoneOrMail, String companyName, {required BuildContext context, required String role}) async {
  String? uid ; 
  // Changed the type to String?

  if (phoneOrMail.toString().isNumericOnly && phoneOrMail.toString().length == 10) {
      uid = await getUserByPhone(phoneOrMail!);
    } else if(phoneOrMail.toString().isEmail){
      uid = await getUserByMail(phoneOrMail!);
      if(uid==null){
        print('data is not there');
        
      }
    }

  

  if (uid == null ) {
    // Handle the case when the user is not found.

  //   FirebaseAuth auth = FirebaseAuth.instance;

  // // Check if user is already signed in anonymously
  // //if (auth.currentUser == null || auth.currentUser!.isAnonymous) {
  //   try {
  //     // Sign in anonymously
  //     UserCredential userCredential = await auth.signInAnonymously();
  //     String uid = userCredential.user!.uid;
  //     print('aayushi uid is there');
  //     //print(auth.currentUser!.displayName);

  //     // Add the employee to the database using newUserUid
  //     final newEmployeeRef = ref.child(
  //       "companies/${companyName.capitalizeFirst}/members",
  //     ); // Database Path for Adding employee

  //     await newEmployeeRef.update({
  //       uid: "employee",
  //     });

  //     showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return completedDialog(
  //           upperDialogText: 'congratulations'.tr,
  //           lowerDialogText: 'You Have Successfully added employee',
  //         );
  //       },
  //     );

  //     Timer(
  //       const Duration(seconds: 3),
  //       () => {
  //         kIsWeb
  //           ? Navigator.pushReplacement(
  //               context,
  //               MaterialPageRoute(
  //                 builder: (context) => HomeScreenWeb(
  //                   index: screens.indexOf(employeeListScreen),
  //                   selectedIndex: screens.indexOf(accountVerificationStatusScreen),
  //                 ),
  //               ),
  //             )
  //           : Get.offAll(() => NavigationScreen()),
  //         navigationIndexController.updateIndex(2),
  //       },
  //     );
  //   } catch (e) {
  //     print(e);
  //     // Handle the error while signing in anonymously or adding the employee.
  //     showDialog(
        
  //       context: context,
  //       builder: (BuildContext context) {
  //         return OrderFailedAlertDialog();
  //       },
  //     );
  //   }
  //   //}
  //   print(auth.currentUser!.displayName);
    
    alertDialog('Add Employee', 'Employee Not Found', context);
  } 
  // else if (uid == null ) {
  //   // Handle the case when there's an issue with the API response or any other error.
  //   print("API response issue or error occurred");
  //   print("Response from getUserByMail: $uid");
  //   // FirebaseAuth auth = FirebaseAuth.instance;
  //   // try{
  //   //   UserCredential userCredential = await auth.createUserWithEmailAndPassword(
  //   //     email: phoneOrMail, password: )
  //   // }catch (e) {
  //   // // Handle the error while creating the user or adding the employee.
  //   // showDialog(
  //   //   context: context,
  //   //   builder: (BuildContext context) {
  //   //     return OrderFailedAlertDialog();
  //   //   },
  //   // );

  //   //print("Error creating user or updating employee: $e");

    
  
  // } 
  else {

  //   if (uid == null) {
  //   // Handle the case when uid is null
  //   print('UID is null');
  //   return;
  // }
    // Continue with the rest of the code as the uid is not null and not 'No user Found'.
    // The user is found successfully, and you can proceed with the employee addition logic.
    // For example, you can show the completedDialog and navigate to the appropriate screen.
    final newEmployeeRef = ref.child(
      "companies/${companyName.capitalizeFirst}/members"
    ); //Database Path for Adding employee
    newEmployeeRef
      .update({
        uid: "employee",
      })
      .then((value) {
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
                      selectedIndex: screens.indexOf(accountVerificationStatusScreen),
                    ),
                  ),
                )
              : Get.offAll(() => NavigationScreen()),
            navigationIndexController.updateIndex(2),
          },
        );
      })
      .catchError((error) {
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

}
