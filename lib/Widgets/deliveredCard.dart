import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shipper_app/functions/ongoingTruckGpsData.dart';
import 'package:shipper_app/models/onGoingCardModel.dart';
import 'package:shipper_app/responsive.dart';
import 'package:shipper_app/screens/TransporterOrders/documentUploadScreen.dart';
import '/constants/colors.dart';
import '/constants/fontSize.dart';
import '/constants/fontWeights.dart';
import '/constants/spaces.dart';
import '/models/deliveredCardModel.dart';
import '/screens/myLoadPages/deliveredLoadDetails.dart';
import '/widgets/LoadEndPointTemplate.dart';
import '/widgets/newRowTemplate.dart';
import 'package:get/get.dart';
import 'linePainter.dart';

class DeliveredCard extends StatelessWidget {
  final DeliveredCardModel model;
  late OngoingTruckGpsData ongoingTruckGpsData;

  DeliveredCard({required this.model});

  moveToDocumentUploadScreen() {
    OngoingCardModel onGoingCardModel = OngoingCardModel();

    onGoingCardModel.deviceId = model.deviceId;
    onGoingCardModel.loadingPointCity = model.loadingPointCity;
    onGoingCardModel.unloadingPointCity = model.unloadingPointCity;
    onGoingCardModel.companyName = model.companyName;
    onGoingCardModel.shipperPhoneNum = model.transporterPhoneNum;
    onGoingCardModel.shipperLocation = model.transporterLocation;
    onGoingCardModel.shipperName = model.transporterName;
    onGoingCardModel.transporterApproved = model.transporterApproved;
    onGoingCardModel.companyApproved = model.companyApproved;
    onGoingCardModel.truckNo = model.truckNo;
    onGoingCardModel.truckType = model.truckType;
    onGoingCardModel.imei = model.imei;
    onGoingCardModel.driverName = model.driverName;
    onGoingCardModel.driverPhoneNum = model.driverPhoneNum;
    onGoingCardModel.rate = model.rate;
    onGoingCardModel.unitValue = model.unitValue;
    onGoingCardModel.noOfTrucks = model.noOfTrucks;
    onGoingCardModel.productType = model.productType;
    onGoingCardModel.bookingDate = model.bookingDate;
    onGoingCardModel.completedDate = model.completedDate;
    onGoingCardModel.deviceId = model.deviceId;

    ongoingTruckGpsData = OngoingTruckGpsData(onGoingCardModel);
    ongoingTruckGpsData.getTruckGpsDetails().then((gpsData) {
      Get.to(documentUploadScreen(
        bookingId: model.bookingId.toString(),
        truckNo: model.truckNo,
        loadingPoint: model.loadingPointCity,
        unloadingPoint: model.unloadingPointCity,
        transporterName: model.transporterName,
        transporterPhoneNum: model.transporterPhoneNum,
        driverPhoneNum: model.driverPhoneNum,
        driverName: model.driverName,
        bookingDate: model.bookingDate,
        gpsDataList: gpsData[1][0],
        totalDistance: gpsData[3],
        truckType: model.truckType,
        productType: model.productType,
        unitValue: model.unitValue,
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    double textFontSize = (MediaQuery.of(context).size.width > 1099 &&
            MediaQuery.of(context).size.width < 1400)
        ? 10
        : 14;
    if (model.companyName == null) {
      model.companyName = "NA";
    }
    model.companyName = model.companyName!.length >= 35
        ? model.companyName!.substring(0, 33) + '..'
        : model.companyName;

    model.unitValue = model.unitValue == 'PER_TON' ? "tonne".tr : "truck".tr;
    return (kIsWeb && Responsive.isDesktop(context))
        ? Expanded(
            child: GestureDetector(
              onTap: () {
                moveToDocumentUploadScreen();
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
                                model.bookingDate ?? 'Null',
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
                          model.loadingPointCity ?? 'Null',
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
                          model.unloadingPointCity ?? 'Null',
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
                          '${model.truckNo}' ?? 'Null',
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
                      flex: 4,
                      child: Center(
                          child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          '${model.driverName}' ?? 'Null',
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
                          '${model.truckType}' ?? 'Null',
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
                        child: Flex(
                            mainAxisSize: MainAxisSize.min,
                            direction: Axis.vertical,
                            children: [
                              Flexible(
                                  child: Text(
                                '${model.companyName}' ?? 'Null',
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
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IntrinsicHeight(
                                child: TextButton(
                              style: ButtonStyle(
                                padding: MaterialStatePropertyAll<EdgeInsets>(
                                    EdgeInsets.only(left: 8, right: 8)),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5),
                                        side:
                                            BorderSide(color: darkBlueColor))),
                                alignment: Alignment.center,
                                backgroundColor: MaterialStateProperty.all(
                                    Colors.white.withOpacity(0)),
                              ),
                              child: Text(
                                'History',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: mediumBoldWeight,
                                    color: kLiveasyColor,
                                    fontSize: size_7,
                                    fontFamily: 'Montserrat'),
                              ),
                              onPressed: () {
                                moveToDocumentUploadScreen();
                              },
                            )),
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: IconButton(
                                onPressed: () {
                                  moveToDocumentUploadScreen();
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
                    ),
                  ],
                ),
              ),
            ),
          )
        : GestureDetector(
            onTap: () {
              moveToDocumentUploadScreen();
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
                                '${"completedDate".tr} : ${model.completedDate}',
                                style: TextStyle(
                                  fontSize: size_6,
                                  color: veryDarkGrey,
                                ),
                              ),
                              Icon(Icons.arrow_forward_ios_sharp),
                            ],
                          ),
                          SizedBox(
                            height: space_1,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              LoadEndPointTemplate(
                                  text: model.loadingPointCity,
                                  endPointType: 'loading'),
                              Container(
                                  padding: EdgeInsets.only(left: 2),
                                  height: space_3,
                                  width: space_12,
                                  child: CustomPaint(
                                    foregroundPainter:
                                        LinePainter(height: space_3),
                                  )),
                              LoadEndPointTemplate(
                                  text: model.unloadingPointCity,
                                  endPointType: 'unloading'),
                            ],
                          ),
                          Container(
                            margin: EdgeInsets.only(top: space_2),
                            child: Column(
                              children: [
                                NewRowTemplate(
                                    label: "bookingDate".tr,
                                    value: model.bookingDate),
                                NewRowTemplate(
                                  label: "price".tr,
                                  value: '${model.rate}/${model.unitValue}',
                                  width: 100,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      // color: contactPlaneBackground,
                      padding:
                          EdgeInsets.fromLTRB(space_3, 0, space_3, space_3),
                      child: Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(right: space_1),
                            child: Image(
                                height: 16,
                                width: 23,
                                color: black,
                                image: AssetImage(
                                    'assets/icons/buildingIconBlack.png')),
                          ),
                          Text(
                            model.companyName!,
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
            ),
          );
  }
}
