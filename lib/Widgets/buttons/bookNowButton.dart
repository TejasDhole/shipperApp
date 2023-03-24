import 'package:flutter/material.dart';
import '/constants/colors.dart';
import '/constants/fontSize.dart';
import '/constants/fontWeights.dart';
import '/constants/radius.dart';
import '/constants/spaces.dart';
import '/controller/shipperIdController.dart';
import '/functions/driverApiCalls.dart';
import '/functions/truckApis/truckApiCalls.dart';
import '/models/driverModel.dart';
import '/models/loadDetailsScreenModel.dart';
import '/models/truckModel.dart';
import '/screens/myLoadPages/bookLoadScreen.dart';
import '/widgets/alertDialog/bookLoadAlertDialogBox.dart';
import '/widgets/alertDialog/verifyAccountNotifyAlertDialog.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class BookNowButton extends StatefulWidget {
  LoadDetailsScreenModel loadDetailsScreenModel;

  BookNowButton({required this.loadDetailsScreenModel});

  @override
  _BookNowButtonState createState() => _BookNowButtonState();
}

class _BookNowButtonState extends State<BookNowButton> {
  // List truckDetailsList = [];
  // List driverDetailsList = [];

  List<TruckModel> truckDetailsList = [];
  List<DriverModel> driverDetailsList = [];

  TruckApiCalls truckApiCalls = TruckApiCalls();
  DriverApiCalls driverApiCalls = DriverApiCalls();
  ShipperIdController shipperIdController =
      Get.put(ShipperIdController());

  @override
  void initState() {
    super.initState();
    loadData();
  }

  loadData() async {
    truckDetailsList = await truckApiCalls.getTruckData();
    driverDetailsList = await driverApiCalls.getDriversByTransporterId();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () async {
          await showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) =>
                shipperIdController.companyApproved.value
                    ? BookLoadScreen(
                        truckModelList: truckDetailsList,
                        driverModelList: driverDetailsList,
                        loadDetailsScreenModel: widget.loadDetailsScreenModel,
                        directBooking: true,
                      )
                    : VerifyAccountNotifyAlertDialog(),
          );
        },
        child: Container(
          height: space_8,
          width: (space_16 * 2) + 3,
          decoration: BoxDecoration(
              color: darkBlueColor,
              borderRadius: BorderRadius.circular(radius_6)),
          child: Center(
            child: Text(
              'bookNow'.tr,
              // AppLocalizations.of(context)!.bookNow,
              style: TextStyle(
                  fontSize: size_8, fontWeight: mediumBoldWeight, color: white),
            ),
          ),
        ));
  }
}
