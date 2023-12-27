import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shipper_app/constants/colors.dart';
import 'package:shipper_app/constants/fontSize.dart';
import 'package:shipper_app/constants/fontWeights.dart';

// ignore: non_constant_identifier_names
Container EwayBillsTableHeader(context) {
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
    height: 70,
    decoration: const BoxDecoration(
        color: Color(0xfff2f5ff),
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10), topRight: Radius.circular(10))),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
            flex: 20,
            child: Center(
                child: Text(
              'E-way Bill Date',
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                color: Colors.black,
                fontSize: size_8,
                fontWeight: mediumBoldWeight,
              ),
            ))),
        const VerticalDivider(color: greyShade, thickness: 1),
        Expanded(
            flex: 25,
            child: Center(
                child: Text(
              'Route',
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                  color: Colors.black,
                  fontSize: size_8,
                  fontWeight: mediumBoldWeight),
            ))),
        const VerticalDivider(color: greyShade, thickness: 1),
        Expanded(
            flex: 30,
            child: Center(
                child: Text(
              'Transporter Name',
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
            flex: 15,
            child: Center(
                child: Text(
              'Vehicle No',
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                fontSize: size_8,
                color: Colors.black,
                fontWeight: mediumBoldWeight,
              ),
            ))),
        const VerticalDivider(color: greyShade, thickness: 1),
        Expanded(
            flex: 30,
            child: Center(
                child: Text(
              'ETA',
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
            flex: 15,
            child: Center(
                child: Text(
              'Track',
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                fontSize: size_8,
                color: Colors.black,
                fontWeight: mediumBoldWeight,
              ),
            ))),
      ],
    ),
  );
}
