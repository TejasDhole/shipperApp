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
  // late String selectedRole ;
  //  // Remove the initial assignment

  // @override
  // void initState() {
  //   super.initState();
  //   selectedRole = widget.selectedRole; // Initialize selectedRole from the parameter
  // }
  // List<DropdownMenuItem<String>> _dropDownItem() {
  //   List<String> roles = ['Employee', 'Owner'];
  //   return roles
  //       .map((value) => DropdownMenuItem(value: value, child: Text(value)))
  //       .toList();
  // }

  // @override
  // Widget build(BuildContext context) {
  //   return
  //       //title: const Text('Update Role:'),
  //       ListBody(
  //     children: <Widget>[
  //       //Text("Employee Name/Uid: ${widget.employeeUid}"),
  //       DropdownButton(
  //         value: selectedRole,
  //         items: _dropDownItem(),
  //         onChanged: (value) {
  //           setState(() {
  //             selectedRole = value!;
  //             AlertDialog(
  //               actions: <Widget>[
  //                 _buildButtons(context),
  //               ],
  //             );
  //           });
  //         },
  //       ),
  //     ],
  //   );
  // }

  // Widget _buildButtons(BuildContext context) {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //     children: <Widget>[
  //       ElevatedButton(
  //         style: ElevatedButton.styleFrom(
  //           shape: RoundedRectangleBorder(
  //             borderRadius: BorderRadius.circular(25),
  //           ),
  //           backgroundColor: const Color(0xFF000066),
  //           //fixedSize: Size(28.w, 7.h),
  //         ),
  //         onPressed: () {
  //           // TODO: Here we have the code to update the role of a user
  //           FirebaseDatabase database = FirebaseDatabase.instance;
  //           DatabaseReference ref = database.ref();
  //           final updateEmployee = ref.child(
  //               "companies/${shipperIdController.companyName.value.capitalizeFirst}/members");
  //           updateEmployee.update({
  //             widget.employeeUid: selectedRole,
  //           }).then((value) => {
  //                 // kIsWeb ?
  //                 Navigator.pushReplacement(
  //                     context,
  //                     MaterialPageRoute(
  //                       builder: (context) => kIsWeb
  //                           ? HomeScreenWeb(
  //                               index: screens.indexOf(employeeListScreen),
  //                               selectedIndex: screens
  //                                   .indexOf(accountVerificationStatusScreen),
  //                             )
  //                           : const EmployeeListRolesScreen(),
  //                     )),
  //                 //: Get.off(() => const EmployeeListRolesScreen())
  //               });
  //         },
  //         child: const Text(
  //           "Update",
  //           style: TextStyle(
  //             color: Colors.white,
  //             fontWeight: FontWeight.bold,
  //           ),
  //         ),
  //       ),
  //       ElevatedButton(
  //         style: ElevatedButton.styleFrom(
  //           shape: RoundedRectangleBorder(
  //             borderRadius: BorderRadius.circular(25),
  //           ),
  //           backgroundColor: Colors.white,
  //           // fixedSize: Size(28.w, 7.h),
  //         ),
  //         onPressed: () {
  //           Navigator.pop(context);
  //         },
  //         child: const Text(
  //           "Cancel",
  //           style: TextStyle(
  //             color: Color(0xFF000066),
  //             fontWeight: FontWeight.bold,
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }

  // @override
  // Widget build(BuildContext context) {
  //   _showAlertDialog(context);
  // Row(
  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //   children: <Widget>[
  //     ElevatedButton(
  //       style: ElevatedButton.styleFrom(
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(25),

  //         ),
  //         backgroundColor: const Color.fromARGB(255, 9, 183, 120),
  //         //fixedSize: Size(28.w, 7.h),
  //       ),
  //       onPressed: () {
  //         _updateUserRole();
  //       },
  //       child: const Text(
  //         "Ok",
  //         style: TextStyle(
  //           color: Colors.white,
  //           fontWeight: FontWeight.bold,
  //         ),
  //       ),
  //     ),
  //     ElevatedButton(
  //       style: ElevatedButton.styleFrom(
  //         shape: RoundedRectangleBorder(

  //           borderRadius: BorderRadius.circular(25),
  //           side: const BorderSide(
  //     color: Color.fromARGB(255, 237, 74, 74), // Border color for Cancel button
  //     width: 2.0, // Border width
  //   ),
  //         ),
  //         backgroundColor: Colors.white,
  //         // fixedSize: Size(28.w, 7.h),
  //       ),
  //       onPressed: () {
  //         Navigator.pop(context);
  //       },
  //       child: const Text(
  //         "Cancel",
  //         style: TextStyle(
  //           color: Color.fromARGB(255, 237, 74, 74),
  //           fontWeight: FontWeight.bold,
  //         ),
  //       ),
  //     ),
  //   ],
  // );
  //}

  // @override
  // Widget build(BuildContext context) {
  //   return 

  //      AlertDialog(
  //       //
  //       content: Text("Are you sure you want to\nchange the role?",
  //           textAlign: TextAlign.center,
  //           style: GoogleFonts.montserrat(
  //               fontWeight: FontWeight.w500, color: darkBlueTextColor)),
  //       actions: [
  //         ElevatedButton(
  //           style: ElevatedButton.styleFrom(
  //             shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.circular(10),
  //             ),
  //             backgroundColor: const Color.fromARGB(255, 9, 183, 120),
  //             //fixedSize: Size(28.w, 7.h),
  //           ),
  //           onPressed: () {
  //             _updateUserRole(); // Call _updateUserRole with context and newRole
  //             Navigator.of(context).pop(); // Close the dialog
  //           },
  //           child: const Text("Ok"),
  //         ),
  //         ElevatedButton(
  //           style: ElevatedButton.styleFrom(
  //             shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.circular(10),
  //               side: const BorderSide(
  //                 color: Color.fromARGB(
  //                     255, 237, 74, 74), // Border color for Cancel button
  //                 width: 2.0, // Border width
  //               ),
  //             ),
  //             backgroundColor: Colors.white,
  //           ),
            
  //           onPressed: () {
  //             Navigator.of(context).pop(); // Close the dialog
  //           },
  //           child: const Text(
  //             "Cancel",
  //             style: TextStyle(
  //               color: Color.fromARGB(255, 237, 74, 74),
  //               fontWeight: FontWeight.bold,
  //             ),
  //           ),
  //         ),
  //       ],
  //     );
    
  // }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.all(120), // Adjust the padding as needed
      content: SingleChildScrollView(
        child: Column(
          children: [
            Text("Are you sure you want to\nchange the role?",
                textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w500, color: darkBlueTextColor)),
            
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              backgroundColor: const Color.fromARGB(255, 9, 183, 120),
              fixedSize: Size(50, 7),
            ),
          onPressed: () {
            _updateUserRole();
           Navigator.of(context).pop(); 
          },
          child: const Text("Ok"),
        ),
        ElevatedButton(
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
      ],
    );
  }

  // void _showAlertDialog(BuildContext context) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text("Update Role"),
  //         content: Text("Are you sure you want to update the role?"),
  //         actions: [
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: <Widget>[
  //               ElevatedButton(
  //                 style: ElevatedButton.styleFrom(
  //                   shape: RoundedRectangleBorder(
  //                     borderRadius: BorderRadius.circular(25),
  //                   ),
  //                   backgroundColor: const Color.fromARGB(255, 9, 183, 120),
  //                 ),
  //                 onPressed: () {
  //                   _updateUserRole();
  //                   Navigator.of(context).pop(); // Close the dialog
  //                 },
  //                 child: const Text(
  //                   "Ok",
  //                   style: TextStyle(
  //                     color: Colors.white,
  //                     fontWeight: FontWeight.bold,
  //                   ),
  //                 ),
  //               ),
  //               ElevatedButton(
  //                 style: ElevatedButton.styleFrom(
  //                   shape: RoundedRectangleBorder(
  //                     borderRadius: BorderRadius.circular(25),
  //                     side: const BorderSide(
  //                       color: Color.fromARGB(255, 237, 74, 74),
  //                       width: 2.0,
  //                     ),
  //                   ),
  //                   backgroundColor: Colors.white,
  //                 ),
  //                 onPressed: () {
  //                   Navigator.of(context).pop(); // Close the dialog
  //                 },
  //                 child: const Text(
  //                   "Cancel",
  //                   style: TextStyle(
  //                     color: Color.fromARGB(255, 237, 74, 74),
  //                     fontWeight: FontWeight.bold,
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

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
            // Handle error if needed
          });
    }
  }
}
