import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:screenshot/screenshot.dart';
import 'package:shipper_app/Web/screens/home_web.dart';
import 'package:shipper_app/Widgets/buttons/trackButton.dart';
import 'package:shipper_app/constants/screens.dart';
import 'package:shipper_app/functions/ongoingTruckGpsData.dart';
import 'package:shipper_app/responsive.dart';
import '/constants/colors.dart';
import 'package:logger/logger.dart';
import '/constants/fontSize.dart';
import '/constants/fontWeights.dart';
import '/constants/spaces.dart';
import '/functions/ongoingTrackUtils/getDeviceData.dart';
import '/functions/ongoingTrackUtils/getPositionByDeviceId.dart';
import '/functions/ongoingTrackUtils/getTraccarSummaryByDeviceId.dart';
import '/models/gpsDataModel.dart';
import '/models/onGoingCardModel.dart';
import '/screens/TransporterOrders/documentUploadScreen.dart';
import '/screens/myLoadPages/onGoingLoadDetails.dart';
import '/widgets/LoadEndPointTemplate.dart';
import '/widgets/buttons/callButton.dart';
import '/widgets/newRowTemplate.dart';
import 'linePainter.dart';

class OngoingCard extends StatefulWidget {
  final OngoingCardModel loadAllDataModel;

  // final GpsDataModel gpsData;

  const OngoingCard({
    super.key,
    required this.loadAllDataModel,
  });

  @override
  State<OngoingCard> createState() => _OngoingCardState();
}

class _OngoingCardState extends State<OngoingCard> {
  late OngoingTruckGpsData ongoingTruckGpsData;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool small = true;
    double textFontSize;
    if (MediaQuery.of(context).size.width > 1099 &&
        MediaQuery.of(context).size.width < 1400) {
      small = true;
    } else {
      small = false;
    }
    if (small) {
      textFontSize = 10;
    } else {
      textFontSize = 14;
    }

    widget.loadAllDataModel.truckType;
    widget.loadAllDataModel.productType;
    widget.loadAllDataModel.unitValue;
    //widget.loadAllDataModel.noOfTrucks;
    widget.loadAllDataModel.driverName ??= "NA";
    widget.loadAllDataModel.driverName =
        widget.loadAllDataModel.driverName!.length >= 20
            ? '${widget.loadAllDataModel.driverName!.substring(0, 18)}..'
            : widget.loadAllDataModel.driverName;
    if (widget.loadAllDataModel.companyName == null) {}
    widget.loadAllDataModel.companyName =
        widget.loadAllDataModel.companyName!.length >= 35
            ? '${widget.loadAllDataModel.companyName!.substring(0, 33)}..'
            : widget.loadAllDataModel.companyName;

    widget.loadAllDataModel.unitValue =
        widget.loadAllDataModel.unitValue == "PER_TON"
            ? "tonne".tr
            : "truck".tr;

