import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:screenshot/screenshot.dart';
import 'package:shipper_app/functions/ongoingTruckGpsData.dart';
import 'package:shipper_app/functions/ongoingTrackUtils/getDeviceData.dart';
import 'package:shipper_app/functions/ongoingTrackUtils/getPositionByDeviceId.dart';
import 'package:shipper_app/functions/ongoingTrackUtils/getTraccarSummaryByDeviceId.dart';
import 'package:shipper_app/models/gpsDataModel.dart';
import 'package:shipper_app/models/onGoingCardModel.dart';
import 'package:shipper_app/responsive.dart';
import 'package:shipper_app/screens/trackScreenMobile.dart';
import '../../functions/shipperApis/shipperApiCalls.dart';
import '/constants/colors.dart';
import '/constants/fontSize.dart';
import '/constants/fontWeights.dart';
import '/constants/spaces.dart';
import '/functions/mapUtils/getLoactionUsingImei.dart';
import '/functions/truckApis/truckApiCalls.dart';
import '/screens/trackScreen.dart';

import 'package:logger/logger.dart';

// ignore: must_be_immutable
class TrackButton extends StatefulWidget {
  final OngoingCardModel loadAllDataModel;

  TrackButton({
    required this.loadAllDataModel,
  });

  @override
  _TrackButtonState createState() => _TrackButtonState();
}

class _TrackButtonState extends State<TrackButton> {
  late OngoingTruckGpsData ongoingTruckGpsData;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return (kIsWeb && Responsive.isDesktop(context))
        ? Expanded(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Container(
                child: TextButton(
                  style: ButtonStyle(
                    padding: MaterialStatePropertyAll<EdgeInsets>(
                        EdgeInsets.only(left: 5, right: 10)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    )),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(darkBlueColor),
                  ),
                  onPressed: () async {
                    ongoingTruckGpsData =
                        OngoingTruckGpsData(widget.loadAllDataModel);
                    ongoingTruckGpsData.getTruckGpsDetails().then((gpsData) {
                      Get.to(
                        TrackScreen(
                          deviceId: gpsData[1][0].deviceId,
                          gpsData: gpsData[1][0],
                          truckNo: widget.loadAllDataModel.truckNo,
                          totalDistance: gpsData[3],
                          online: true,
                          active: true,
                        ),
                      );
                    });
                  },
                  child: Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: space_1),
                        child: true
                            ? Container()
                            : Image(
                                height: 16,
                                width: 11,
                                image: AssetImage('assets/icons/lockIcon.png')),
                      ),
                      Text(
                        'Track'.tr,
                        style: TextStyle(
                          letterSpacing: 0.7,
                          fontWeight: normalWeight,
                          color: white,
                          fontSize: size_7,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        : Container(
            height: 31,
            width: 90,
            child: TextButton(
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                )),
                backgroundColor:
                    MaterialStateProperty.all<Color>(darkBlueColor),
              ),
              onPressed: () async {
                ongoingTruckGpsData =
                    OngoingTruckGpsData(widget.loadAllDataModel);
                ongoingTruckGpsData.getTruckGpsDetails().then((gpsData) {
                  Get.to(
                    TrackScreenMobile(
                      deviceId: gpsData[1][0].deviceId,
                      gpsData: gpsData[1][0],
                      truckNo: widget.loadAllDataModel.truckNo,
                      totalDistance: gpsData[3],
                      online: true,
                      active: true,
                    ),
                  );
                });
              },
              child: Container(
                margin: EdgeInsets.only(left: space_2),
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(right: space_1),
                      child: true
                          ? Container()
                          : Image(
                              height: 16,
                              width: 11,
                              image: AssetImage('assets/icons/lockIcon.png')),
                    ),
                    Text(
                      'Track'.tr,
                      style: TextStyle(
                        letterSpacing: 0.7,
                        fontWeight: normalWeight,
                        color: white,
                        fontSize: size_7,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
