import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:screenshot/screenshot.dart';
import 'package:shipper_app/constants/colors.dart';
import 'package:shipper_app/constants/fontSize.dart';

class LoadDetailsHeader extends StatelessWidget {
  String? title, subTitle;
  LoadDetailsHeader({super.key, required this.title, required this.subTitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: 15,
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
                  Get.back();
                },
                icon: const Icon(
                  Icons.keyboard_backspace,
                  color: Colors.black,
                  size: 30,
                ),
              ),
              SizedBox(
                width: 20,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title ?? 'Title',
                    style: TextStyle(
                        fontSize: size_8,
                        fontFamily: 'Montserrat Bold',
                        color: kLiveasyColor),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    subTitle ?? 'Sub Title',
                    style: TextStyle(
                        fontSize: size_6,
                        fontFamily: 'Montserrat',
                        color: textLightColor),
                  ),
                ],
              ),
            ],
          ),
          Container(
            width: 95,
            child: IconButton(
                onPressed: () {
                  print("hello");
                },
                icon: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.refresh,
                      color: truckGreen,
                      size: 20,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Reset",
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          color: truckGreen,
                          fontSize: size_8),
                    )
                  ],
                )),
          ),
        ],
      ),
    );
  }
}
