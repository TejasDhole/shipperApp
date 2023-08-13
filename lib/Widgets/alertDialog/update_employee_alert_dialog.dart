import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shipper_app/constants/colors.dart';
import 'package:shipper_app/functions/alert_dialog.dart';
import 'package:shipper_app/functions/shipperId_fromCompaniesDatabase.dart';
import '../../screens/employee_list_with_roles_screen.dart';
import '../../Web/screens/home_web.dart';
import '../../constants/screens.dart';

//TODO: This is used to update the employee role
class UpdateEmployeeRole extends StatefulWidget {
  final String employeeUid;
  final String selectedRole;

  const UpdateEmployeeRole({
    Key? key,
    required this.employeeUid,
    required this.selectedRole,
  }) : super(key: key);

  @override
  State<UpdateEmployeeRole> createState() => _UpdateEmployeeRoleState();
}

class _UpdateEmployeeRoleState extends State<UpdateEmployeeRole> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return AlertDialog(
      contentPadding: const EdgeInsets.only(left:90, right : 90, top : 90, bottom: 45), // Adjust the padding as needed
      content: SingleChildScrollView(
        child: Column(
          children: [
            Text("Are you sure you want to\nchange the role?",
                textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w600, color: darkBlueTextColor)),
            
          ],
        ),
      ),
      actions: [
        Container(
          width: screenWidth * 0.06,
          padding: EdgeInsets.only(bottom: screenHeight * 0.09),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                backgroundColor: const Color.fromARGB(255, 9, 183, 120),
                
              ),
            onPressed: () {
              _updateUserRole();
             Navigator.of(context).pop(); 
            },
            child: const Text("Ok"),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(right : screenWidth * 0.08,bottom: screenHeight * 0.09),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: const BorderSide(
                    color: Color.fromARGB(
                        255, 237, 74, 74), // Border color for Cancel button
                    width: 2.0, // Border width
                  ),
                ),
                backgroundColor: Colors.white,
              ),
              
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text("Cancel",
            style: TextStyle(
                  color: Color.fromARGB(255, 237, 74, 74),
                  fontWeight: FontWeight.bold,
                ),),
          ),
        ),
      ],
    );
  }

  

  void _updateUserRole() {
    if (widget.selectedRole != null && widget.selectedRole.isNotEmpty) {
      FirebaseDatabase database = FirebaseDatabase.instance;
      DatabaseReference ref = database.ref();
      final updateEmployee = ref.child(
          "companies/${shipperIdController.companyName.value.capitalizeFirst}/members");
      updateEmployee
          .update({
            widget.employeeUid: widget.selectedRole,
          })
          .then((value) => {
                // kIsWeb ?
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
                    )),
                //: Get.off(() => const EmployeeListRolesScreen())
              })
          .catchError((error) {
            debugPrint("Error Occured");
            // Handle error if needed
          });
    }
  }
}
