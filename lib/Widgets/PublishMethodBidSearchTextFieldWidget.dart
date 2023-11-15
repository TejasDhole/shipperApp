import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:shipper_app/constants/colors.dart';
import 'package:shipper_app/constants/fontSize.dart';
import 'package:shipper_app/controller/addLocationDrawerToggleController.dart';

class PublishBidSearchTextFieldWidget extends StatelessWidget {
  AddLocationDrawerToggleController addLocationDrawerToggleController =
      Get.put(AddLocationDrawerToggleController());
  TextEditingController txtController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (addLocationDrawerToggleController.searchTransporterText.value != '') {
        txtController.text =
            addLocationDrawerToggleController.searchTransporterText.value;
      }
      txtController.moveCursorToEnd();
      return Expanded(
          flex: 4,
          child: Container(
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                color: greyBorderColor,
                offset: Offset(0, 10),
                blurStyle: BlurStyle.normal,
                blurRadius: 10,
              ),
            ], borderRadius: BorderRadius.circular(10), color: offWhite),
            child: TextField(
              controller: txtController,
              onChanged: (value) {
                addLocationDrawerToggleController
                    .updateSearchTransporterText(value);
              },
              style: TextStyle(
                  color: kLiveasyColor,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Montserrat',
                  fontSize: size_8),
              textAlign: TextAlign.center,
              cursorColor: kLiveasyColor,
              cursorWidth: 1,
              mouseCursor: SystemMouseCursors.click,
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding:
                    EdgeInsets.only(bottom: 15, left: 10, right: 10, top: 20),
                hintText: 'Search Transporter',
                hintStyle: TextStyle(
                    color: borderLightColor,
                    fontFamily: 'Montserrat',
                    fontSize: size_8),
                prefixIcon: Icon(
                  Icons.search,
                  color: borderLightColor,
                ),
              ),
            ),
          ));
    });
  }
}
