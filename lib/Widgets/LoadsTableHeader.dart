import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:screenshot/screenshot.dart';

Container LoadsTableHeader(
    {required String loadingStatus, required double screenWidth}) {
  bool small = true;
  double leftRightPadding, textFontSize, containerWidth;
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
    height: 80,
    decoration: BoxDecoration(
        border: Border(
            bottom: BorderSide(color: Colors.grey, width: 1),
            top: BorderSide(color: Colors.grey, width: 1),
            left: BorderSide(color: Colors.grey, width: 1),
            right: BorderSide(color: Colors.grey, width: 1))),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
            flex: (loadingStatus == 'MyLoads') ? 2 : 3,
            child: Center(
                child: Container(
                    padding: EdgeInsets.only(left: 8),
                    child: Text(
                      (loadingStatus == 'MyLoads')
                          ? "Posted\nOn"
                          : "Booking\nOn",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: textFontSize,
                          fontFamily: 'Montserrat'),
                    )))),
        VerticalDivider(color: Colors.grey, thickness: 1),
        Expanded(
            flex: 5,
            child: Center(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                  Image(
                    image: AssetImage('icons/greenFilledCircleIcon.png'),
                    height: 10,
                    width: 10,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Center(
                      child: Text(
                    "Loading\nPoint",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: textFontSize,
                        fontFamily: 'Montserrat'),
                  ))
                ]))),
        VerticalDivider(
          color: Colors.grey,
          thickness: 1,
        ),
        Expanded(
            flex: 5,
            child: Center(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                  Image(
                    image: AssetImage('icons/red_circle.png'),
                    height: 10,
                    width: 10,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Center(
                      child: Text(
                    "Unloading\nPoint",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: textFontSize,
                        fontFamily: 'Montserrat'),
                  ))
                ]))),
        VerticalDivider(
          color: Colors.grey,
          thickness: 1,
        ),
        Expanded(
            flex: (loadingStatus == 'MyLoads') ? 4 : 3,
            child: Center(
                child: Text(
              (loadingStatus == 'MyLoads')
                  ? "Truck Type /\nNo. of Tyres"
                  : "Truck\nNumber",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: textFontSize,
                  fontFamily: 'Montserrat'),
            ))),
        VerticalDivider(
          color: Colors.grey,
          thickness: 1,
        ),
        Expanded(
            flex: 4,
            child: Center(
                child: Text(
              (loadingStatus == 'MyLoads')
                  ? "Product Type /\nWeight"
                  : "Driver's\nName",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: textFontSize,
                  fontFamily: 'Montserrat'),
            ))),
        VerticalDivider(
          color: Colors.grey,
          thickness: 1,
        ),
        Expanded(
            flex: 3,
            child: Center(
                child: Text(
              (loadingStatus == 'MyLoads') ? "Bids" : "Freight",
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: textFontSize,
                  fontFamily: 'Montserrat'),
            ))),
        VerticalDivider(
          color: Colors.grey,
          thickness: 1,
        ),
        Expanded(
            flex: 3,
            child: Center(
                child: Text(
              (loadingStatus == 'MyLoads') ? "Status" : 'Transporter',
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: textFontSize,
                  fontFamily: 'Montserrat'),
            ))),
        VerticalDivider(
          color: Colors.grey,
          thickness: 1,
        ),
        Expanded(flex: 4, child: Container()),
      ],
    ),
  );
}
