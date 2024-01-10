import 'package:flutter/material.dart';
import 'package:shipper_app/constants/colors.dart';
import 'package:shipper_app/constants/fontWeights.dart';

Container InvoiceHeader(context, textFontSize) {
  return Container(
    height: 60,
    margin: const EdgeInsets.only(left: 5, right: 5),
    decoration: const BoxDecoration(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10), topRight: Radius.circular(10)),
      color: headerColor,
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: Center(
            child: Text(
              'Invoice Date',
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
          child: Center(
            child: Text(
              'Invoice No',
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
          child: Center(
            child: Text(
              'Invoice Amount',
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
          child: Text(
            'Transporter Name',
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
          flex: 3,
          child: Center(
            child: Text(
              'Due Date',
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
          flex: 2,
          child: Center(
            child: Text(
              'Status ',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: mediumBoldWeight,
                  fontSize: textFontSize,
                  color: black,
                  fontFamily: 'Montserrat'),
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
          child: Center(
            child: Text(
              'Invoice Details',
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
      ],
    ),
  );
}
