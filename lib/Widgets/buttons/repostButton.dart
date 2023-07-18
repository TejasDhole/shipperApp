import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shipper_app/responsive.dart';
import '/constants/colors.dart';
import '/constants/fontSize.dart';
import '/constants/fontWeights.dart';
import '/constants/spaces.dart';
import '/screens/PostLoadScreens/PostLoadScreenLoacationDetails.dart';
import '/screens/myLoadPages/biddingScreen.dart';
import '/screens/PostLoadScreens/postloadnavigation.dart';

// ignore: must_be_immutable
Widget Repostbutton(bool? small, BuildContext context) {
  if (kIsWeb && Responsive.isDesktop(context)) {
    return Expanded(
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Container(
          decoration: BoxDecoration(color: declineButtonRed),
          margin: EdgeInsets.all(0),
          padding: EdgeInsets.only(top: 5, bottom: 5),
          child: TextButton(
            style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.zero),
              )),
              backgroundColor:
                  MaterialStateProperty.all<Color>(declineButtonRed),
            ),
            onPressed: () {
              Get.to(PostLoadNav());
            },
            child: Text(
              'repost'.tr,
              style: TextStyle(
                letterSpacing: 0.7,
                fontWeight: mediumBoldWeight,
                color: white,
                fontSize: size_7,
              ),
            ),
          ),
        ),
      ),
    );
  } else {
    return Container(
      decoration: BoxDecoration(color: declineButtonRed),
      margin: EdgeInsets.all(0),
      padding: EdgeInsets.only(top: 5, bottom: 5),
      child: TextButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.zero),
          )),
          backgroundColor: MaterialStateProperty.all<Color>(declineButtonRed),
        ),
        onPressed: () {
          Get.to(PostLoadNav());
        },
        child: Text(
          'repost'.tr,
          style: TextStyle(
            letterSpacing: 0.7,
            fontWeight: mediumBoldWeight,
            color: white,
            fontSize: size_7,
          ),
        ),
      ),
    );
  }
}
