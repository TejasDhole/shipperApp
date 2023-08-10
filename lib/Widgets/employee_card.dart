import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shipper_app/Widgets/alertDialog/update_employee_alert_dialog.dart';
import 'package:shipper_app/Widgets/customRoleCell.dart';
import 'package:shipper_app/Widgets/remove_employee_alert_dialog.dart';
import 'package:shipper_app/functions/get_role_of_employee.dart';
import 'package:shipper_app/models/company_users_model.dart';
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

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
// future: fetchUserData(companyUsersModel.uid),
//       builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
//         if(snapshot.hasData){
//       return Container(
//         margin: EdgeInsets.only(bottom: space_2),
//         child: Card(
//           color: Colors.white,
//           elevation: 3,
//           child: Container(
//             padding:
//                 EdgeInsets.only(bottom: space_2, left: space_2, right: space_2),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       "Employee Name/Id: ${snapshot.data[0]!}",
//                       style: TextStyle(
//                           fontSize: kIsWeb ? size_8 : size_4,
//                           color: veryDarkGrey,
//                           fontFamily: 'montserrat'),
//                     ),
//                     PopupMenuButton<PopUpMenuForEmployee>(
//                         offset: Offset(0, space_2),
//                         shape: RoundedRectangleBorder(
//                             borderRadius:
//                                 BorderRadius.all(Radius.circular(radius_2))),
//                         onSelected: (item) => onSelected(context, item),
//                         itemBuilder: (context) => [
//                               ...MenuItemsForEmployee.listItem
//                                   .map(showEachItemFromList)
//                                   .toList(),
//                             ]),
//                   ],
//                 ),
//                 SizedBox(
//                   height: space_2,
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       "email : ${snapshot.data[1]!}",
//                       style: TextStyle(
//                           fontSize: kIsWeb ? size_8 : size_6,
//                           color: veryDarkGrey,
//                           fontFamily: 'montserrat'),
//                     ),
//                   ],
//                 ),

//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       "role : ${companyUsersModel.role}",
//                       style: TextStyle(
//                           fontSize: kIsWeb ? size_8 : size_6,
//                           color: veryDarkGrey,
//                           fontFamily: 'montserrat'),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       );}else{
//         return Container();
//       }
//       }
//     );
  // }
  List<Map<String, dynamic>> employeeDataList = [];

