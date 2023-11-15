import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:screenshot/screenshot.dart';
import 'package:shipper_app/constants/colors.dart';
import 'package:shipper_app/constants/fontSize.dart';
import 'package:shipper_app/responsive.dart';

class LoadDetailsHeader extends StatelessWidget {
  String? title, subTitle;
  var previousScreen;
  Function? reset;

  LoadDetailsHeader(
      {super.key,
      required this.title,
      required this.subTitle,
      required this.previousScreen,
      this.reset});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      // without card widget 'Material Widget required' will be thrown while running the application for android
      margin: EdgeInsets.all(0),
      child: Container(
        padding: EdgeInsets.only(
            top: (kIsWeb && Responsive.isMobile(context)) ? 0 : 15,
            bottom: 15,
            left: 15,
            right: MediaQuery.of(context).size.width * 0.047),
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    if (previousScreen != null) {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => previousScreen));
                    } else {
                      Get.back();
                    }
                  },
                  icon: Icon(
                    Icons.keyboard_backspace,
                    color: Colors.black,
                    size: (Responsive.isMobile(context)) ? 25 : 30,
                  ),
                ),
                SizedBox(
                  width: (Responsive.isMobile(context)) ? 10 : 20,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title ?? 'Title',
                      style: TextStyle(
                          fontSize:
                              (Responsive.isMobile(context)) ? size_7 : size_8,
                          fontFamily: 'Montserrat Bold',
                          color: kLiveasyColor),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      subTitle ?? 'Sub Title',
                      style: TextStyle(
                          fontSize:
                              (Responsive.isMobile(context)) ? size_5 : size_6,
                          fontFamily: 'Montserrat',
                          color: textLightColor),
                    ),
                  ],
                ),
              ],
            ),
            Visibility(
              visible: (reset != null) ? true : false,
              child: Container(
                width: (Responsive.isMobile(context)) ? 85 : 95,
                child: IconButton(
                    onPressed: () {
                      if (reset != null) {
                        reset!();
                      }
                    },
                    icon: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.refresh,
                          color: truckGreen,
                          size: (Responsive.isMobile(context)) ? 15 : 20,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Reset",
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                              color: truckGreen,
                              fontSize: (Responsive.isMobile(context))
                                  ? size_7
                                  : size_8),
                        )
                      ],
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
