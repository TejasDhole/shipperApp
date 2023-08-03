import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shipper_app/Widgets/loadDetailsWebWidgets/loadDetailsHeader.dart';
import 'package:shipper_app/constants/colors.dart';
import 'package:shipper_app/constants/fontSize.dart';

import 'package:shipper_app/providerClass/providerData.dart';

class ProductTypeSelection extends StatefulWidget {
  @override
  State<ProductTypeSelection> createState() => _ProductTypeSelectionState();
}

class _ProductTypeSelectionState extends State<ProductTypeSelection> {
  List<String> productType = [
    'Agriculture and Food',
    'Alcoholic Beverage',
    'Auto Parts / Machine',
    'Chemical / Powder',
    'Construction Material',
    'Cylinders',
    'Chukkey',
    'DOC',
    'Electronic Goods / Battery',
    'Packaged / Consumer',
    'Paints / Petroleum',
    'Putty',
    'Scrap',
    'Taar',
    'Oil',
    'Others'
  ];

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
              title: 'Select Trailer Body Type',
              subTitle: 'We need some details from you.'),
          Container(
            height: 10,
            color: lineDividerColor,
          ),
          Container(
            color: white,
            padding: EdgeInsets.all(10),
            child: Text(
              'Recent',
              style: TextStyle(
                  color: kLiveasyColor,
                  fontFamily: 'Montserrat',
                  fontSize: size_9),
            ),
          ),
          Container(
            color: white,
            padding: EdgeInsets.all(10),
            height: 100,
            child: Center(
              child: Text(
                'No Recent Item Found',
                style: TextStyle(
                    color: textLightColor,
                    fontFamily: 'Montserrat',
                    fontSize: size_12),
              ),
            ),
          ),
          Container(
            color: white,
            padding: EdgeInsets.all(10),
            child: Text(
              'Recommended',
              style: TextStyle(
                  color: kLiveasyColor,
                  fontFamily: 'Montserrat',
                  fontSize: size_9),
            ),
          ),
          Expanded(
            child: GridView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 0,
                  mainAxisExtent: 50),
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    InkWell(
                      onTap: () {
                        if (productType[index] != 'Other') {
                          setState(() {
                            Get.back();
                            providerData.updateProductType(productType[index]);
                            providerData.updateResetActive(true);
                          });
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: (providerData.productType != null &&
                                  providerData.productType ==
                                      productType[index])
                              ? LinearGradient(
                                  colors: [gradientGreyColor, white])
                              : LinearGradient(
                                  colors: [Colors.white, white]),
                        ),
                        padding: EdgeInsets.only(
                            left: 40, right: 40, top: 10, bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                                height: 30,
                                width: 30,
                                child: Image.asset(
                                  'assets/images/load_grey_icon.png',
                                  fit: BoxFit.fill,
                                )),
                            Text(
                              productType[index],
                              style: TextStyle(
                                  color: kLiveasyColor,
                                  fontFamily: 'Montserrat',
                                  fontSize: size_9),
                              textAlign: TextAlign.left,
                            )
                          ],
                        ),
                      ),
                    ),
                    ((productType.length % 2) == 0)
                        ? ((productType.length - 2) > index)
                            ? Divider(
                                thickness: 1,
                                height: 0,
                              )
                            : SizedBox()
                        : ((productType.length - 1) != index)
                            ? Divider(
                                thickness: 1,
                                height: 0,
                              )
                            : SizedBox()
                  ],
                );
              },
              itemCount: productType.length,
            ),
          )
        ],
      ),
    );
  }
}
