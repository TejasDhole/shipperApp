import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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
      contentPadding:
          EdgeInsets.only(
            left: Responsive.isMobile(context) ? screenWidth * 0.18 : screenWidth * 0.09, 
            right: Responsive.isMobile(context) ? screenWidth * 0.18 : screenWidth * 0.09, 
            top: screenHeight * 0.07 , 
            bottom: screenHeight * 0.03
          ),
      content: Text("Are you sure you want to\ndelete ?",
          textAlign: TextAlign.center,
          style: GoogleFonts.montserrat(
              fontWeight: FontWeight.w500, color: darkBlueTextColor)),
      actions: <Widget>[
        Container(
          width: Responsive.isMobile(context) ? screenWidth * 0.2 : screenWidth * 0.06,
          padding: EdgeInsets.only(bottom: screenHeight * 0.09),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              backgroundColor: deleteButtonColor,
            ),
            onPressed: () {
              FirebaseDatabase database = FirebaseDatabase.instance;
              DatabaseReference ref = database.ref();
              final updateEmployee = ref.child(
                  "companies/${shipperIdController.companyName.value.capitalizeFirst}/members/${widget.employeeUid}");
              updateEmployee.remove().then((value) => {
                    kIsWeb
                        ? Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomeScreenWeb(
                                      index:
                                          screens.indexOf(employeeListScreen),
                                      selectedIndex:
                                          screens.indexOf(employeeListScreen),
                                    )))
                        : Get.off(() => const EmployeeListRolesScreen())
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
              right: Responsive.isMobile(context) ? screenWidth * 0.17 : screenWidth * 0.08, bottom: screenHeight * 0.09),
          child: Container(
            width: Responsive.isMobile(context) ? screenWidth * 0.2 : screenWidth * 0.07,
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
