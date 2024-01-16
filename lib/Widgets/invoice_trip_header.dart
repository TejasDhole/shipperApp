import 'package:flutter/material.dart';
import 'package:shipper_app/constants/colors.dart';
import 'package:shipper_app/constants/fontWeights.dart';

Container InvoiceTripHeader(context, textFontSize) {
  return Container(
    height: 50,
    decoration: const BoxDecoration(
      color: Color(0xFFEAEEFF),
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
                fontSize: 16,
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
              'LR No.',
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
              'Truck No.',
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
          child: Text(
            'Route',
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
              'Freight',
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
              'Damage ',
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
              'Total ',
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
              'POD ',
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
              'Remarks',
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
