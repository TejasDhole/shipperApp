import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shipper_app/constants/colors.dart';
import 'package:shipper_app/constants/fontSize.dart';

class PublishBidSearchTextFieldWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
        flex: 4,
        child: Container(
          child: TextField(
            style: TextStyle(
                color: kLiveasyColor,
                fontFamily: 'Montserrat',
                fontSize: size_8),
            textAlign: TextAlign.center,
            cursorColor: kLiveasyColor,
            cursorWidth: 1,
            mouseCursor: SystemMouseCursors.click,
            decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.zero,
                    borderSide:
                        BorderSide(color: borderLightColor, width: 1.5)),
                hintText: 'Search Transporter',
                hintStyle: TextStyle(
                    color: borderLightColor,
                    fontFamily: 'Montserrat',
                    fontSize: size_8),
                suffixIcon: Icon(
                  Icons.search,
                  color: borderLightColor,
                ),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.zero,
                    borderSide: BorderSide(color: truckGreen, width: 1.5))),
          ),
        ));
  }
}
