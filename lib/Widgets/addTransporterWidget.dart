import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:screenshot/screenshot.dart';
import 'package:shipper_app/Widgets/showSnackBarTop.dart';
import 'package:shipper_app/constants/colors.dart';
import 'package:shipper_app/constants/fontSize.dart';
import 'package:shipper_app/controller/addLocationDrawerToggleController.dart';
import 'package:shipper_app/functions/shipperApis/updateShipperTransporterList.dart';
import 'package:shipper_app/functions/transporterApis/getTransporterIdByPhone.dart';

Widget addTransporter(diaLogContext, transporterList) {
  AddLocationDrawerToggleController addLocationDrawerToggleController =
      Get.put(AddLocationDrawerToggleController());
  TextEditingController txtEdtNameController = TextEditingController(),
      txtEdtPhoneNoController = TextEditingController(),
      txtEdtEmailController = TextEditingController(),
      txtEdtPanNoController = TextEditingController(),
      txtEdtGstNoController = TextEditingController(),
      txtEdtVendorNoController = TextEditingController();
  return Container(
    color: offWhite,
    padding: EdgeInsets.all(20),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Enter Transporter Name',
                  style: TextStyle(
                      color: kLiveasyColor,
                      fontSize: size_9,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Montserrat'),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  color: white,
                  child: TextField(
                    controller: txtEdtNameController,
                    style: TextStyle(
                        color: kLiveasyColor,
                        fontFamily: 'Montserrat',
                        fontSize: size_8),
                    textAlign: TextAlign.start,
                    cursorColor: kLiveasyColor,
                    cursorWidth: 1,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.zero,
                            borderSide: BorderSide(color: grey, width: 1)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.zero,
                            borderSide: BorderSide(color: kLiveasyColor, width: 1.5))),
                  ),
                ),
              ],
            )),
            SizedBox(width: 20,),
            Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Enter Transporter Email',
                  style: TextStyle(
                      color: kLiveasyColor,
                      fontWeight: FontWeight.w600,
                      fontSize: size_9,
                      fontFamily: 'Montserrat'),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  color: white,
                  child: TextField(
                    controller: txtEdtEmailController,
                    style: TextStyle(
                        color: kLiveasyColor,
                        fontFamily: 'Montserrat',
                        fontSize: size_8),
                    textAlign: TextAlign.start,
                    cursorColor: kLiveasyColor,
                    cursorWidth: 1,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.zero,
                            borderSide: BorderSide(color: grey, width: 1)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.zero,
                            borderSide: BorderSide(color: kLiveasyColor, width: 1.5))),
                  ),
                ),
              ],
            ))
          ],
        ),

        SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Expanded(child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Enter Transporter Phone No',
                  style: TextStyle(
                      color: kLiveasyColor,
                      fontWeight: FontWeight.w600,
                      fontSize: size_9,
                      fontFamily: 'Montserrat'),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  color: white,
                  child: TextField(
                    controller: txtEdtPhoneNoController,
                    style: TextStyle(
                        color: kLiveasyColor,
                        fontFamily: 'Montserrat',
                        fontSize: size_8),
                    textAlign: TextAlign.start,
                    cursorColor: kLiveasyColor,
                    cursorWidth: 1,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.zero,
                            borderSide: BorderSide(color: grey, width: 1)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.zero,
                            borderSide: BorderSide(color: kLiveasyColor, width: 1.5))),
                  ),
                ),
              ],
            )),
            SizedBox(width: 20,),
            Expanded(child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Enter Pan No (Optional)',
                  style: TextStyle(
                      color: kLiveasyColor,
                      fontWeight: FontWeight.w600,
                      fontSize: size_9,
                      fontFamily: 'Montserrat'),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  color: white,
                  child: TextField(
                    controller: txtEdtPanNoController,
                    style: TextStyle(
                        color: kLiveasyColor,
                        fontFamily: 'Montserrat',
                        fontSize: size_8),
                    textAlign: TextAlign.start,
                    cursorColor: kLiveasyColor,
                    cursorWidth: 1,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.zero,
                            borderSide: BorderSide(color: grey, width: 1)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.zero,
                            borderSide: BorderSide(color: kLiveasyColor, width: 1.5))),
                  ),
                ),
              ],
            ))
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Expanded(child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Enter GST No (Optional)',
                  style: TextStyle(
                      color: kLiveasyColor,
                      fontWeight: FontWeight.w600,
                      fontSize: size_9,
                      fontFamily: 'Montserrat'),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  color: white,
                  child: TextField(
                    controller: txtEdtGstNoController,
                    style: TextStyle(
                        color: kLiveasyColor,
                        fontFamily: 'Montserrat',
                        fontSize: size_8),
                    textAlign: TextAlign.start,
                    cursorColor: kLiveasyColor,
                    cursorWidth: 1,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.zero,
                            borderSide: BorderSide(color: grey, width: 1)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.zero,
                            borderSide: BorderSide(color: kLiveasyColor, width: 1.5))),
                  ),
                ),
              ],
            )),
            SizedBox(width: 20,),
            Expanded(child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Enter Vendor No (Optional)',
                  style: TextStyle(
                      color: kLiveasyColor,
                      fontWeight: FontWeight.w600,
                      fontSize: size_9,
                      fontFamily: 'Montserrat'),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  color: white,
                  child: TextField(
                    controller: txtEdtVendorNoController,
                    style: TextStyle(
                        color: kLiveasyColor,
                        fontFamily: 'Montserrat',
                        fontSize: size_8),
                    textAlign: TextAlign.start,
                    cursorColor: kLiveasyColor,
                    cursorWidth: 1,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.zero,
                            borderSide: BorderSide(color: grey, width: 1)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.zero,
                            borderSide: BorderSide(color: kLiveasyColor, width: 1.5))),
                  ),
                ),
              ],
            ))
          ],
        ),
        SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () {
                String name = txtEdtNameController.text;
                String phone = txtEdtPhoneNoController.text;
                String email = txtEdtEmailController.text;
                String panNo = txtEdtPanNoController.text;
                String gstNo = txtEdtGstNoController.text;
                String vendorNo = txtEdtVendorNoController.text;

                if (name.isNotEmpty &&
                    name != null &&
                    phone.isNotEmpty &&
                    phone != null &&
                    email.isNotEmpty &&
                    email != null) {

                  if(panNo.isNotEmpty && !panNo.length.isEqual(10)){
                    showSnackBar(
                        'Pan No should be 10 Digit.',
                        deleteButtonColor,
                        const Icon(Icons.warning),
                        diaLogContext);
                    return;
                  }

                  if(gstNo.isNotEmpty && !gstNo.length.isEqual(15)){
                    showSnackBar(
                        'Gst No should be 15 Digit.',
                        deleteButtonColor,
                        const Icon(Icons.warning),
                        diaLogContext);

                    return;
                  }

                  getTransporterIdByPhone(phone, email, name, gstNo, panNo, vendorNo)
                      .then((transporterId) {
                    List newAddedTransporter = [
                      email,
                      name,
                      phone,
                      transporterId
                    ];
                    //add new added transporter in List
                    transporterList.add(newAddedTransporter);
                    updateCompanyTransporterList(transporterId, diaLogContext);
                  });
                }
              },
              child: SizedBox(
                width: MediaQuery.of(diaLogContext).size.width * 0.1,
                child: Center(
                  child: Text(
                    'Save',
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        color: white,
                        fontSize: size_9),
                  ),
                ),
              ),
              style: ButtonStyle(
                  mouseCursor:
                      MaterialStatePropertyAll(SystemMouseCursors.click),
                  shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                      side: BorderSide(
                        color: truckGreen,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(5)))),
                  padding: MaterialStatePropertyAll(EdgeInsets.only(
                      left: 20, right: 20, top: 15, bottom: 15)),
                  backgroundColor: MaterialStatePropertyAll(truckGreen)),
            ),
            SizedBox(
              width: 10,
            ),
            OutlinedButton(
                onPressed: () {
                  addLocationDrawerToggleController.toggleAddTransporter(false);
                },
                child: SizedBox(
                  width: MediaQuery.of(diaLogContext).size.width * 0.1,
                  child: Center(
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          color: white,
                          fontSize: size_9),
                    ),
                  ),
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(red),
                  mouseCursor:
                      MaterialStatePropertyAll(SystemMouseCursors.click),
                  shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                      side: BorderSide(
                        color: red,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(5)))),
                  padding: MaterialStatePropertyAll(EdgeInsets.only(
                      left: 20, right: 20, top: 15, bottom: 15)),
                )),
          ],
        )
      ],
    ),
  );
}
