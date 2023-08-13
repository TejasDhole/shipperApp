import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shipper_app/providerClass/providerData.dart';
import 'package:shipper_app/screens/PostLoadScreens/TruckTypePostLoadDetailsScreen.dart';
import 'package:shipper_app/variables/truckFilterVariablesForPostLoad.dart';

import 'package:shipper_app/constants/colors.dart';
import 'package:shipper_app/constants/fontSize.dart';

class TruckTypeWebWidget extends StatefulWidget {
  @override
  State<TruckTypeWebWidget> createState() => _TruckTypeWebWidgetState();
}

class _TruckTypeWebWidgetState extends State<TruckTypeWebWidget> {
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
  String loadWeight = '';
  TextEditingController txtTruckTypeController = TextEditingController();
  TruckFilterVariablesForPostLoad truckFilterVariables =
      TruckFilterVariablesForPostLoad();

  @override
  Widget build(BuildContext context) {
    txtTruckTypeController.clear();
    ProviderData providerData = Provider.of<ProviderData>(context);
    loadWeight = '';
    for (int x = 0; x < providerData.passingWeightMultipleValue.length; x++) {
      loadWeight += providerData.passingWeightMultipleValue[x];

      if (x != (providerData.passingWeightMultipleValue.length - 1)) {
        loadWeight += ', ';
      }
    }

    if (providerData.truckTypeValue != '' &&
        providerData.truckTypeValue != null &&
        loadWeight != '') {
      print(providerData.truckTypeValue);
      txtTruckTypeController.text =
          '${truckName[truckFilterVariables.truckTypeValueList.indexOf(providerData.truckTypeValue)]} ; $loadWeight tons';
    }

    return Container(
      child: TextField(
        controller: txtTruckTypeController,
        style: TextStyle(
            color: kLiveasyColor, fontFamily: 'Montserrat', fontSize: size_8),
        textAlign: TextAlign.center,
        showCursor: false,
        mouseCursor: SystemMouseCursors.click,
        onTap: () {
          Get.to(() => TruckTypePostLoadDetailsScreen());
        },
        decoration: InputDecoration(
            border: OutlineInputBorder(
                borderRadius: BorderRadius.zero,
                borderSide: BorderSide(color: borderLightColor, width: 1.5)),
            hintText: 'Choose Truck Preference',
            hintStyle: TextStyle(
                color: borderLightColor,
                fontFamily: 'Montserrat',
                fontSize: size_8),
            label: Text('Truck Type',
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
    );
  }
}
