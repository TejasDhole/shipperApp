import 'package:flutter/material.dart';
import 'package:shipper_app/constants/colors.dart';
import 'package:shipper_app/constants/fontWeights.dart';

// This function to create transporter header
Container transporterHeader(context) {
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
    textFontSize = 18;
    containerWidth = 100;
  }
  return Container(
    height: 80,
    decoration: const BoxDecoration(
        color: headerColor,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10), topRight: Radius.circular(10))),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: Center(
            child: Text(
              'Transporter\n Name',
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              softWrap: false,
              style: TextStyle(
                fontWeight: mediumBoldWeight,
                color: black,
                fontSize: textFontSize,
                fontFamily: 'Montserrat',
              ),
            ),
          ),
        ),
        const VerticalDivider(
          color: greyShade,
          thickness: 1,
          width: 0,
        ),
        Expanded(
          flex: 4,
          child: Center(
            child: Text(
              'Contact \n Number',
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              softWrap: false,
              style: TextStyle(
                fontWeight: mediumBoldWeight,
                color: black,
                fontSize: textFontSize,
                fontFamily: 'Montserrat',
              ),
            ),
          ),
        ),
        const VerticalDivider(
          color: greyShade,
          thickness: 1,
          width: 0,
        ),
        Expanded(
          flex: 4,
          child: Center(
            child: Text(
              'Email id',
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              softWrap: false,
              style: TextStyle(
                fontWeight: mediumBoldWeight,
                color: black,
                fontSize: textFontSize,
                fontFamily: 'Montserrat',
              ),
            ),
          ),
        ),
        const VerticalDivider(
          color: greyShade,
          thickness: 1,
          width: 0,
        ),
        Expanded(
          flex: 3,
          child: Text(
            'Pan No.',
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            softWrap: false,
            style: TextStyle(
              fontWeight: mediumBoldWeight,
              color: black,
              fontSize: textFontSize,
              fontFamily: 'Montserrat',
            ),
          ),
        ),
        const VerticalDivider(
          color: greyShade,
          thickness: 1,
          width: 0,
        ),
        Expanded(
          flex: 4,
          child: Center(
            child: Text(
              'GST No.',
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              softWrap: false,
              style: TextStyle(
                fontWeight: mediumBoldWeight,
                color: black,
                fontSize: textFontSize,
                fontFamily: 'Montserrat',
              ),
            ),
          ),
        ),
        const VerticalDivider(
          color: greyShade,
          thickness: 1,
          width: 0,
        ),
        Expanded(
          flex: 5,
          child: Center(
            child: Text(
              'Vendor Code',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: mediumBoldWeight,
                  fontSize: textFontSize,
                  color: black,
                  fontFamily: 'Montserrat'),
            ),
          ),
        ),
      ],
    ),
  );
}
