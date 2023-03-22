// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '/constants/fontSize.dart';
// import '/constants/spaces.dart';
// import '/screens/LoginScreens/loginScreenUsingPhone.dart';
// import 'package:location_permissions/location_permissions.dart';
//
// class LocationDisabledScreen extends StatefulWidget {
//   @override
//   _LocationDisabledScreenState createState() => _LocationDisabledScreenState();
// }
//
// class _LocationDisabledScreenState extends State<LocationDisabledScreen> {
//   checkIfLocationPermissionGiven() async {
//     PermissionStatus permission =
//         await LocationPermissions().checkPermissionStatus();
//     print(permission);
//     if (permission == PermissionStatus.granted) {
//       Get.off(LoginScreen());
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     checkIfLocationPermissionGiven();
//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             GestureDetector(
//               onTap: () {
//                 checkIfLocationPermissionGiven();
//               },
//               child: Text(
//                 "Refresh",
//                 style: TextStyle(fontSize: size_15),
//               ),
//             ),
//             SizedBox(
//               height: space_8,
//             ),
//             GestureDetector(
//               onTap: () async {
//                 await LocationPermissions().openAppSettings();
//               },
//               child: Text(
//                 "Open Settings",
//                 style: TextStyle(fontSize: size_15),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
