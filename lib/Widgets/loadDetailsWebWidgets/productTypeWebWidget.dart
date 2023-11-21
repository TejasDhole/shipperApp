import 'dart:ui';
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
import 'package:shipper_app/screens/PostLoadScreens/ProductTypeSelectionScreen.dart';

class ProductTypeWebWidget extends StatefulWidget {
  @override
  ProductTypeWebWidgetState createState() {
    return ProductTypeWebWidgetState();
  }
}

class ProductTypeWebWidgetState extends State<ProductTypeWebWidget> {
  TextEditingController txtController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ProviderData providerData = Provider.of<ProviderData>(context);
    if (providerData.productType != null &&
        providerData.productType != '' &&
        providerData.productType != 'Choose Product Type') {
      txtController.text = providerData.productType;
    } else {
      txtController.clear();
    }
    return Expanded(
      child: Container(
        child: TextField(
          controller: txtController,
          style: TextStyle(
              color: kLiveasyColor, fontFamily: 'Montserrat', fontSize: size_8),
          textAlign: TextAlign.center,
          showCursor: false,
          mouseCursor: SystemMouseCursors.click,
          onTap: () {
            Get.to(() => (kIsWeb)
                ? HomeScreenWeb(
                    visibleWidget: ProductTypeSelection(),
                    index: 1000,
                    selectedIndex: screens.indexOf(postLoadScreen),
                  )
                : ProductTypeSelection());
          },
          decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.zero,
                  borderSide: BorderSide(color: borderLightColor, width: 1.5)),
              hintText: 'Choose Product Type',
              hintStyle: TextStyle(
                  color: borderLightColor,
                  fontFamily: 'Montserrat',
                  fontSize: size_8),
              label: Text('Product Type (optional)',
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
      ),
    );
  }
}
