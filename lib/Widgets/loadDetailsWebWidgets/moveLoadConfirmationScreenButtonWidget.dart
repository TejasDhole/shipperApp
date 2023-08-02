import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shipper_app/constants/colors.dart';
import 'package:shipper_app/constants/fontSize.dart';
import 'package:shipper_app/constants/fontWeights.dart';
import 'package:shipper_app/providerClass/providerData.dart';
import 'package:shipper_app/responsive.dart';
import 'package:shipper_app/screens/PostLoadScreens/loadConfirmation.dart';

class moveLoadConfirmationScreenButtonWidget extends StatefulWidget {
  @override
  State<moveLoadConfirmationScreenButtonWidget> createState() =>
      _moveLoadConfirmationScreenButtonWidgetState();
}

class _moveLoadConfirmationScreenButtonWidgetState
    extends State<moveLoadConfirmationScreenButtonWidget> {
  @override
  Widget build(BuildContext context) {
    bool enable = false;
    ProviderData providerData = Provider.of<ProviderData>(context);
    print(providerData.truckTypeValue);
    print(providerData.passingWeightMultipleValue);
    print(providerData.productType);
    print(providerData.totalTyresValue);
    print(providerData.scheduleLoadingDate);
    print(providerData.scheduleLoadingTime);
    print(providerData.biddingEndTime ?? 'NUll');
    print(providerData.biddingEndDate ?? 'NULL');
    print(providerData.loadTransporterList);
    print(providerData.publishMethod);
    print(providerData.comment);

    if (providerData.truckTypeValue != '' &&
        providerData.passingWeightMultipleValue != [] &&
        providerData.productType != "Choose Product Type" &&
        providerData.totalTyresValue != 0 &&
        providerData.scheduleLoadingDate != '' &&
        providerData.publishMethod != '') {
      if (providerData.publishMethod == 'Bid' &&
          providerData.biddingEndTime != null &&
          providerData.biddingEndDate != null &&
          providerData.loadTransporterList != []) {
        enable = true;
      } else if (providerData.publishMethod == 'Select' &&
          providerData.loadTransporterList != []) {
        enable = true;
        providerData.biddingEndTime = null;
        providerData.biddingEndDate = null;
      } else if (providerData.publishMethod == 'Contract') {
        enable = true;
        providerData.biddingEndTime = null;
        providerData.biddingEndDate = null;
        providerData.loadTransporterList = [];
      }
    }
    return TextButton(
      style: ButtonStyle(
        padding: MaterialStatePropertyAll(
            EdgeInsets.only(left: 60, right: 60, top: 20, bottom: 20)),
        mouseCursor: MaterialStatePropertyAll(
            (enable) ? SystemMouseCursors.click : SystemMouseCursors.basic),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
          borderRadius: (Responsive.isMobile(context))
              ? BorderRadius.circular(50)
              : BorderRadius.all(Radius.zero),
        )),
        backgroundColor: MaterialStateProperty.all<Color>(
            (enable) ? truckGreen : disableButtonColor),
      ),
      onPressed: () {
        if (enable) {
          Get.to(() => LoadConfirmation());
        }
      },
      child: Text(
        'Next', // AppLocalizations.of(context)!.postLoad,
        style: TextStyle(
            fontWeight: mediumBoldWeight,
            color: white,
            fontSize: size_8,
            fontFamily: 'Montserrat'),
      ),
    );
  }
}
