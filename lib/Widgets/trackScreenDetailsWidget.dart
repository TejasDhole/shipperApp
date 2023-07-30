import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/constants/colors.dart';
import '/constants/fontSize.dart';
import '/constants/fontWeights.dart';
import '/constants/spaces.dart';
import '/controller/dynamicLink.dart';
import '/functions/trackScreenFunctions.dart';
import '/screens/mapFunctionScreens/playRouteHistoryScreen.dart';
import '/screens/mapFunctionScreens/truckAnalysisScreen.dart';
import '/screens/mapFunctionScreens/truckHistoryScreen.dart';
import 'package:url_launcher/url_launcher.dart';
import '../screens/nearbyPlacesScreen.dart';

class TrackScreenDetails extends StatefulWidget {
  // final String? driverNum;
  final String? TruckNo;
//  final String? driverName;
  DateTimeRange? dateRange;
  var gpsData;
  // var gpsTruckRoute;
  var gpsDataHistory;
  var gpsStoppageHistory;
  var stops;
  var totalRunningTime;
  var totalStoppedTime;
  var deviceId;
  //var truckId;
  // var totalDistance;
  var imei;
  var recentStops;
  var finalDistance;

  TrackScreenDetails({
    required this.finalDistance,
    required this.gpsData,
    // required this.gpsTruckRoute,
    required this.gpsDataHistory,
    required this.gpsStoppageHistory,
    //  required this.driverNum,
    required this.dateRange,
    required this.TruckNo,
    //  required this.driverName,
    required this.stops,
    required this.totalRunningTime,
    required this.totalStoppedTime,
    required this.deviceId,
    //required this.truckId,
    // required this.totalDistance,
    this.imei,
    this.recentStops,
  });

  @override
  _TrackScreenDetailsState createState() => _TrackScreenDetailsState();
}

class _TrackScreenDetailsState extends State<TrackScreenDetails> {
  var waiting;
  var gpsData;
//  var gpsTruckRoute;
  var finalDistance;
  var gpsDataHistory;
  var gpsStoppageHistory;
  var stops;
  var totalRunningTime = "";
  var totalStoppedTime = "";
  var latitude;
  var longitude;
  var totalDistance;
  var recentStops;
  late Timer timer;
  DateTime now =
      DateTime.now().subtract(const Duration(days: 0, hours: 5, minutes: 30));
  DateTime yesterday =
      DateTime.now().subtract(const Duration(days: 1, hours: 5, minutes: 30));
  String selectedLocation = '24 hours';
  @override
  void initState() {
    super.initState();
    initFunction2();
    initFunction();

    timer = Timer.periodic(
        const Duration(minutes: 0, seconds: 10), (Timer t) => initFunction2());
  }

  distanceCalculation(String from, String to) async {
    var gpsRoute1 = await mapUtil.getTraccarSummary(
        deviceId: widget.gpsData.last.deviceId, from: from, to: to);
    setState(() {
      totalDistance = (gpsRoute1[0].distance / 1000).toStringAsFixed(2);
    });
  }

  initFunction2() {
    setState(() {
      finalDistance = widget.finalDistance;
      gpsStoppageHistory = widget.gpsStoppageHistory;

      recentStops = widget.recentStops;
      gpsData = widget.gpsData;
      // gpsTruckRoute = widget.gpsTruckRoute;
      gpsDataHistory = widget.gpsDataHistory;
      gpsStoppageHistory = widget.gpsStoppageHistory;
      stops = widget.stops;
      totalRunningTime = widget.totalRunningTime;
      totalStoppedTime = widget.totalStoppedTime;
      latitude = gpsData.last.latitude;
      longitude = gpsData.last.longitude;

      //  status = getStatus(newGPSData, gpsStoppageHistory);
      //  gpsTruckRoute = getStopList(gpsTruckRoute, yesterday, now);
    });
  }

  initFunction() {
    distanceCalculation(yesterday.toIso8601String(), now.toIso8601String());
    // distancecalculation(widget.dateRange!.start.toIso8601String(),
    //     widget.dateRange!.end.toIso8601String());
  }

  getValue() {
    setState(() {
      if (gpsDataHistory == null) {
        waiting = true;
      } else {
        waiting = false;
      }
    });
  }

