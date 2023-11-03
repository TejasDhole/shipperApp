import 'package:flutter/cupertino.dart';
import 'package:shipper_app/Web/screens/home_web.dart';
import 'package:shipper_app/Widgets/loadDetailsWebWidgets/loadDetailsHeader.dart';
import 'package:shipper_app/constants/colors.dart';
import 'package:shipper_app/constants/fontSize.dart';
import 'package:shipper_app/constants/spaces.dart';
import 'package:shipper_app/responsive.dart';
import 'package:shipper_app/screens/PostLoadScreens/PostLoadScreenMultiple.dart';

Widget postLoadMultipleLocationWidget(context, previousScreen) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      LoadDetailsHeader(
          title: 'Location Details',
          subTitle: 'Tell us your location details',
          previousScreen: previousScreen),
      Container(
        height: 10,
        color: lineDividerColor,
      ),
      Container(
        padding: EdgeInsets.fromLTRB(space_2, space_2, space_2, space_2),
        decoration: BoxDecoration(
          color: truckGreen,
        ),
        child: Center(
            child: Text(
          'Please be as specific as possible . Share your exact location',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: (Responsive.isMobile(context)) ? size_5 : size_7,
            fontFamily: 'Montserrat',
            color: white,
          ),
        )),
      ),
      Container(
          height: (Responsive.isMobile(context))
              ? MediaQuery.of(context).size.height * 0.7
              : MediaQuery.of(context).size.height * 0.5,
          child: PostLoadScreenMultiple()),
    ],
  );
}