// Function to add an employee to the list
  void addEmployee(Map<String, dynamic> employeeData) {
    employeeDataList.add(employeeData);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchUserData(companyUsersModel.uid),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          // Assuming snapshot.data contains the data in the format [Name, Email, Role]
          String name = snapshot.data[0]!;
          String email = snapshot.data[1]!;
          String role = companyUsersModel.role;

          // Create a map to hold the data of the current employee
          Map<String, dynamic> employeeData = {
            'Name': name,
            'Email': email,
            'Role': role,
          };
          return Expanded(
        child: Row(
          children: [
            Expanded(
                flex: 4,
                child: Center(
                    child: Container(
                        padding: EdgeInsets.only(left: 8,top : 12),
                        child: Text(
                          '$name',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                              color: kLiveasyColor,
                              fontSize: 15,
                              fontFamily: 'Montserrat'),
                        )))),
            VerticalDivider(
              color: Colors.grey,
            ),

            Expanded(
                flex: 5,
                child: Center(
                    child: Container(
                        padding: EdgeInsets.only(left: 8,top : 12),
                        child: Text(
                          '$email',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: kLiveasyColor,
                              fontSize: 15,
                              fontFamily: 'Montserrat'),
                        )))),
            VerticalDivider(
              color: Colors.grey,
            ),

            Expanded(
                flex: 3,
                child: Center(
                    child: Container(
                        padding: EdgeInsets.only( top : 12),
                        child: CustomRole(
                              selectedRole: '$role',
                              roleChanged: (newRole) {
                                Future.delayed(Duration.zero, () {
                                  updateUser(context, newRole);
                                });
                              }),))),
            VerticalDivider(
              color: Colors.grey,
            ),

            Expanded(
                flex: 3,
                child: Center(
                    child: Container(
                        padding: EdgeInsets.only(left: 8,top : 12),
                        // child: IconButton(
                        //     icon: const Icon(),
                        //     color: darkBlueTextColor,
                        //     onPressed: () {
                        //       // Call the delete function with employee data
                        //       removeUser(context, '$email');
                        //     },
                        //   ),
                        child: GestureDetector(
                          onTap: (){
                            removeUser(context, '$email');
                          },
                          child: const Image(
                                              image: AssetImage(
                                                  'assets/icons/deleteIcon.png')),
                        ),
                          ))),
            
            ],
            ),
            );

          // Add the current employee data to the list
         // addEmployee(employeeData);

          // return Column(
          //   children: [
              
          //    Container(
          //     margin: EdgeInsets.only(bottom: space_2),
              
          //     child: Card(
          //       color: Colors.white,
          //       elevation: 3,
          //       child: Container(
          //         padding: EdgeInsets.only(
          //             bottom: space_2, left: space_2, right: space_2),
          //         child: DataTable(
          //           columns: [],
          //           rows: employeeDataList.map((data) {
          //             return DataRow(cells: [
          //               DataCell(Text(data['Name'],
          //                   style: GoogleFonts.montserrat(
          //                       color: darkBlueTextColor,
          //                       fontWeight: FontWeight.w500))),
          //               DataCell(Text(data['Email'],
          //                   style: GoogleFonts.montserrat(
          //                       color: darkBlueTextColor,
          //                       fontWeight: FontWeight.w500))),
          //               DataCell(
          //                 CustomRole(
          //                     selectedRole: data['Role'],
          //                     roleChanged: (newRole) {
          //                       Future.delayed(Duration.zero, () {
          //                         updateUser(context, newRole);
          //                       });
          //                     }),
          //               ),
          //               DataCell(
          //                 IconButton(
          //                   icon: const Icon(Icons.delete),
          //                   color: darkBlueTextColor,
          //                   onPressed: () {
          //                     // Call the delete function with employee data
          //                     removeUser(context, data['Email']);
          //                   },
          //                 ),
          //               ),
          //             ]);
          //           }).toList(),
          //         ),
          //       ),
          //     ),
          //   ),
          //   ]
          // );
          
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

  // void onSelected(BuildContext context, PopUpMenuForEmployee item) {
  //   switch (item) {
  //     case MenuItemsForEmployee.itemEdit:
  //       updateUser(context);
  //       break;
  //     case MenuItemsForEmployee.itemRemove:
  //       removeUser(context);
  //       break;
  //   }
  // }

  void updateUser(BuildContext context, String newRole) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return UpdateEmployeeRole(
              employeeUid: companyUsersModel.uid, selectedRole: newRole);
        });
  //   UpdateEmployeeRole updateEmployeeRole = UpdateEmployeeRole(
  //   employeeUid: companyUsersModel.uid,
  //   selectedRole: newRole,
  // );
  // updateEmployeeRole._showAlertDialog(context);
  }

  removeUser(BuildContext context, String name) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return RemoveEmployee(
              employeeUid: companyUsersModel.uid, employeeName: name);
        });
  }

  Future<List> fetchUserData(String uid) async {
    try {
      final String uidApiEmail = dotenv.get("getUid");
      final response = await http
          .get(Uri.parse("$uidApiEmail/$uid"), headers: <String, String>{
        'Content-Type': 'application/json; charset = UTF-8',
      });

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final email = jsonData['email'];
        final name = jsonData['name'] ?? '';

        // final user = User(
        //   name: jsonData['name'] ?? '',
        //   email: jsonData['email'] ?? '',
        //   // Add other properties as per your user data model
        // );

        // Print the user data here
        // print('User Name: ${user.name}');
        // print('User Email: ${user.email}');
        // Print other properties or use the data as per your requirement

        return [name, email];
      } else {
        print('Request failed with status: ${response.statusCode}.');
        return [];
      }
    } catch (e) {
      print('Error fetching user data: $e');
      return [];
    }
  }
}

