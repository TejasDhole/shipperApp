import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shipper_app/constants/colors.dart';
import 'package:shipper_app/constants/fontSize.dart';
import 'package:shipper_app/providerClass/providerData.dart';

import '../../Web/screens/PublishMethodBidWebScreen.dart';

class LoadPublishMethodWebWidget extends StatefulWidget {
  @override
  State<LoadPublishMethodWebWidget> createState() =>
      _LoadPublishMethodWebWidgetState();
}

class _LoadPublishMethodWebWidgetState
    extends State<LoadPublishMethodWebWidget> {
  List<String> publishMethods = ['Bid', 'Contract', 'Select'];
  List<String> imagePath = [
    'assets/images/load_publish_bid.png',
    'assets/images/load_publish_contract.png',
    'assets/images/load_publish_select.png'
  ];

  @override
  Widget build(BuildContext context) {
    ProviderData providerData = Provider.of<ProviderData>(context);
    return Container(
      child: DropdownSearch<String>(
        onChanged: (value) {
          if (value == publishMethods[0]) {
            Get.to(() => PublishMethodBidWebScreen(
                  publishMethod: value,
                ));
          } else if (value == publishMethods[1]) {
            providerData.updatePublishMethod(value);
          } else if (value == publishMethods[2]) {
            Get.to(() => PublishMethodBidWebScreen(
                  publishMethod: value,
                ));
          }
        },
        selectedItem: (providerData.publishMethod != '')
            ? providerData.publishMethod
            : null,
        popupProps: PopupProps.menu(
            title: Container(
                padding: EdgeInsets.only(
                  top: 5,
                ),
                child: Text("Publish Method",
                    style: TextStyle(
                        color: truckGreen,
                        fontSize: size_10,
                        fontFamily: 'Montserrat'),
                    textAlign: TextAlign.center)),
            itemBuilder: (context, item, isSelected) {
              return Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                            height: 20,
                            width: 20,
                            child: Image.asset(
                                imagePath[publishMethods.indexOf(item)])),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          '$item',
                          style: TextStyle(
                              color: kLiveasyColor,
                              fontFamily: 'Montserrat',
                              fontSize: size_8,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    (publishMethods.indexOf(item) != 2)
                        ? Divider(
                            thickness: 1,
                            height: 0,
                          )
                        : Container()
                  ],
                ),
                alignment: Alignment.center,
              );
            },
            fit: FlexFit.loose),
        items: publishMethods,
        dropdownDecoratorProps: DropDownDecoratorProps(
          baseStyle: TextStyle(
              color: kLiveasyColor,
              fontFamily: 'Montserrat',
              fontSize: size_8,
              fontWeight: FontWeight.w500),
          textAlign: TextAlign.center,
          dropdownSearchDecoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.zero,
                  borderSide: BorderSide(color: truckGreen, width: 1.5)),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.zero,
                  borderSide: BorderSide(color: borderLightColor, width: 1.5)),
              floatingLabelBehavior: FloatingLabelBehavior.always,
              label: Text('Publishing Method',
                  style: TextStyle(
                      color: kLiveasyColor,
                      fontFamily: 'Montserrat',
                      fontSize: size_10,
                      fontWeight: FontWeight.w600),
                  selectionColor: kLiveasyColor),
              hintText: 'Choose Publish Method',
              hintStyle: TextStyle(
                  color: borderLightColor,
                  fontFamily: 'Montserrat',
                  fontSize: size_8,
                  fontWeight: FontWeight.w500)),
        ),
      ),
    );
  }
}
