import 'package:flutter/material.dart';
import 'package:shipper_app/constants/colors.dart';
import 'package:shipper_app/constants/fontSize.dart';
import 'package:shipper_app/constants/fontWeights.dart';

// ignore: non_constant_identifier_names
Container FacilitiesTableHeader(context) {
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
    height: 50,
    decoration: const BoxDecoration(
      color: Color(0xfff2f5ff),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
            flex: 4,
            child: Center(
                child: Text(
              'Party Name',
              textAlign: TextAlign.center,
              style: TextStyle(
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
              'Address',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: size_8,
                  fontWeight: mediumBoldWeight),
            ))),
        const VerticalDivider(color: greyShade, thickness: 1),
        Expanded(
            flex: 5,
            child: Center(
                child: Text(
              'City, State',
              textAlign: TextAlign.center,
              selectionColor: sideBarTextColor,
              style: TextStyle(
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
              '        ',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: size_8,
                color: sideBarTextColor,
                fontWeight: mediumBoldWeight,
              ),
            ))),
      ],
    ),
  );
}
