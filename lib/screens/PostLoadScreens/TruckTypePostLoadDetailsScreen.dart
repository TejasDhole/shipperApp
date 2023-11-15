import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shipper_app/Web/screens/home_web.dart';
import 'package:shipper_app/constants/colors.dart';
import 'package:shipper_app/constants/fontSize.dart';
import 'package:shipper_app/constants/screens.dart';
import 'package:shipper_app/providerClass/providerData.dart';
import 'package:shipper_app/screens/PostLoadScreens/PostLoadScreenLoadDetails.dart';
import 'package:shipper_app/variables/truckFilterVariablesForPostLoad.dart';

import 'package:shipper_app/Web/screens/LoadTruckWeightSelectScreenWeb.dart';
import 'package:shipper_app/Widgets/loadDetailsWebWidgets/loadDetailsHeader.dart';

class TruckTypePostLoadDetailsScreen extends StatefulWidget {
  @override
  State<TruckTypePostLoadDetailsScreen> createState() =>
      _TruckTypePostLoadDetailsScreenState();
}

class _TruckTypePostLoadDetailsScreenState
    extends State<TruckTypePostLoadDetailsScreen> {
  //always check variable truckName, truckImage, loadWeightTons, truckTypeDescription while inserting, deleting or updating any truck

  List<String> truckName = [
    'Open Body',
    'Flat Bed',
    'Trailer Body',
    'Standard Container',
    'High-Cube Container',
    'Tanker',
    'Tipper',
    'Bulker',
    'LCV Open Body',
    'LCV Container',
    'Mini / Pickup Truck'
  ];
  List<String> truckImage = [
    'assets/images/truckTypeImage/open_body.png',
    'assets/images/truckTypeImage/flat_bed.png',
    'assets/images/truckTypeImage/trailer_body.png',
    'assets/images/truckTypeImage/standard_container.png',
    'assets/images/truckTypeImage/high_cube_container.png',
    'assets/images/truckTypeImage/tanker.png',
    'assets/images/truckTypeImage/tipper.png',
    'assets/images/truckTypeImage/bulker.png',
    'assets/images/truckTypeImage/lcv_open_body.png',
    'assets/images/truckTypeImage/lcv_open_container.png',
    'assets/images/truckTypeImage/mini_pickup.png',
  ];

  //every inner list: 0th index is the minimum weight and 1th index is the max weight

  List<List<double>> loadWeightTons = [
    [7, 43],
    [16, 43],
    [22, 43],
    [7.5, 30],
    [7, 43],
    [8, 36],
    [9, 30],
    [21, 30],
    [2.5, 7],
    [6, 7],
    [0.75, 2]
  ];

  List<String> truckTypeDescription = [
    'Trucks with Open body',
    'Trucks with Flat bed',
    'Trailer Trucks with Open body',
    'Closed body Trucks',
    'Trucks with high-cube Container',
    'Truck with Tanker',
    'Truck with Tipper',
    'Truck with Bulker',
    'Truck with LCV Open Body',
    'Truck with LCV Container',
    'Mine / Pickup Truck'
  ];

  TruckFilterVariablesForPostLoad truckFilterVariables =
      TruckFilterVariablesForPostLoad();

  @override
  Widget build(BuildContext context) {
    ProviderData providerData = Provider.of<ProviderData>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LoadDetailsHeader(
              reset: () {
                List<String> empList = [];
                providerData.updateResetActive(true);
                providerData.updateTruckTypeValue("");
                providerData.resetOnNewType();
                providerData.updatePassingWeightMultipleValue(empList);
              },
              title: 'Choose a Truck Type',
              subTitle: 'What type of truck you require?',
              previousScreen: (kIsWeb)
                  ? HomeScreenWeb(
                      index: screens.indexOf(postLoadScreenTwo),
                      selectedIndex: screens.indexOf(postLoadScreen),
                    )
                  : PostLoadScreenTwo()),
          Container(
            height: 10,
            color: lineDividerColor,
          ),
          Container(
            height: 80,
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                    bottom: BorderSide(color: unselectedGrey, width: 1),
                    top: BorderSide(color: unselectedGrey, width: 1),
                    left: BorderSide(color: unselectedGrey, width: 1),
                    right: BorderSide(color: unselectedGrey, width: 1))),
            child: Row(
              children: [
                Expanded(
                    flex: 4,
                    child: Center(
                      child: Container(),
                    )),
                VerticalDivider(
                  thickness: 1,
                  width: 0,
                  color: unselectedGrey,
                ),
                Expanded(
                    flex: 4,
                    child: Center(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Container(
                          child: Text('Truck Type',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: unselectedGrey,
                                  fontSize: size_9,
                                  fontFamily: 'Montserrat')),
                        ),
                      ),
                    )),
                VerticalDivider(
                  thickness: 1,
                  width: 0,
                  color: unselectedGrey,
                ),
                Expanded(
                    flex: 3,
                    child: Center(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Container(
                          child: Text('Tons',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: unselectedGrey,
                                  fontSize: size_9,
                                  fontFamily: 'Montserrat')),
                        ),
                      ),
                    )),
                VerticalDivider(
                  thickness: 1,
                  width: 0,
                  color: unselectedGrey,
                ),
                Expanded(
                    flex: 6,
                    child: Center(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Container(
                          child: Text('Description',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: unselectedGrey,
                                  fontSize: size_9,
                                  fontFamily: 'Montserrat')),
                        ),
                      ),
                    )),
                VerticalDivider(
                  thickness: 1,
                  width: 0,
                  color: unselectedGrey,
                ),
                Expanded(
                    flex: 1,
                    child: Center(
                      child: Container(),
                    )),
              ],
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Expanded(
              child: ListView.separated(
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  if (providerData.truckTypeValue !=
                      truckFilterVariables.truckTypeValueList[index]) {
                    String emp = '';
                    List<String> empList = [];
                    providerData.updateResetActive(true);
                    providerData.updateTruckTypeValue(emp);
                    providerData.resetOnNewType();
                    providerData.updatePassingWeightMultipleValue(empList);
                  }

                  if (kIsWeb) {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HomeScreenWeb(
                                  visibleWidget: LoadTruckWeightSelectScreenWeb(
                                    truckTypeName: truckName[index],
                                    minWeight: loadWeightTons[index][0],
                                    maxWeight: loadWeightTons[index][1],
                                    truckTypeValue: truckFilterVariables
                                        .truckTypeValueList[index],
                                  ),
                                  index: 1000,
                                  selectedIndex:
                                      screens.indexOf(postLoadScreen),
                                )));
                  } else {
                    Get.to(() => LoadTruckWeightSelectScreenWeb(
                          truckTypeName: truckName[index],
                          minWeight: loadWeightTons[index][0],
                          maxWeight: loadWeightTons[index][1],
                          truckTypeValue:
                              truckFilterVariables.truckTypeValueList[index],
                        ));
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                      gradient: (providerData.truckTypeValue != null &&
                              providerData.truckTypeValue ==
                                  truckFilterVariables
                                      .truckTypeValueList[index])
                          ? LinearGradient(
                              colors: [gradientGreyColor, Colors.white])
                          : LinearGradient(
                              colors: [Colors.white, Colors.white])),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: Center(
                          child: Container(
                            padding: EdgeInsets.only(top: 10, bottom: 10),
                            child: Image.asset(
                              truckImage[index],
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                      VerticalDivider(width: 0),
                      Expanded(
                          flex: 4,
                          child: Center(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Container(
                                padding: EdgeInsets.only(top: 10, bottom: 10),
                                child: Text(truckName[index],
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: kLiveasyColor,
                                        fontSize: size_8,
                                        fontFamily: 'Montserrat')),
                              ),
                            ),
                          )),
                      VerticalDivider(width: 0),
                      Expanded(
                          flex: 3,
                          child: Center(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Container(
                                padding: EdgeInsets.only(top: 10, bottom: 10),
                                child: Text(
                                    '${loadWeightTons[index][0]} - ${loadWeightTons[index][1]} tons',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: kLiveasyColor,
                                        fontSize: size_8,
                                        fontFamily: 'Montserrat')),
                              ),
                            ),
                          )),
                      VerticalDivider(width: 0),
                      Expanded(
                          flex: 6,
                          child: Center(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Container(
                                padding: EdgeInsets.only(top: 10, bottom: 10),
                                child: Text(truckTypeDescription[index],
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: kLiveasyColor,
                                        fontSize: size_8,
                                        fontFamily: 'Montserrat')),
                              ),
                            ),
                          )),
                      VerticalDivider(width: 0),
                      Expanded(
                          flex: 1,
                          child: Center(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Container(
                                padding: EdgeInsets.only(top: 10, bottom: 10),
                                child: Icon(
                                  Icons.arrow_forward_ios_sharp,
                                  size: 20,
                                  color: truckGreen,
                                ),
                              ),
                            ),
                          )),
                    ],
                  ),
                ),
              );
            },
            itemCount: truckName.length,
            separatorBuilder: (BuildContext context, int index) {
              return Divider(
                color: unselectedGrey,
                thickness: 1,
                height: 0,
              );
            },
          ))
        ],
      ),
    );
  }
}
