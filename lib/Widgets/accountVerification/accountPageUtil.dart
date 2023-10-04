import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shipper_app/screens/accountScreens/account_details.dart';
import '/controller/shipperIdController.dart';

class AccountPageUtil extends StatelessWidget {
  AccountPageUtil({super.key});
  ShipperIdController shipperIdController = Get.put(ShipperIdController());

  @override
  Widget build(BuildContext context) {
    return AccountScreen();
  }
}