  static Future<void> openMap(double latitude, double longitude) async {
    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunchUrl(Uri.parse(googleUrl))) {
      await launchUrl(Uri.parse(googleUrl));
    } else {
      throw 'Could not open the map.';
    }
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      // height: height / 3 + 106,
      // width: width,
      height: height,
      width: width / 3,
      padding: EdgeInsets.fromLTRB(0, 0, 0, space_3),
      decoration: const BoxDecoration(
        color: white,
        // borderRadius: BorderRadius.only(
        //     topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 25,
            ),
            Center(
              child: Container(
                height: 51,
                width: 186,
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(9, 183, 120, 0.2),
                ),
                child: const Center(
                  child: Text(
                    "In Transit",
                    style: TextStyle(
                        fontSize: 16, color: Color.fromRGBO(9, 183, 120, 1)),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 30,
            ),
            const Divider(
              color: Color.fromRGBO(9, 183, 20, 1),
              // height: size_3,
              thickness: 5,
              indent: 10,
              endIndent: 10,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 20,
            ),
            //Mid Data
            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.fromLTRB(size_10, size_3, size_10, space_3),
              child: Center(
                child: Container(
                  height: MediaQuery.of(context).size.height / 2.35,
                  width: MediaQuery.of(context).size.width / 4.5,
                  decoration: const BoxDecoration(
                      color: Color.fromRGBO(245, 246, 250, 1)),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(30, 30, 30, 30),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        //adress button
                        Row(children: [
                          Image.asset("assets/icons/gps.png",
                              width: 30, height: 30),
                          SizedBox(
                            width:
                                (MediaQuery.of(context).size.width / 4.5) - 90,
                            child: Column(
                              children: [
                                const Text("Current Location",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Color.fromRGBO(21, 41, 104, 1))),
                                Padding(
                                  padding: const EdgeInsets.only(left: 25.0),
                                  child: Text(
                                    "${gpsData.last.address}",
                                    maxLines: 2,
                                    style: TextStyle(
                                        color: const Color.fromRGBO(
                                            135, 135, 135, 1),
                                        fontSize: 12,
                                        fontStyle: FontStyle.normal,
                                        fontWeight: normalWeight),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ]),
                        // Speed button
                        Row(
                          children: [
                            Image.asset("assets/icons/speedmeter.png",
                                width: 30, height: 30),
                            SizedBox(
                              width: (MediaQuery.of(context).size.width / 4.5) -
                                  90,
                              child: Column(
                                children: [
                                  const Text(
                                    "Speed",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Color.fromRGBO(21, 41, 104, 1)),
                                  ),
                                  Align(
                                    alignment: Alignment.center,
                                    child: (widget.gpsData.last.speed > 2)
                                        ? SizedBox(
                                            width: (MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                15),
                                            child: Row(children: [
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    50,
                                              ),
                                              Text(
                                                  "${(gpsData.last.speed).round()} ",
                                                  style: TextStyle(
                                                      color: liveasyGreen,
                                                      fontSize: size_10,
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      fontWeight:
                                                          regularWeight)),
                                              Text("km/h".tr,
                                                  style: TextStyle(
                                                      color:
                                                          const Color.fromRGBO(
                                                              135, 135, 135, 1),
                                                      fontSize: size_6,
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      fontWeight:
                                                          regularWeight)),
                                            ]),
                                          )
                                        : SizedBox(
                                            width: (MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                15),
                                            child: Row(children: [
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    50,
                                              ),
                                              Text(
                                                  "${(gpsData.last.speed).round()} ",
                                                  style: TextStyle(
                                                      color: red,
                                                      fontSize: size_10,
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      fontWeight:
                                                          regularWeight)),
                                              Text("km/h".tr,
                                                  style: TextStyle(
                                                      color: red,
                                                      fontSize: size_6,
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      fontWeight:
                                                          regularWeight)),
                                            ]),
                                          ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        //traveled Km
                        Row(children: [
                          Image.asset("assets/icons/KmTravelled.png",
                              width: 30, height: 30),
                          SizedBox(
                            width:
                                (MediaQuery.of(context).size.width / 4.5) - 90,
                            child: Column(
                              children: [
                                Column(
                                  children: [
                                    Text('Kilometer Travelled'.tr,
                                        softWrap: true,
                                        style: TextStyle(
                                          color: const Color.fromRGBO(
                                              21, 41, 104, 1),
                                          fontSize: size_6,
                                          fontStyle: FontStyle.normal,
                                          fontWeight: FontWeight.w600,
                                        )),
                                    Text("$finalDistance ${"km".tr}",
                                        softWrap: true,
                                        style: TextStyle(
                                            color: const Color.fromRGBO(
                                                135, 135, 135, 1),
                                            fontSize: size_6,
                                            fontStyle: FontStyle.normal,
                                            fontWeight: regularWeight)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ]),
                        //stop meter
                        Row(
                          children: [
                            const Icon(Icons.pause, size: 30),
                            SizedBox(
                              width:
                                  (MediaQuery.of(context).size.width / 10) + 50,
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      gpsStoppageHistory != null
                                          ? Padding(
                                              padding: EdgeInsets.only(
                                                  left: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      18),
                                              child: Text(
                                                  "${gpsStoppageHistory.length} ",
                                                  softWrap: true,
                                                  style: TextStyle(
                                                      color: red,
                                                      fontSize: 16,
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      fontWeight:
                                                          regularWeight)),
                                            )
                                          : Padding(
                                              padding: EdgeInsets.only(
                                                  left: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      18),
                                              child: Text(" ",
                                                  softWrap: true,
                                                  style: TextStyle(
                                                      color: red,
                                                      fontSize: 16,
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      fontWeight:
                                                          regularWeight)),
                                            ),
                                      Text("stops".tr,
                                          softWrap: true,
                                          style: const TextStyle(
                                            color:
                                                Color.fromRGBO(21, 41, 104, 1),
                                            fontSize: 14,
                                            fontStyle: FontStyle.normal,
                                            fontWeight: FontWeight.w600,
                                          )),
                                    ],
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left:
                                            MediaQuery.of(context).size.width /
                                                25),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text("${widget.totalStoppedTime}",
                                            softWrap: true,
                                            style: TextStyle(
                                                color: grey,
                                                fontSize: 10,
                                                fontStyle: FontStyle.normal,
                                                fontWeight: regularWeight)),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 20,
            ),
            //Contains Bottom Buttons
            Container(
                alignment: Alignment.center,
                // padding: EdgeInsets.only(left: 15, right: 15),
                margin: EdgeInsets.fromLTRB(0, space_1, 0, space_1),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    //navigator button
                    Column(children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          border: Border.all(color: bidBackground, width: 4),
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: FloatingActionButton(
                          heroTag: "button1",
                          backgroundColor: Colors.white,
                          foregroundColor: bidBackground,
                          child: Image.asset(
                            'assets/icons/navigate2.png',
                            scale: 2.5,
                          ),
                          onPressed: () {
                            openMap(
                                gpsData.last.latitude, gpsData.last.longitude);
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        "navigate".tr,
                        style: TextStyle(
                            color: black,
                            fontSize: size_6,
                            fontStyle: FontStyle.normal,
                            fontWeight: mediumBoldWeight),
                      ),
                    ]),
                    //share button
                    Column(children: [
                      DynamicLinkService(
                        deviceId: widget.deviceId,
                        // truckId: widget.truckId,
                        truckNo: widget.TruckNo,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        "share".tr,
                        style: TextStyle(
                            color: black,
                            fontSize: size_6,
                            fontStyle: FontStyle.normal,
                            fontWeight: mediumBoldWeight),
                      ),
                    ]),
                    //play trip button
                    Column(children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          border: Border.all(color: bidBackground, width: 4),
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: FloatingActionButton(
                          heroTag: "button3",
                          backgroundColor: Colors.white,
                          foregroundColor: bidBackground,
                          child:
                              const Icon(Icons.play_circle_outline, size: 30),
                          onPressed: () {
                            //Checking value of gpsDataHistory, if it's null then waiting until The value not get
                            getValue();
                            if (waiting) {
                              Get.to(
                                const SizedBox(
                                    height: 100,
                                    width: 100,
                                    child: Center(
                                        child: CircularProgressIndicator())),
                              );
                              Timer(const Duration(seconds: 10), () {
                                Navigator.pop(context);
                              });
                              Timer(const Duration(seconds: 10), () {
                                Get.to(PlayRouteHistory(
                                  finalDistance: finalDistance,
                                  ignition: gpsData.last.ignition,
                                  address: gpsData.last.address,
                                  gpsTruckHistory: gpsDataHistory,
                                  truckNo: widget.TruckNo,
                                  //    routeHistory: gpsTruckRoute,
                                  gpsData: gpsData,
                                  dateRange: widget.dateRange.toString(),
                                  gpsStoppageHistory: gpsStoppageHistory,
                                  //   totalDistance: totalDistance,
                                  totalRunningTime: totalRunningTime,
                                  totalStoppedTime: totalStoppedTime,
                                ));
                                Timer(const Duration(seconds: 10), () {
                                  getValue();
                                });
                              });
                            } else {
                              Get.to(PlayRouteHistory(
                                finalDistance: finalDistance,
                                ignition: gpsData.last.ignition,
                                address: gpsData.last.address,
                                gpsTruckHistory: gpsDataHistory,
                                truckNo: widget.TruckNo,
                                //    routeHistory: gpsTruckRoute,
                                gpsData: gpsData,
                                dateRange: widget.dateRange.toString(),
                                gpsStoppageHistory: gpsStoppageHistory,
                                //   totalDistance: totalDistance,
                                totalRunningTime: totalRunningTime,
                                totalStoppedTime: totalStoppedTime,
                              ));
                            }
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        "playtrip".tr,
                        style: TextStyle(
                            color: black,
                            fontSize: size_6,
                            fontStyle: FontStyle.normal,
                            fontWeight: mediumBoldWeight),
                      ),
                    ]),
                    //history button
                    Column(children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          border: Border.all(color: bidBackground, width: 4),
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: FloatingActionButton(
                          heroTag: "button4",
                          backgroundColor: Colors.white,
                          foregroundColor: bidBackground,
                          child: const Icon(Icons.history, size: 30),
                          onPressed: () {
                            Get.to(TruckHistoryScreen(
                              truckNo: widget.TruckNo,
                              //   gpsTruckRoute: widget.gpsTruckRoute,
                              dateRange: widget.dateRange.toString(),
                              deviceId: widget.deviceId,
                              selectedLocation: selectedLocation,
                              istDate1: yesterday,
                              istDate2: now,
                              totalDistance: totalDistance,
                              gpsDataHistory: widget.gpsDataHistory,
                              gpsStoppageHistory: widget.gpsStoppageHistory,
                              //     latitude: latitude,
                              //      longitude: longitude,
                            ));
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        "history".tr,
                        style: TextStyle(
                            color: black,
                            fontSize: size_6,
                            fontStyle: FontStyle.normal,
                            fontWeight: mediumBoldWeight),
                      ),
                    ]),
                  ],
                )),
          ]),
    );
  }
}

  
//Ignition 
// Container(
//                               margin: const EdgeInsets.fromLTRB(2, 0, 0, 0),
//                               child: Row(
//                                   mainAxisAlignment: MainAxisAlignment.start,
//                                   //  textDirection:
//                                   crossAxisAlignment: CrossAxisAlignment.center,
//                                   children: [
//                                     Image.asset(
//                                       'assets/icons/circle-outline-with-a-central-dot.png',
//                                       color: bidBackground,
//                                       width: 11,
//                                       height: 11,
//                                     ),
//                                     const SizedBox(width: 10),
//                                     Container(
//                                       alignment: Alignment.centerLeft,
//                                       child: Text('ignition'.tr,
//                                           softWrap: true,
//                                           style: TextStyle(
//                                               color: black,
//                                               fontSize: 12,
//                                               fontStyle: FontStyle.normal,
//                                               fontWeight: regularWeight)),
//                                     ),
//                                     (gpsData.last.ignition)
//                                         ? Container(
//                                             alignment: Alignment.centerLeft,
//                                             //    width: 217,
//                                             child: Text('on'.tr,
//                                                 softWrap: true,
//                                                 style: const TextStyle(
//                                                     color: black,
//                                                     fontSize: 12,
//                                                     fontStyle: FontStyle.normal,
//                                                     fontWeight:
//                                                         FontWeight.bold)),
//                                           )
//                                         : Container(
//                                             alignment: Alignment.centerLeft,
//                                             //    width: 217,
//                                             child: Text("off".tr,
//                                                 softWrap: true,
//                                                 style: const TextStyle(
//                                                     color: black,
//                                                     fontSize: 12,
//                                                     fontStyle: FontStyle.normal,
//                                                     fontWeight:
//                                                         FontWeight.bold)),
//                                           ),
//                                     const SizedBox(),
//                                   ]),
//                             ),