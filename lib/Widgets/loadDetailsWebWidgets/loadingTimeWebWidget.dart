import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shipper_app/constants/colors.dart';
import 'package:shipper_app/constants/fontSize.dart';

import '../../providerClass/providerData.dart';

class LoadingTimeWebWidget extends StatefulWidget {
  @override
  LoadingTimeWebWidgetState createState() {
    return LoadingTimeWebWidgetState();
  }
}

class LoadingTimeWebWidgetState extends State<LoadingTimeWebWidget> {

  TimeOfDay? picked= TimeOfDay.now();
  final TextEditingController _textEditingController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    ProviderData providerData = Provider.of<ProviderData>(context);
    if(providerData.scheduleLoadingTime != ''){
      _textEditingController.text = providerData.scheduleLoadingTime;
    }

    return Expanded(
      child: Container(
        child: TextField(
          controller: _textEditingController,
          style: TextStyle(
              color: kLiveasyColor, fontFamily: 'Montserrat', fontSize: size_8),
          textAlign: TextAlign.center,
          showCursor: false,
            keyboardType: TextInputType.datetime,
            mouseCursor: SystemMouseCursors.click,
          onTap: () async{
            picked = await showTimePicker(
                context: context, initialTime: (picked!=null)?picked!:TimeOfDay.now(),
            orientation: Orientation.portrait,
            initialEntryMode: TimePickerEntryMode.dialOnly,
            cancelText: 'CANCEL',
            confirmText: 'OK',
            builder: (context, child) {
              return Theme(data: Theme.of(context).copyWith(
                textButtonTheme: TextButtonThemeData(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateColor.resolveWith((states) => truckGreen),
                    foregroundColor: MaterialStateColor.resolveWith((states) => Colors.white),
                    textStyle: MaterialStatePropertyAll<TextStyle>(TextStyle(color: Colors.white,fontFamily: 'Montserrat',fontSize: size_5)),
                    padding: MaterialStatePropertyAll<EdgeInsets>(EdgeInsets.only(left: 10,right: 10,top: 5,bottom: 5)),
                    side: MaterialStatePropertyAll<BorderSide>(BorderSide(color: truckGreen,width: 2))
                  )
                ),
                focusColor: truckGreen,
                timePickerTheme: TimePickerThemeData(
                  padding: EdgeInsets.all(20),
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  elevation: 5,

                  // cancelButtonStyle: cancelButtonStyle,
                  // confirmButtonStyle: confirmButtonStyle,

                  dialBackgroundColor: Colors.white,
                  dialHandColor: truckGreen,
                  dialTextColor: MaterialStateColor.resolveWith((states) =>
                  states.contains(MaterialState.selected)
                      ? Colors.white
                      : truckGreen),
                  dialTextStyle: TextStyle(color: Colors.white,fontFamily: 'Montserrat Bold',fontSize: size_7),

                  dayPeriodColor: MaterialStateColor.resolveWith((states) =>
                  states.contains(MaterialState.selected)
                      ? truckGreen
                      : Colors.white),

                  dayPeriodTextColor: MaterialStateColor.resolveWith((states) =>
                  states.contains(MaterialState.selected)
                      ? Colors.white
                      : truckGreen),

                  dayPeriodTextStyle: TextStyle(color: truckGreen,fontFamily: 'Montserrat',fontSize: size_5),
                  dayPeriodShape: RoundedRectangleBorder(
                    side: BorderSide(width: 2,color: truckGreen),
                    borderRadius: BorderRadius.all(Radius.circular(10))
                  ),
                  dayPeriodBorderSide: BorderSide(width: 2,color: truckGreen),

                  hourMinuteShape: RoundedRectangleBorder(
                    side: BorderSide(color: truckGreen,width: 2,),
                    borderRadius: BorderRadius.all(Radius.circular(5))
                  ),
                  hourMinuteColor: MaterialStateColor.resolveWith((states) =>
                  states.contains(MaterialState.selected)
                      ? truckGreen
                      : Colors.white),
                  hourMinuteTextColor: MaterialStateColor.resolveWith((states) =>
                  states.contains(MaterialState.selected)
                      ? Colors.white
                      : truckGreen),
                  hourMinuteTextStyle: TextStyle(fontFamily: 'Montserrat',fontSize: size_12),
                  helpTextStyle: TextStyle(fontFamily: 'Montserrat'),

                ),
              ), child: child!);
            }
            );
            setState(() {
              providerData.updateResetActive(false);
              String dayPeriod = (picked!.period == DayPeriod.am) ? 'AM' : 'PM';
              String dayHour = (picked!.hourOfPeriod.toString().length == 1)?'0${picked!.hourOfPeriod.toString()}':picked!.hourOfPeriod.toString();
              String dayMinute = (picked!.minute.toString().length == 1)?'0${picked!.minute.toString()}':picked!.minute.toString();
              _textEditingController.text = '$dayHour : $dayMinute $dayPeriod';
              providerData.scheduleLoadingTime = _textEditingController.text;
              print(providerData.scheduleLoadingTime);
            });
          },
          decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.zero,
                  borderSide: BorderSide(color: borderLightColor, width: 1.5)),
              hintText: 'Choose Time',
              hintStyle: TextStyle(
                  color: borderLightColor,
                  fontFamily: 'Montserrat',
                  fontSize: size_8),
              label: Text('Schedule Loading Time (optional)',
                  style: TextStyle(
                      color: kLiveasyColor,
                      fontFamily: 'Montserrat',
                      fontSize: size_10,
                      fontWeight: FontWeight.w600),
                  selectionColor: kLiveasyColor),
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: Icon(
                Icons.arrow_forward,
                color: borderLightColor,
              ),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.zero,
                  borderSide: BorderSide(color: truckGreen, width: 1.5))),
        ),
      ),
    );
  }
}
