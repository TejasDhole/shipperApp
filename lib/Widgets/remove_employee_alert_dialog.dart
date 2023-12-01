import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shipper_app/constants/colors.dart';
import 'package:shipper_app/functions/shipperId_fromCompaniesDatabase.dart';
import 'package:shipper_app/responsive.dart';
import '../screens/employee_list_with_roles_screen.dart';
import '../../Web/screens/home_web.dart';
import '../../constants/screens.dart';

//TODO: This is used to remove the employee/user from the company database.
class RemoveEmployee extends StatefulWidget {
  final String employeeUid;
  final String employeeName;
  const RemoveEmployee(
      {Key? key, required this.employeeUid, required this.employeeName})
      : super(key: key);

  @override
  State<RemoveEmployee> createState() => _RemoveEmployeeState();
}

class _RemoveEmployeeState extends State<RemoveEmployee> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return AlertDialog(
      contentPadding: EdgeInsets.only(
          left: Responsive.isMobile(context)
              ? screenWidth * 0.18
              : screenWidth * 0.09,
          right: Responsive.isMobile(context)
              ? screenWidth * 0.18
              : screenWidth * 0.09,
          top: screenHeight * 0.07,
          bottom: screenHeight * 0.03),
      content: Text("Are you sure you want to\ndelete ?",
          textAlign: TextAlign.center,
          style: GoogleFonts.montserrat(
              fontWeight: FontWeight.w500, color: darkBlueTextColor)),
      actions: <Widget>[
        Container(
          width: Responsive.isMobile(context)
              ? screenWidth * 0.2
              : screenWidth * 0.06,
          padding: EdgeInsets.only(bottom: screenHeight * 0.09),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              backgroundColor: deleteButtonColor,
            ),
            onPressed: () async {
              //update company document

              final DocumentReference documentRef = FirebaseFirestore.instance
                  .collection('/Companies')
                  .doc(shipperIdController.companyId.value);

              await documentRef.get().then((doc) {
                if (doc.exists) {
                  Map data = doc.data() as Map;
                  List members = data!["members"];

                  if (members.contains(widget.employeeUid)) {
                    members.remove(widget.employeeUid);
                  }
                  documentRef.update({'members': members}).then(
                      (value) => debugPrint('User Removed Successfully'));

                  //update shipper table/ account

                  final String shipperApiUrl = dotenv.get('shipperApiUrl');

                  Map updateShipper = {
                    "companyId": "",
                    "roles": "VIEWER",
                  };

                  String body = json.encode(updateShipper);
                  http
                      .put(Uri.parse('$shipperApiUrl/${widget.employeeUid}'),
                          headers: <String, String>{
                            'Content-Type': 'application/json; charset=UTF-8',
                          },
                          body: body)
                      .then((response) {
                    if (response.statusCode != 200) {
                      debugPrint('Something wrong');
                    }

                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => kIsWeb
                              ? HomeScreenWeb(
                                  index: screens.indexOf(employeeListScreen),
                                  selectedIndex: screens
                                      .indexOf(accountVerificationStatusScreen),
                                )
                              : const EmployeeListRolesScreen(),
                        ));
                  });
                } else {
                  debugPrint('No such document!');
                }
              });
            },
            child: const Text(
              "Yes",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
              right: Responsive.isMobile(context)
                  ? screenWidth * 0.17
                  : screenWidth * 0.08,
              bottom: screenHeight * 0.09),
          child: Container(
            width: Responsive.isMobile(context)
                ? screenWidth * 0.2
                : screenWidth * 0.07,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  side: const BorderSide(
                    color: okButtonColor,
                    width: 2.0,
                  ),
                  backgroundColor: Colors.white,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  "No",
                  style: TextStyle(
                    color: okButtonColor,
                    fontWeight: FontWeight.bold,
                  ),
                )),
          ),
        ),
      ],
    );
  }
}
