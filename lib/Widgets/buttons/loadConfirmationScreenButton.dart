import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shipper_app/Widgets/alertDialog/loadingAlertDialog.dart';
import 'package:shipper_app/constants/screens.dart';
import 'package:shipper_app/responsive.dart';
import 'package:shipper_app/screens/PostLoadScreens/postLoadScreen.dart';
import '/constants/colors.dart';
import '/constants/fontSize.dart';
import '/constants/fontWeights.dart';
import '/constants/radius.dart';
import '/constants/spaces.dart';
import '/controller/navigationIndexController.dart';
import '/controller/postLoadErrorController.dart';
import '/controller/postLoadVariablesController.dart';
import '/controller/shipperIdController.dart';
import '/functions/PostLoadApi.dart';
import '/functions/PutLoadAPI.dart';
import '/functions/postOneSignalNotification.dart';
import '/providerClass/providerData.dart';
import '/screens/PostLoadScreens/PostLoadScreenLoacationDetails.dart';
import '/screens/PostLoadScreens/PostLoadScreenLoadDetails.dart';
import '/screens/PostLoadScreens/postloadnavigation.dart';
import '/screens/navigationScreen.dart';
import '/widgets/alertDialog/CompletedDialog.dart';
import '/widgets/alertDialog/orderFailedAlertDialog.dart';
import 'package:provider/provider.dart';
import 'package:shipper_app/Web/screens/home_web.dart';

class LoadConfirmationScreenButton extends StatelessWidget {
  String title;

