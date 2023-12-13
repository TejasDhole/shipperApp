import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:screenshot/screenshot.dart';
import 'package:shipper_app/constants/colors.dart';
import 'package:shipper_app/constants/fontSize.dart';
import 'package:shipper_app/constants/fontWeights.dart';

Container AccountTableHeader(context) {
  bool small = true;
  double leftRightPadding, textFontSize, containerWidth;
  var screenWidth = MediaQuery.of(context).size.width;
  if (screenWidth < 1400 && screenWidth > 1099) {
    small = true;
  } else {
    small = false;
  }

  if (small) {
    leftRightPadding = 0;
    textFontSize = 12;
    containerWidth = 56;
  } else {
    leftRightPadding = 20;
    textFontSize = 16;
    containerWidth = 100;
  }

  return Container(
    margin : EdgeInsets.only(left: 15,right : 35),
    height: 60,
    decoration: const BoxDecoration(
      color: Color(0xfff2f5ff),
      borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
        ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
            flex: 4,
            child: Center(
                child: Text(
              'Users',
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                color: Colors.black,
                fontSize: size_8,
                fontWeight: mediumBoldWeight,
              ),
            ))),
        const VerticalDivider(color: greyShade, thickness: 1),
        Expanded(
            flex: 5,
            child: Center(
                child: Text(
              'Email',
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                color: Colors.black,
                fontSize: size_8,
                fontWeight: mediumBoldWeight,
              ),
            ))),
        const VerticalDivider(color: greyShade, thickness: 1),
        Expanded(
            flex: 4,
            child: Center(
                child: Text(
              'Role',
              textAlign: TextAlign.center,
              selectionColor: sideBarTextColor,
              style: GoogleFonts.montserrat(
                color: Colors.black,
                fontSize: size_8,
                fontWeight: mediumBoldWeight,
              ),
            ))),
        const VerticalDivider(color: greyShade, thickness: 1),
        Expanded(
            flex: 2,
            child: Center(
                child: Text(
              'Delete',
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                color: Colors.black,
                fontSize: size_8,
                fontWeight: mediumBoldWeight,
              ),
            ))),
      ],
    ),
  );
}
