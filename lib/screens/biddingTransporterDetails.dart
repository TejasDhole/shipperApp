import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shipper_app/Widgets/Header.dart';
import 'package:shipper_app/Widgets/buttons/backButtonWidget.dart';
import 'package:shipper_app/constants/colors.dart';
import 'package:shipper_app/constants/fontSize.dart';
import 'package:shipper_app/constants/fontWeights.dart';
import 'package:shipper_app/constants/screens.dart';
import 'package:shipper_app/screens/myLoadPages/biddingScreen.dart';

class biddingTrasnporterDetails extends StatelessWidget {
  final String? transporterName;
  final String? transporterCompanyName;
  final String? transporterPhoneNo;
  final String? transporterEmail;
  final String? loadId;
  final String? loadingPointCity;
  final String? unloadingPointCity;

  biddingTrasnporterDetails(
      {super.key,
      this.transporterName,
      this.transporterPhoneNo,
      this.transporterEmail,
      this.transporterCompanyName,
      required this.loadId,
      required this.loadingPointCity,
      required this.unloadingPointCity});

  @override
  Widget build(BuildContext context) {
    TextEditingController transporterNameController = TextEditingController();
    TextEditingController transporterCompanyController =
        TextEditingController();
    TextEditingController transporterPhoneController = TextEditingController();
    TextEditingController transporterEmailController = TextEditingController();
    transporterNameController.text = transporterName ?? 'NA';
    transporterPhoneController.text = transporterPhoneNo ?? 'NA';
    transporterCompanyController.text = transporterCompanyName ?? 'NA';
    transporterEmailController.text = transporterEmail ?? 'NA';
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.only(left: 20, top: 20, bottom: 20),
            decoration: BoxDecoration(
              color: headerLightBlueColor,
            ),
            child: Row(
              children: [
                Text('Transporter Details',
                    style: TextStyle(
                      fontSize: size_10 - 1,
                      fontWeight: mediumBoldWeight,
                    )),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 20, top: 20, bottom: 20),
            child: Row(
              children: [
                BackButtonWidget(
                    previousPage: BiddingScreens(
                        loadId: loadId,
                        loadingPointCity: loadingPointCity,
                        unloadingPointCity: unloadingPointCity),
                    selectedIndex: screens.indexOf(postLoadScreen)),
                SizedBox(
                  width: 20,
                ),
                Text(
                  'Back',
                  style: TextStyle(
                      fontSize: size_8,
                      color: kLiveasyColor,
                      fontFamily: 'Montserrat'),
                )
              ],
            ),
          ),
          Container(
            height: 10,
            color: lineDividerColor,
          ),
          Expanded(
              child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 40,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: TextField(
                    readOnly: true,
                    controller: transporterNameController,
                    style: TextStyle(
                        color: liveasyBlackColor,
                        fontFamily: 'Montserrat',
                        fontSize: size_8),
                    textAlign: TextAlign.center,
                    cursorColor: kLiveasyColor,
                    cursorWidth: 1,
                    mouseCursor: SystemMouseCursors.text,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.zero,
                            borderSide: BorderSide(
                                color: borderLightColor, width: 1.5)),
                        label: Text('Transporter Name',
                            style: TextStyle(
                                color: kLiveasyColor,
                                fontFamily: 'Montserrat',
                                fontSize: size_10,
                                fontWeight: FontWeight.w600),
                            selectionColor: kLiveasyColor),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.zero,
                            borderSide:
                                BorderSide(color: truckGreen, width: 1.5))),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: TextField(
                    readOnly: true,
                    controller: transporterCompanyController,
                    style: TextStyle(
                        color: liveasyBlackColor,
                        fontFamily: 'Montserrat',
                        fontSize: size_8),
                    textAlign: TextAlign.center,
                    cursorColor: kLiveasyColor,
                    cursorWidth: 1,
                    mouseCursor: SystemMouseCursors.text,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.zero,
                            borderSide: BorderSide(
                                color: borderLightColor, width: 1.5)),
                        label: Text('Company Name',
                            style: TextStyle(
                                color: kLiveasyColor,
                                fontFamily: 'Montserrat',
                                fontSize: size_10,
                                fontWeight: FontWeight.w600),
                            selectionColor: kLiveasyColor),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.zero,
                            borderSide:
                                BorderSide(color: truckGreen, width: 1.5))),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: TextField(
                    readOnly: true,
                    controller: transporterEmailController,
                    style: TextStyle(
                        color: liveasyBlackColor,
                        fontFamily: 'Montserrat',
                        fontSize: size_8),
                    textAlign: TextAlign.center,
                    cursorColor: kLiveasyColor,
                    cursorWidth: 1,
                    mouseCursor: SystemMouseCursors.text,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.zero,
                            borderSide: BorderSide(
                                color: borderLightColor, width: 1.5)),
                        label: Text('Transporter Email',
                            style: TextStyle(
                                color: kLiveasyColor,
                                fontFamily: 'Montserrat',
                                fontSize: size_10,
                                fontWeight: FontWeight.w600),
                            selectionColor: kLiveasyColor),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.zero,
                            borderSide:
                                BorderSide(color: truckGreen, width: 1.5))),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: TextField(
                    readOnly: true,
                    controller: transporterPhoneController,
                    style: TextStyle(
                        color: liveasyBlackColor,
                        fontFamily: 'Montserrat',
                        fontSize: size_8),
                    textAlign: TextAlign.center,
                    cursorColor: kLiveasyColor,
                    cursorWidth: 1,
                    mouseCursor: SystemMouseCursors.text,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.zero,
                            borderSide: BorderSide(
                                color: borderLightColor, width: 1.5)),
                        label: Text('Phone Number',
                            style: TextStyle(
                                color: kLiveasyColor,
                                fontFamily: 'Montserrat',
                                fontSize: size_10,
                                fontWeight: FontWeight.w600),
                            selectionColor: kLiveasyColor),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.zero,
                            borderSide:
                                BorderSide(color: truckGreen, width: 1.5))),
                  ),
                ),
              ],
            ),
          ))
        ],
      ),
    );
  }
}
