import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shipper_app/Widgets/showSnackBarTop.dart';
import 'package:shipper_app/constants/colors.dart';
import 'package:shipper_app/constants/fontSize.dart';
import 'package:shipper_app/controller/facilityController.dart';
import 'package:shipper_app/functions/fetchPinCodeDetails.dart';

class FacilityPinCodeTextFieldWidget extends StatelessWidget {
  TextEditingController pinCodeController = TextEditingController();
  FacilityController facilityController = Get.put(FacilityController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (facilityController.pinCode.value.toString() != '') {
        pinCodeController.text = facilityController.pinCode.value.toString();
      } else {
        pinCodeController.clear();
      }
      return Container(
        width: MediaQuery.of(context).size.width * 0.1,
        child: TextField(
          controller: pinCodeController,
          keyboardType: TextInputType.number,
          maxLength: 6,
          onChanged: (value) async {
            if (pinCodeController.text.length == 6) {
              try {
                bool status = await fetchPinCodeDetails(
                    int.parse(pinCodeController.text));
                if (!status) {
                  showSnackBar('Enter Valid PinCode !!!', deleteButtonColor,
                      Icon(Icons.warning), context);
                }
              } catch (error) {
                showSnackBar('Error: $error !!!', deleteButtonColor,
                    Icon(Icons.report_gmailerrorred_sharp), context);
              }
            }
          },
          style: TextStyle(
              color: kLiveasyColor, fontFamily: 'Montserrat', fontSize: size_8),
          textAlign: TextAlign.center,
          mouseCursor: SystemMouseCursors.click,
          decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  borderSide: BorderSide(color: borderLightColor, width: 0.5)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  borderSide: BorderSide(color: black, width: 0.5))),
        ),
      );
    });
  }
}