  LoadConfirmationScreenButton({Key? key, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // LoadApi loadApi = LoadApi();
    PostLoadErrorController postLoadErrorController =
        Get.put(PostLoadErrorController());
    NavigationIndexController navigationIndexController =
        Get.put(NavigationIndexController());
    ShipperIdController shipperIdController = Get.put(ShipperIdController());
    ProviderData providerData = Provider.of<ProviderData>(context);
    PostLoadVariablesController postLoadVariables =
        Get.put(PostLoadVariablesController());

    String multipleWeight = providerData.passingWeightMultipleValue
        .toString()
        .substring(
            1, providerData.passingWeightMultipleValue.toString().length - 1);

    getData() async {
      String? loadId = '';
      if (loadId == '') {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return LoadingAlertDialog("Please wait adding Load");
          },
        );
      }
      Timer(Duration(seconds: 3), () async {
        Navigator.of(context).pop();
        if (providerData.editLoad == false) {
          loadId = await postLoadAPi(
              postLoadVariables.bookingDate.value,
              shipperIdController.companyId.value,
              providerData.loadingPointPostLoad,
              providerData.loadingPointCityPostLoad,
              providerData.loadingPointStatePostLoad,
              providerData.loadingPointPostLoad2 == ""
                  ? null
                  : providerData.loadingPointPostLoad2,
              providerData.loadingPointCityPostLoad2 == ""
                  ? null
                  : providerData.loadingPointCityPostLoad2,
              providerData.loadingPointStatePostLoad2 == ""
                  ? null
                  : providerData.loadingPointStatePostLoad2,
              providerData.totalTyresValue,
              providerData.productType,
              providerData.truckTypeValue,
              providerData.unloadingPointPostLoad,
              providerData.unloadingPointCityPostLoad,
              providerData.unloadingPointStatePostLoad,
              providerData.unloadingPointPostLoad2 == ""
                  ? null
                  : providerData.unloadingPointPostLoad2,
              providerData.unloadingPointCityPostLoad2 == ""
                  ? null
                  : providerData.unloadingPointCityPostLoad2,
              providerData.unloadingPointStatePostLoad2 == ""
                  ? null
                  : providerData.unloadingPointStatePostLoad2,
              (providerData.passingWeightValue == 0)
                  ? multipleWeight
                  : providerData.passingWeightValue,
              providerData.unitValue == "" ? null : providerData.unitValue,
              providerData.price == 0 ? null : providerData.price,
              providerData.scheduleLoadingTime,
              providerData.scheduleLoadingDate,
              providerData.publishMethod,
              providerData.comment,
              (providerData.loadTransporterList.isEmpty)
                  ? null
                  : providerData.loadTransporterList,
              providerData.biddingEndDate,
              providerData.biddingEndTime);

          if (loadId != null) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return completedDialog(
                    upperDialogText: 'congratulations'.tr,
                    // AppLocalizations.of(context)!.congratulations,
                    lowerDialogText: 'youHaveCompletedYourOrder'.tr
                    // AppLocalizations.of(context)!.youHaveCompletedYourOrder,
                    );
              },
            );
            Timer(
                Duration(seconds: 3),
                () => {
                      navigationIndexController.updateIndex(0),
                      Get.offAll(() => kIsWeb
                          ? HomeScreenWeb(
                              index: screens.indexOf(postLoadScreen),
                              selectedIndex: screens.indexOf(postLoadScreen),
                            )
                          : NavigationScreen()),
                      providerData.resetPostLoadFilters(),
                      providerData.resetPostLoadScreenOne(),
                      providerData.resetPostLoadScreenMultiple(),
                      providerData.updateUpperNavigatorIndex2(0),
                      controller.text = "",
                      controllerOthers.text = ""
                    });
            providerData.updateEditLoad(true, "");

            postNotification(providerData.loadingPointCityPostLoad,
                providerData.unloadingPointCityPostLoad);
          } else {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return OrderFailedAlertDialog();
              },
            );
          }
        } else if (providerData.editLoad == true) {
          loadId = await putLoadAPI(
              providerData.transporterLoadId,
              postLoadVariables.bookingDate.value,
              shipperIdController.companyId.value,
              "${providerData.loadingPointCityPostLoad}, ${providerData.loadingPointStatePostLoad}",
              providerData.loadingPointCityPostLoad,
              providerData.loadingPointStatePostLoad,
              providerData.loadingPointCityPostLoad2 == ""
                  ? null
                  : "${providerData.loadingPointCityPostLoad2}, ${providerData.loadingPointStatePostLoad2}",
              providerData.loadingPointCityPostLoad2 == ""
                  ? null
                  : providerData.loadingPointCityPostLoad2,
              providerData.loadingPointStatePostLoad2 == ""
                  ? null
                  : providerData.loadingPointStatePostLoad2,
              providerData.totalTyresValue,
              providerData.productType,
              providerData.truckTypeValue,
              "${providerData.unloadingPointCityPostLoad}, ${providerData.unloadingPointStatePostLoad}",
              providerData.unloadingPointCityPostLoad2 == ""
                  ? null
                  : "${providerData.unloadingPointCityPostLoad2}, ${providerData.unloadingPointStatePostLoad2}",
              providerData.unloadingPointCityPostLoad2 == ""
                  ? null
                  : providerData.unloadingPointCityPostLoad2,
              providerData.unloadingPointStatePostLoad2 == ""
                  ? null
                  : providerData.unloadingPointStatePostLoad2,
              providerData.unloadingPointCityPostLoad,
              providerData.unloadingPointStatePostLoad,
              providerData.passingWeightValue,
              providerData.unitValue == "" ? null : providerData.unitValue,
              providerData.price == 0 ? null : providerData.price);

          if (loadId != null) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return completedDialog(
                    upperDialogText: 'congratulations'.tr,
                    // AppLocalizations.of(context)!.congratulations,
                    lowerDialogText: 'youHaveSuccessfullyUpdateYourOrder'.tr
                    // AppLocalizations.of(context)!.youHaveSuccessfullyUpdateYourOrder,
                    );
              },
            );
            Timer(
                Duration(seconds: 3),
                () => {
                      Get.offAll(
                          () => kIsWeb ? HomeScreenWeb() : NavigationScreen()),
                      navigationIndexController.updateIndex(0),
                      providerData.resetPostLoadFilters(),
                      providerData.resetPostLoadScreenOne(),
                      providerData.resetPostLoadScreenMultiple(),
                      providerData.updateUpperNavigatorIndex2(0),
                      controller.text = "",
                      controllerOthers.text = ""
                    });
            providerData.updateEditLoad(false, "");
          } else {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return OrderFailedAlertDialog();
              },
            );
          }
        }
      });
    }

    return GestureDetector(
      onTap: () {
        // title=="Edit"?Get.to(PostLoadScreenOne()):
        if (title == "Edit") {
          providerData.updateUpperNavigatorIndex2(0);
          Get.to(() => PostLoadNav(
                setChild: Container(),
                index: 0,
              ));
        } else {
          providerData.updateUnitValue();
          getData();
        }
      },
      child: Container(
        height: space_8,
        padding: (Responsive.isMobile(context))
            ? EdgeInsets.only(left: 20, right: 20)
            : EdgeInsets.only(left: 40, right: 40),
        decoration: BoxDecoration(
            color: (title == 'Confirm') ? truckGreen : darkBlueColor,
            borderRadius: BorderRadius.all(Radius.circular(0))),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
                color: white,
                fontWeight: mediumBoldWeight,
                fontSize: size_8,
                fontFamily: 'Montserrat'),
          ),
        ),
      ),
    );
  }
}
