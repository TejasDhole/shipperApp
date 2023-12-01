import 'dart:convert';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shipper_app/Widgets/alertDialog/update_employee_alert_dialog.dart';
import 'package:shipper_app/Widgets/customRoleCell.dart';
import 'package:shipper_app/Widgets/remove_employee_alert_dialog.dart';
import 'package:shipper_app/controller/shipperIdController.dart';
import 'package:shipper_app/functions/add_user_functions.dart';
import 'package:shipper_app/functions/fetchUserData.dart';
import 'package:shipper_app/functions/get_role_of_employee.dart';
import 'package:shipper_app/models/company_users_model.dart';
import 'package:shipper_app/responsive.dart';
import '../constants/colors.dart';
import '../constants/fontSize.dart';
import '../constants/fontWeights.dart';
import '../constants/radius.dart';
import '../constants/spaces.dart';
import '../models/popup_model_for_employee_card.dart';

//TODO: This card is used to display the employee name/uid and role in the company and also we can edit the role as well as delete the employee from company database
class EmployeeCard extends StatelessWidget {
  CompanyUsers companyUsersModel;
  
  EmployeeCard({Key? key, required this.companyUsersModel}) : super(key: key);

  List<Map<String, dynamic>> employeeDataList = [];

// Function to add an employee to the list
  void addEmployee(Map<String, dynamic> employeeData) {
    employeeDataList.add(employeeData);
  }

  @override
  Widget build(BuildContext context) {
    bool isMobile = Responsive.isMobile(context);
    return FutureBuilder(
      future: fetchUserData(companyUsersModel.uid),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          // Assuming snapshot.data contains the data in the format [Name, Email, Role]
          String name = snapshot.data[0]!;
          String email = snapshot.data[1]!;
          String role = snapshot.data[2];

          // Create a map to hold the data of the current employee
          Map<String, dynamic> employeeData = {
            'Name': name,
            'Email': email,
            'Role': role,
          };
          return Responsive.isMobile(context)   
              ? Container(width: 70, height : 170, margin: const EdgeInsets.only(top: 1, bottom : 40, left: 13, right: 13),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3.0), 
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5), 
                    spreadRadius: 2, 
                    blurRadius: 5,
                    offset: const Offset(0, 3), 
                  ),
                ],
                color: Colors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [ 
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0,right: 16.0, top: 14.0,bottom: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '$name',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: kLiveasyColor,
                            fontSize: 15,
                            fontFamily: 'Montserrat'),
                        ),
                        GestureDetector(
                          onTap: () async {
                            bool Role = await _fetchUserRole(); 
                            if(Role){
                              removeUser(context, '$email');
                            }else{
                              showNotAllowedPopup(context);
                            }
                          },
                          child: const Image(image: AssetImage('assets/icons/deleteIcon.png')))
                      ],
                    ),
                  ), 
                  Padding(
                    padding: const EdgeInsets.only(left:16.0,right: 16.0,top:2.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Email',
                          style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w500,
                            color: sideBarTextColor
                          )
                        ),
                        Text(
                          '$email',
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            color: kLiveasyColor,
                            fontSize: 15,
                            fontFamily: 'Montserrat'),
                        )
                      ],
                    ),
                  ), 
                  Padding(
                    padding: const EdgeInsets.only(left:16.0,right: 16.0,top:4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Role",
                          style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w500,
                            color: sideBarTextColor
                          )
                        ),
                        Container(
                            padding: const EdgeInsets.only(top: 12),
                            child: CustomRole(
                                selectedRole: '$role',
                                roleChanged: (newRole) async{
                                    bool Role = await _fetchUserRole(); 
                                      if(Role){
                                        updateUser(context, newRole);
                                      }else{
                                        showNotAllowedPopup(context);
                                      }
                                }),
                          ),
                      ],
                    ),
                  )
                  ]),
              ):
            
              Row(
              children: [
                Expanded(
                    flex: 4,
                    child: Center(
                        child: Container(
                            padding: const EdgeInsets.only(left: 8, top: 12),
                            child: Text(
                              '$name',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: kLiveasyColor,
                                  fontSize: 15,
                                  fontFamily: 'Montserrat'),
                            )))),
                const VerticalDivider(
                  color: Colors.grey,
                ),
                Expanded(
                    flex: 5,
                    child: Center(
                        child: Container(
                            padding: const EdgeInsets.only(left: 8, top: 12),
                            child: Text(
                              '$email',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  color: kLiveasyColor,
                                  fontSize: 15,
                                  fontFamily: 'Montserrat'),
                            )))),
                const VerticalDivider(
                  color: Colors.grey,
                ),
                Expanded(
                    flex: 3,
                    child: Center(
                        child: Container(
                      padding: const EdgeInsets.only(top: 12),
                      child: CustomRole(
                          selectedRole: '$role',
                          roleChanged: (newRole) async{
                              bool Role = await _fetchUserRole(); 
                                if(Role){
                                  updateUser(context, newRole);
                                }else{
                                  showNotAllowedPopup(context);
                                }
                          }),
                    ))),
                const VerticalDivider(
                  color: Colors.grey,
                ),
                Expanded(
                    flex: 3,
                    child: Center(
                        child: Container(
                      padding: const EdgeInsets.only(left: 8, top: 12),
                      child: GestureDetector(
                        onTap: () async {
                          bool Role = await _fetchUserRole(); 
                          if(Role){
                            removeUser(context, '$email');
                          }else{
                            showNotAllowedPopup(context);
                          }
                        },
                        child: const Image(
                            image: AssetImage('assets/icons/deleteIcon.png')),
                      ),
                    ))),
              ],
            );
        } else {
          return Container();
        }
      },
    );
  }

  PopupMenuItem<PopUpMenuForEmployee> showEachItemFromList(
          PopUpMenuForEmployee item) =>
      PopupMenuItem<PopUpMenuForEmployee>(
          value: item,
          child: Row(
            children: [
              Image(
                image: AssetImage(item.iconImage),
                height: size_6 + 1,
                width: size_6 + 1,
              ),
              SizedBox(
                width: space_1 + 2,
              ),
              Text(
                item.itemText,
                style: TextStyle(
                  fontWeight: mediumBoldWeight,
                ),
              ),
            ],
          ));

  void updateUser(BuildContext context, String newRole) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return UpdateEmployeeRole(
              employeeUid: companyUsersModel.uid, selectedRole: newRole);
        });
  }

  removeUser(BuildContext context, String name) { 
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return RemoveEmployee(
              employeeUid: companyUsersModel.uid, employeeName: name);
        });
  }

  void showNotAllowedPopup(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Permission Denied'),
        content: const Text('This action is only allowed for administrators.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog
            },
            child: Text('OK'),
          ),
        ],
      );
    },
  );
}

Future<bool> _fetchUserRole() async {
  ShipperIdController shipperIdController =
  Get.put(ShipperIdController());

  return (shipperIdController.role.value == 'ADMIN') ? true: false;
}
  
}