// class EmployeeCard extends StatefulWidget {
//   CompanyUsers companyUsersModel;

//   EmployeeCard({Key? key, required this.companyUsersModel}) : super(key: key);

//   @override
//   _EmployeeCardState createState() => _EmployeeCardState();
// }

// class _EmployeeCardState extends State<EmployeeCard> {
//   List<Map<String, String>> employeeDataList = [];

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<List<String>>(
//       future: fetchUserData(widget.companyUsersModel.uid),
//       builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return CircularProgressIndicator(); // Show a loader while fetching data
//         } else if (snapshot.hasData && snapshot.data!.length >= 2) {
//           String name = snapshot.data![0];
//           String email = snapshot.data![1];
//           String role = widget.companyUsersModel.role;

//           Map<String, String> employeeData = {
//             'Name': name,
//             'Email': email,
//             'Role': role,
//           };

//           addEmployee(employeeData);

//           return Container(
//             margin: EdgeInsets.only(bottom: space_2),
//             child: Card(
//               color: Colors.white,
//               elevation: 3,
//               child: Container(
//                 padding: EdgeInsets.only(bottom: space_2, left: space_2, right: space_2),
//                 child: DataTable(
//                   columns: [
//                     DataColumn(label: Text('Name')),
//                     DataColumn(label: Text('Email')),
//                     DataColumn(label: Text('Role')),
//                   ],
//                   rows: employeeDataList.map((data) {
//                     return DataRow(cells: [
//                       DataCell(Text(data['Name']!)),
//                       DataCell(Text(data['Email']!)),
//                       DataCell(Text(data['Role']!)),
//                     ]);
//                   }).toList(),
//                 ),
//               ),
//             ),
//           );
//         } else {
//           return Container(); // Handle the case when data is not available
//         }
//       },
//     );
//   }

//   void addEmployee(Map<String, String> employeeData) {
//     setState(() {
//       employeeDataList.add(employeeData);
//     });
//   }

//   // ... (rest of the code remains the same)
//     PopupMenuItem<PopUpMenuForEmployee> showEachItemFromList(
//           PopUpMenuForEmployee item) =>
//       PopupMenuItem<PopUpMenuForEmployee>(
//           value: item,
//           child: Row(
//             children: [
//               Image(
//                 image: AssetImage(item.iconImage),
//                 height: size_6 + 1,
//                 width: size_6 + 1,
//               ),
//               SizedBox(
//                 width: space_1 + 2,
//               ),
//               Text(
//                 item.itemText,
//                 style: TextStyle(
//                   fontWeight: mediumBoldWeight,
//                 ),
//               ),
//             ],
//           ));

//   void onSelected(BuildContext context, PopUpMenuForEmployee item) {
//     switch (item) {
//       case MenuItemsForEmployee.itemEdit:
//         updateUser(context);
//         break;
//       case MenuItemsForEmployee.itemRemove:
//         removeUser(context);
//         break;
//     }
//   }

//   updateUser(BuildContext context) {
//     showDialog(
//         context: context,
//         builder: (BuildContext context) {

//           return UpdateEmployeeRole(employeeUid: companyUsersModel.uid);
//         });
//   }

//   removeUser(BuildContext context) {
//     showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return RemoveEmployee(employeeUid: companyUsersModel.uid);
//         });
//   }

//   Future<List<String>> fetchUserData(String uid) async {
//   try {
//     final String uidApiEmail = dotenv.get("getUid");
//     final response = await http.get(Uri.parse("$uidApiEmail/$uid"), headers: <String, String>{
//       'Content-Type' : 'application/json; charset = UTF-8',
//     });

//     if (response.statusCode == 200) {
//       final jsonData = json.decode(response.body);
//       final email = jsonData['email'];
//       final name = jsonData['name'] ?? '';

//       return [name, email];
//     } else {
//       print('Request failed with status: ${response.statusCode}.');
//       return []; // Return an empty list if the request fails
//     }
//   } catch (e) {
//     print('Error fetching user data: $e');
//     return []; // Return an empty list in case of an error
//   }
// }

// }