    return (kIsWeb && Responsive.isDesktop(context))
        ? Expanded(
            child: GestureDetector(
              onTap: () {
                ongoingTruckGpsData =
                    OngoingTruckGpsData(widget.loadAllDataModel);
                ongoingTruckGpsData.getTruckGpsDetails().then((gpsData) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomeScreenWeb(
                        visibleWidget: documentUploadScreen(
                          bookingId:
                              widget.loadAllDataModel.bookingId.toString(),
                          truckNo: widget.loadAllDataModel.truckNo,
                          loadingPoint:
                              widget.loadAllDataModel.loadingPointCity,
                          unloadingPoint:
                              widget.loadAllDataModel.unloadingPointCity,
                          transporterName: widget.loadAllDataModel.shipperName,
                          transporterPhoneNum:
                              widget.loadAllDataModel.shipperPhoneNum,
                          driverPhoneNum:
                              widget.loadAllDataModel.driverPhoneNum,
                          driverName: widget.loadAllDataModel.driverName,
                          bookingDate: widget.loadAllDataModel.bookingDate,
                          gpsDataList: gpsData[1][0],
                          totalDistance: gpsData[3],
                          truckType: widget.loadAllDataModel.truckType,
                          productType: widget.loadAllDataModel.productType,
                          unitValue: widget.loadAllDataModel.unitValue,
                          loadAllDataModel: widget.loadAllDataModel,
                        ),
                        index: 1000,
                        selectedIndex: screens.indexOf(postLoadScreen),
                      ),
                    ),
                  );
                });
              },
              child: IntrinsicHeight(
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Center(
                          child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Text(
                                widget.loadAllDataModel.bookingDate ?? 'Null',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: textFontSize,
                                    fontFamily: 'Montserrat'),
                              ))),
                    ),
                    const VerticalDivider(color: Colors.grey, thickness: 1),
                    Expanded(
                      flex: 5,
                      child: Center(
                          child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          widget.loadAllDataModel.loadingPointCity ?? 'Null',
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: black,
                              fontWeight: FontWeight.w600,
                              fontSize: textFontSize,
                              fontFamily: 'Montserrat'),
                        ),
                      )),
                    ),
                    const VerticalDivider(color: Colors.grey, thickness: 1),
                    Expanded(
                      flex: 5,
                      child: Center(
                          child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          widget.loadAllDataModel.unloadingPointCity ?? 'Null',
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: black,
                              fontWeight: FontWeight.w600,
                              fontSize: textFontSize,
                              fontFamily: 'Montserrat'),
                        ),
                      )),
                    ),
                    const VerticalDivider(color: Colors.grey, thickness: 1),
                    Expanded(
                      flex: 3,
                      child: Center(
                          child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          '${widget.loadAllDataModel.truckNo}' ?? 'Null',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: kLiveasyColor,
                              fontWeight: FontWeight.w600,
                              fontSize: textFontSize,
                              fontFamily: 'Montserrat'),
                        ),
                      )),
                    ),
                    const VerticalDivider(color: Colors.grey, thickness: 1),
                    Expanded(
                      flex: 4,
                      child: Center(
                          child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          '${widget.loadAllDataModel.driverName}' ?? 'Null',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: black,
                              fontWeight: FontWeight.w600,
                              fontSize: textFontSize,
                              fontFamily: 'Montserrat'),
                        ),
                      )),
                    ),
                    const VerticalDivider(color: Colors.grey, thickness: 1),
                    Expanded(
                      flex: 3,
                      child: Center(
                          child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          '${widget.loadAllDataModel.truckType}' ?? 'Null',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: kLiveasyColor,
                              fontWeight: FontWeight.w600,
                              fontSize: textFontSize,
                              fontFamily: 'Montserrat'),
                        ),
                      )),
                    ),
                    const VerticalDivider(color: Colors.grey, thickness: 1),
                    Expanded(
                      flex: 3,
                      child: Center(
                          child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Flex(
                            mainAxisSize: MainAxisSize.min,
                            direction: Axis.vertical,
                            children: [
                              Flexible(
                                  child: Text(
                                '${widget.loadAllDataModel.companyName}' ??
                                    'Null',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: textFontSize,
                                    fontFamily: 'Montserrat'),
                              ))
                            ]),
                      )),
                    ),
                    const VerticalDivider(color: Colors.grey, thickness: 1),
                    Expanded(
                      flex: 4,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IntrinsicHeight(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Column(
                                children: [
                                  TrackButton(
                                    assetImage: null,
                                    name: 'Track',
                                    loadAllDataModel: widget.loadAllDataModel,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  CallButton(
                                    directCall: false,
                                    transporterPhoneNum:
                                        widget.loadAllDataModel.shipperPhoneNum,
                                    driverPhoneNum:
                                        widget.loadAllDataModel.driverPhoneNum,
                                    driverName:
                                        widget.loadAllDataModel.driverName,
                                    transporterName:
                                        widget.loadAllDataModel.companyName,
                                  ),
                                  Container()
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: IconButton(
                              onPressed: () {
                                ongoingTruckGpsData = OngoingTruckGpsData(
                                    widget.loadAllDataModel);
                                ongoingTruckGpsData
                                    .getTruckGpsDetails()
                                    .then((gpsData) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HomeScreenWeb(
                                        visibleWidget: documentUploadScreen(
                                          bookingId: widget
                                              .loadAllDataModel.bookingId
                                              .toString(),
                                          truckNo:
                                              widget.loadAllDataModel.truckNo,
                                          loadingPoint: widget.loadAllDataModel
                                              .loadingPointCity,
                                          unloadingPoint: widget
                                              .loadAllDataModel
                                              .unloadingPointCity,
                                          transporterName: widget
                                              .loadAllDataModel.shipperName,
                                          transporterPhoneNum: widget
                                              .loadAllDataModel.shipperPhoneNum,
                                          driverPhoneNum: widget
                                              .loadAllDataModel.driverPhoneNum,
                                          driverName: widget
                                              .loadAllDataModel.driverName,
                                          bookingDate: widget
                                              .loadAllDataModel.bookingDate,
                                          gpsDataList: gpsData[1][0],
                                          totalDistance: gpsData[3],
                                          truckType:
                                              widget.loadAllDataModel.truckType,
                                          productType: widget
                                              .loadAllDataModel.productType,
                                          unitValue:
                                              widget.loadAllDataModel.unitValue,
                                          loadAllDataModel:
                                              widget.loadAllDataModel,
                                        ),
                                        index: 1000,
                                        selectedIndex:
                                            screens.indexOf(postLoadScreen),
                                      ),
                                    ),
                                  );
                                });
                              },
                              icon: const Icon(
                                Icons.arrow_forward_ios_sharp,
                                color: kLiveasyColor,
                                size: 15,
                                weight: 700,
                              ),
                              padding: EdgeInsets.zero,
                              iconSize: 15,
                              style: const ButtonStyle(
                                padding: MaterialStatePropertyAll<EdgeInsets>(
                                    EdgeInsets.zero),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        : GestureDetector(
            onTap: () {
              ongoingTruckGpsData =
                  OngoingTruckGpsData(widget.loadAllDataModel);
              ongoingTruckGpsData.getTruckGpsDetails().then((gpsData) {
                Get.to(documentUploadScreen(
                  loadAllDataModel: widget.loadAllDataModel,
                  bookingId: widget.loadAllDataModel.bookingId.toString(),
                  truckNo: widget.loadAllDataModel.truckNo,
                  loadingPoint: widget.loadAllDataModel.loadingPointCity,
                  unloadingPoint: widget.loadAllDataModel.unloadingPointCity,
                  transporterName: widget.loadAllDataModel.shipperName,
                  transporterPhoneNum: widget.loadAllDataModel.shipperPhoneNum,
                  driverPhoneNum: widget.loadAllDataModel.driverPhoneNum,
                  driverName: widget.loadAllDataModel.driverName,
                  bookingDate: widget.loadAllDataModel.bookingDate,
                  // trackApproved: true,
                  gpsDataList: gpsData[1][0],
                  // widget.gpsDataList,
                  totalDistance: gpsData[3],
                  //  widget.totalDistance,
                  // device: gpsData.deviceId,
                  // gpsData!.deviceId
                  // widget.device,
                  truckType: widget.loadAllDataModel.truckType,
                  productType: widget.loadAllDataModel.productType,
                  unitValue: widget.loadAllDataModel.unitValue,
                ));
              });
            },
            child: Container(
              margin: EdgeInsets.only(bottom: space_3),
              child: Card(
                surfaceTintColor: transparent,
                elevation: 5,
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.all(space_4),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${"bookingDate".tr} : ${widget.loadAllDataModel.bookingDate}',
                                style: TextStyle(
                                  fontSize: size_6,
                                  color: veryDarkGrey,
                                ),
                              ),
                              const Icon(Icons.arrow_forward_ios_sharp),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              LoadEndPointTemplate(
                                  text:
                                      widget.loadAllDataModel.loadingPointCity,
                                  endPointType: 'loading'),
                              Container(
                                  padding: const EdgeInsets.only(left: 2),
                                  height: space_3,
                                  width: space_12,
                                  child: CustomPaint(
                                    foregroundPainter:
                                        LinePainter(height: space_3),
                                  )),
                              LoadEndPointTemplate(
                                  text: widget
                                      .loadAllDataModel.unloadingPointCity,
                                  endPointType: 'unloading'),
                            ],
                          ),
                          Container(
                            margin: EdgeInsets.only(top: space_4),
                            child: Column(
                              children: [
                                NewRowTemplate(
                                  label: "truckNumber".tr,
                                  value: widget.loadAllDataModel.truckNo,
                                  width: 78,
                                ),
                                NewRowTemplate(
                                    label: "driverName".tr,
                                    value: widget.loadAllDataModel.driverName),
                                NewRowTemplate(
                                  label: "price".tr,
                                  value:
                                      '${widget.loadAllDataModel.rate}/${widget.loadAllDataModel.unitValue}',
                                  width: 78,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: space_4),
                            child: Row(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(right: space_1),
                                  child: const Image(
                                      height: 16,
                                      width: 23,
                                      color: black,
                                      image: AssetImage(
                                          'assets/icons/TruckIcon.png')),
                                ),
                                Text(
                                  widget.loadAllDataModel.companyName!,
                                  style: TextStyle(
                                    color: liveasyBlackColor,
                                    fontWeight: mediumBoldWeight,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      color: contactPlaneBackground,
                      padding: EdgeInsets.symmetric(
                        vertical: space_2,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          TrackButton(
                              assetImage: null,
                              name: 'Track',
                              loadAllDataModel: widget.loadAllDataModel),
                          CallButton(
                            directCall: false,
                            transporterPhoneNum:
                                widget.loadAllDataModel.shipperPhoneNum,
                            driverPhoneNum:
                                widget.loadAllDataModel.driverPhoneNum,
                            driverName: widget.loadAllDataModel.driverName,
                            transporterName:
                                widget.loadAllDataModel.companyName,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
