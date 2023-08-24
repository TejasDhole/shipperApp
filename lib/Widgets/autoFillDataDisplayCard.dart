import 'package:flutter/material.dart';
import '/constants/colors.dart';
import '/constants/fontSize.dart';
import '/constants/spaces.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class AutoFillDataDisplayCard extends StatelessWidget {
  String placeName;
  String placeCity;
  String? addresscomponent;
  String stateName;
  var onTap;
  int index;
  int selectedIndex;

  AutoFillDataDisplayCard(
    this.placeName,
    this.addresscomponent,
    this.placeCity,
    this.stateName,
    this.index,
    this.selectedIndex,
    this.onTap,
  );

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            border: Border(
          right: (index == selectedIndex)
              ? BorderSide(color: black, width: 1)
              : BorderSide(color: transparent, width: 0),
          left: (index == selectedIndex)
              ? BorderSide(color: black, width: 1)
              : BorderSide(color: transparent, width: 0),
          top: (index == selectedIndex)
              ? BorderSide(color: black, width: 1)
              : BorderSide(color: transparent, width: 0),
          bottom: (index == selectedIndex)
              ? BorderSide(color: black, width: 1)
              : BorderSide(color: transparent, width: 0),
        )),
        padding: EdgeInsets.only(
          top: space_2,
          bottom: space_2,
        ),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: space_1),
              child: Icon(
                Icons.location_pin,
                color: kLiveasyColor,
              ),
            ),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    // height: 170,
                    child: Text(
                      '''$placeName'''.tr,
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: size_7,
                          color: kLiveasyColor,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    child: Text(
                      addresscomponent == null
                          ? stateName == placeCity
                              ? '$placeCity'.tr
                              : '$placeCity'.tr + '$stateName'.tr
                          : '$addresscomponent'.tr +
                              ',' +
                              '$placeCity'.tr +
                              ',' +
                              '$stateName'.tr,
                      style: TextStyle(
                          fontSize: size_6,
                          color: darkGreyColor,
                          fontFamily: 'Montserrat'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
