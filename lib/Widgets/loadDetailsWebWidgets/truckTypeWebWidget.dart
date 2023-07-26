import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shipper_app/screens/PostLoadScreens/TruckTypePostLoadDetailsScreen.dart';

import '../../constants/colors.dart';
import '../../constants/fontSize.dart';

class TruckTypeWebWidget extends StatefulWidget{
  @override
  State<TruckTypeWebWidget> createState() => _TruckTypeWebWidgetState();
}

class _TruckTypeWebWidgetState extends State<TruckTypeWebWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextField(
        style: TextStyle(color: kLiveasyColor, fontFamily: 'Montserrat', fontSize: size_8),
        textAlign: TextAlign.center,
        showCursor: false,
        mouseCursor: SystemMouseCursors.click,
        onTap: (){
          Get.to(() => TruckTypePostLoadDetailsScreen());
        },
        decoration: InputDecoration(
            border: OutlineInputBorder(
                borderRadius: BorderRadius.zero,
                borderSide: BorderSide(color: borderLightColor,width: 1.5)
            ),
            hintText: 'Choose Truck Preference',
            hintStyle: TextStyle(color: borderLightColor,fontFamily: 'Montserrat', fontSize: size_8),
            label: Text('Truck Type',style: TextStyle(color: kLiveasyColor, fontFamily: 'Montserrat', fontSize: size_10, fontWeight: FontWeight.w600),selectionColor: kLiveasyColor),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            suffixIcon: Icon(Icons.arrow_forward, color: borderLightColor,),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.zero,
                borderSide: BorderSide(color: truckGreen,width: 1.5)
            )
        ),
      ),
    );
  }
}