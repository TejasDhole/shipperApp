import 'package:flutter/material.dart';
import 'package:shipper_app/constants/colors.dart';
import 'package:shipper_app/responsive.dart';

class biddingScreenTableHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double textFontSize = 16;
    if (Responsive.isTablet(context)) {
      textFontSize = 12;
    } else if (Responsive.isDesktop(context)) {
      textFontSize = 16;
    }
    TextStyle textStyle = TextStyle(
        color: Colors.grey, fontSize: textFontSize, fontFamily: 'Montserrat');
    return Container(
      height: 60,
      decoration: BoxDecoration(
        border: Border(
            bottom: BorderSide(color: unselectedGrey, width: 1),
            top: BorderSide(color: unselectedGrey, width: 1)),
      ),
      child: Row(
        children: [
          Expanded(
              flex: 2,
              child: Center(
                child: Container(
                    child: (Text(
                  'Rank',
                  style: textStyle,
                  textAlign: TextAlign.center,
                ))),
              )),
          VerticalDivider(color: unselectedGrey, thickness: 1),
          Expanded(
              flex: 4,
              child: Center(
                child: (Text('Bidding Date',
                    style: textStyle, textAlign: TextAlign.center)),
              )),
          VerticalDivider(color: unselectedGrey, thickness: 1),
          Expanded(
              flex: 4,
              child: Center(
                child: (Text('Transporter',
                    style: textStyle, textAlign: TextAlign.center)),
              )),
          VerticalDivider(color: unselectedGrey, thickness: 1),
          Expanded(
              flex: 4,
              child: Center(
                child: (Text('Current Bidding',
                    style: textStyle, textAlign: TextAlign.center)),
              )),
          VerticalDivider(color: unselectedGrey, thickness: 1),
          Expanded(
              flex: 6,
              child: Center(
                child: (Text('Negotiate / Accept',
                    style: textStyle, textAlign: TextAlign.center)),
              )),
        ],
      ),
    );
  }
}
