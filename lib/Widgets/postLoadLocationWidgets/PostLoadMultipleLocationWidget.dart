import 'package:flutter/cupertino.dart';
import 'package:shipper_app/Widgets/loadDetailsWebWidgets/loadDetailsHeader.dart';
import 'package:shipper_app/constants/colors.dart';
import 'package:shipper_app/constants/fontSize.dart';
import 'package:shipper_app/constants/spaces.dart';
import 'package:shipper_app/screens/PostLoadScreens/PostLoadScreenMultiple.dart';

Widget postLoadMultipleLocationWidget(context) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      LoadDetailsHeader(
          title: 'Location Details', subTitle: 'Tell us your location details'),
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
          style: TextStyle(
            fontSize: size_7,
            fontFamily: 'Montserrat',
            color: white,
          ),
        )),
      ),
      Container(
          height: MediaQuery.of(context).size.height * 0.5,
          child: PostLoadScreenMultiple()),
    ],
  );
}
