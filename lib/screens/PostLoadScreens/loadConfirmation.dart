import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shipper_app/Widgets/loadDetailsWebWidgets/loadDetailsHeader.dart';
import 'package:shipper_app/responsive.dart';
import '/constants/colors.dart';
import '/constants/fontSize.dart';
import '/constants/fontWeights.dart';
import '/constants/spaces.dart';
import '/controller/postLoadVariablesController.dart';
import '/widgets/LoadConfirmationTemplate.dart';
import '/widgets/buttons/backButtonWidget.dart';
import '/widgets/buttons/loadConfirmationScreenButton.dart';
import '/widgets/headingTextWidget.dart';
import '/providerClass/providerData.dart';
import 'package:provider/provider.dart';

class LoadConfirmation extends StatefulWidget {
  const LoadConfirmation({Key? key}) : super(key: key);

  @override
  _LoadConfirmationState createState() => _LoadConfirmationState();
}

class _LoadConfirmationState extends State<LoadConfirmation> {
  @override
  Widget build(BuildContext context) {
    ProviderData providerData = Provider.of<ProviderData>(context);
    WidgetsBinding.instance
        .addPostFrameCallback((_) => providerData.updateUnitValue());
    // providerData.updateLoadWidget(true);
    PostLoadVariablesController postLoadVariables =
        Get.put(PostLoadVariablesController());

    String multipleWeight = providerData.passingWeightMultipleValue
        .toString()
        .substring(
            1, providerData.passingWeightMultipleValue.toString().length - 1);

    return Scaffold(
      backgroundColor: white,
      body: (kIsWeb)
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LoadDetailsHeader(
                    title: 'Load Confirmation',
                    subTitle: 'Review the load details'),
                Expanded(
                  child: Center(
                    child: SizedBox(
                      width: (Responsive.isDesktop(context) ||
                              Responsive.isTablet(context))
                          ? MediaQuery.of(context).size.width * 0.5
                          : MediaQuery.of(context).size.width * 0.9,
                      child: Card(
                        elevation: 5,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(space_3, 0, space_3, 0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              LoadConfirmationTemplate(
                                  value: providerData.loadingPointPostLoad2 !=
                                          ""
                                      ? providerData.unloadingPointPostLoad2 !=
                                              ""
                                          ? "${providerData.loadingPointPostLoad}".tr +
                                              "," +
                                              "${providerData.loadingPointCityPostLoad}"
                                                  .tr +
                                              "," +
                                              "${providerData.loadingPointStatePostLoad}"
                                                  .tr +
                                              " + " +
                                              "${providerData.loadingPointPostLoad2}"
                                                  .tr +
                                              "," +
                                              "${providerData.loadingPointCityPostLoad2}"
                                                  .tr +
                                              "," +
                                              "${providerData.loadingPointStatePostLoad2}"
                                                  .tr +
                                              " ==> ${providerData.unloadingPointPostLoad.tr}, ${providerData.unloadingPointCityPostLoad.tr}, ${providerData.unloadingPointStatePostLoad} + ${providerData.unloadingPointPostLoad2}, ${providerData.unloadingPointCityPostLoad2}, ${providerData.unloadingPointStatePostLoad2}"
                                          : "${providerData.loadingPointPostLoad.tr}, ${providerData.loadingPointCityPostLoad.tr}, ${providerData.loadingPointStatePostLoad.tr}" +
                                              " + ${providerData.loadingPointPostLoad2.tr}, ${providerData.loadingPointCityPostLoad2.tr}, ${providerData.loadingPointStatePostLoad2.tr} ==> ${providerData.unloadingPointPostLoad.tr}, ${providerData.unloadingPointCityPostLoad.tr}, ${providerData.unloadingPointStatePostLoad.tr}"
                                      : providerData.unloadingPointPostLoad2 !=
                                              ""
                                          ? "${providerData.loadingPointPostLoad.tr}, ${providerData.loadingPointCityPostLoad.tr}, ${providerData.loadingPointStatePostLoad.tr}" +
                                              " ==> ${providerData.unloadingPointPostLoad.tr}, ${providerData.unloadingPointCityPostLoad.tr}, ${providerData.unloadingPointStatePostLoad.tr} + ${providerData.unloadingPointPostLoad2.tr}, ${providerData.unloadingPointCityPostLoad2.tr}, ${providerData.unloadingPointStatePostLoad2.tr}"
                                          : "${providerData.loadingPointPostLoad.tr}, ${providerData.loadingPointCityPostLoad.tr}, ${providerData.loadingPointStatePostLoad.tr}" +
                                              " ==> ${providerData.unloadingPointPostLoad.tr}, ${providerData.unloadingPointCityPostLoad.tr}, ${providerData.unloadingPointStatePostLoad.tr}",
                                  label: 'location'.tr
                                  // AppLocalizations.of(context)!
                                  //     .location
                                  ),
                              LoadConfirmationTemplate(
                                  value: (providerData.scheduleLoadingTime !=
                                          '')
                                      ? '${postLoadVariables.bookingDate.value} ; ${providerData.scheduleLoadingTime}'
                                      : postLoadVariables.bookingDate.value,
                                  label: 'Scheduling Date & Time'
                                  // AppLocalizations.of(context)!.date
                                  ),
                              LoadConfirmationTemplate(
                                  value: providerData.truckTypeValue,
                                  label: 'truckType'.tr),
                              LoadConfirmationTemplate(
                                  value:
                                      providerData.totalTyresValue.toString(),
                                  label: 'tyre'.tr
                                  // AppLocalizations.of(context)!.tyre
                                  ),
                              LoadConfirmationTemplate(
                                  value:
                                      providerData.passingWeightMultipleValue ==
                                              []
                                          ? 'Weight is Not Selected'
                                          // AppLocalizations.of(context)!
                                          //         .priceNotGiven
                                          : multipleWeight,
                                  label: (providerData
                                              .passingWeightMultipleValue
                                              .length >
                                          1)
                                      ? 'Weights'
                                      : 'Weight'
                                  // AppLocalizations.of(context)!.price
                                  ),
                              LoadConfirmationTemplate(
                                  value: providerData.productType.tr,
                                  label: 'productType'.tr
                                  // AppLocalizations.of(context)!.productType
                                  ),
                              LoadConfirmationTemplate(
                                  value: providerData.publishMethod == ''
                                      ? 'Publish Method Not Selected'
                                      // AppLocalizations.of(context)!
                                      //         .priceNotGiven
                                      : providerData.publishMethod,
                                  label: 'Publishing Method'
                                  // AppLocalizations.of(context)!.price
                                  ),
                              (providerData.publishMethod == 'Bid')
                                  ? LoadConfirmationTemplate(
                                      value: (providerData.biddingEndDate !=
                                                  null &&
                                              providerData.biddingEndTime !=
                                                  null)
                                          ? '${providerData.biddingEndDate} ; ${providerData.biddingEndTime}'
                                          : 'NA',
                                      label: 'Bidding End Date & Time'
                                      // AppLocalizations.of(context)!.price
                                      )
                                  : SizedBox(
                                      height: 0,
                                    )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: space_6),
                  child: Padding(
                    padding: EdgeInsets.only(left: space_8, right: space_8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        LoadConfirmationScreenButton(title: 'Edit'
                            // AppLocalizations.of(context)!.edit
                            ),
                        SizedBox(
                          width: space_10,
                        ),
                        LoadConfirmationScreenButton(title: 'Confirm'
                            // AppLocalizations.of(context)!.confirm
                            ),
                      ],
                    ),
                  ),
                )
              ],
            )
          : SafeArea(
              child: Padding(
                  padding: EdgeInsets.all(space_2),
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: space_4,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: space_2),
                                    child: BackButtonWidget(),
                                  ),
                                  SizedBox(
                                    width: space_3,
                                  ),
                                  HeadingTextWidget('loadConfirmation'.tr
                                      // AppLocalizations.of(context)!.loadConfirmation
                                      ),
                                  // HelpButtonWidget(),
                                ],
                              ),
                              SizedBox(
                                height: space_4,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: space_3),
                                child: Text(
                                  'reviewDetailsForYourLoad'.tr,
                                  // AppLocalizations.of(context)!
                                  //     .reviewDetailsForYourLoad,
                                  style: TextStyle(
                                      fontSize: size_9,
                                      fontWeight: mediumBoldWeight,
                                      color: liveasyBlackColor),
                                ),
                              ),
                              SizedBox(
                                height: space_4,
                              ),
                              Card(
                                elevation: 5,
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(
                                      space_3, space_2, space_3, space_3),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        child: LoadConfirmationTemplate(
                                            value: providerData
                                                        .loadingPointPostLoad2 !=
                                                    ""
                                                ? providerData
                                                            .unloadingPointPostLoad2 !=
                                                        ""
                                                    ? "${providerData.loadingPointPostLoad}".tr +
                                                        "," +
                                                        "${providerData.loadingPointCityPostLoad}"
                                                            .tr +
                                                        "," +
                                                        "${providerData.loadingPointStatePostLoad}"
                                                            .tr +
                                                        " + " +
                                                        "${providerData.loadingPointPostLoad2}"
                                                            .tr +
                                                        "," +
                                                        "${providerData.loadingPointCityPostLoad2}"
                                                            .tr +
                                                        "," +
                                                        "${providerData.loadingPointStatePostLoad2}"
                                                            .tr +
                                                        " ==> ${providerData.unloadingPointPostLoad.tr}, ${providerData.unloadingPointCityPostLoad.tr}, ${providerData.unloadingPointStatePostLoad} + ${providerData.unloadingPointPostLoad2}, ${providerData.unloadingPointCityPostLoad2}, ${providerData.unloadingPointStatePostLoad2}"
                                                    : "${providerData.loadingPointPostLoad.tr}, ${providerData.loadingPointCityPostLoad.tr}, ${providerData.loadingPointStatePostLoad.tr}" +
                                                        " + ${providerData.loadingPointPostLoad2.tr}, ${providerData.loadingPointCityPostLoad2.tr}, ${providerData.loadingPointStatePostLoad2.tr} ==> ${providerData.unloadingPointPostLoad.tr}, ${providerData.unloadingPointCityPostLoad.tr}, ${providerData.unloadingPointStatePostLoad.tr}"
                                                : providerData
                                                            .unloadingPointPostLoad2 !=
                                                        ""
                                                    ? "${providerData.loadingPointPostLoad.tr}, ${providerData.loadingPointCityPostLoad.tr}, ${providerData.loadingPointStatePostLoad.tr}" +
                                                        " ==> ${providerData.unloadingPointPostLoad.tr}, ${providerData.unloadingPointCityPostLoad.tr}, ${providerData.unloadingPointStatePostLoad.tr} + ${providerData.unloadingPointPostLoad2.tr}, ${providerData.unloadingPointCityPostLoad2.tr}, ${providerData.unloadingPointStatePostLoad2.tr}"
                                                    : "${providerData.loadingPointPostLoad.tr}, ${providerData.loadingPointCityPostLoad.tr}, ${providerData.loadingPointStatePostLoad.tr}" +
                                                        " ==> ${providerData.unloadingPointPostLoad.tr}, ${providerData.unloadingPointCityPostLoad.tr}, ${providerData.unloadingPointStatePostLoad.tr}",
                                            label: 'location'.tr
                                            // AppLocalizations.of(context)!
                                            //     .location
                                            ),
                                      ),
                                      LoadConfirmationTemplate(
                                          value: postLoadVariables
                                              .bookingDate.value,
                                          label: 'date'.tr
                                          // AppLocalizations.of(context)!.date
                                          ),
                                      LoadConfirmationTemplate(
                                          value: providerData.truckTypeValue,
                                          label: 'truckType'.tr
                                          // AppLocalizations.of(context)!
                                          //     .truckType
                                          ),
                                      LoadConfirmationTemplate(
                                          value: providerData.totalTyresValue
                                              .toString(),
                                          label: 'tyre'.tr
                                          // AppLocalizations.of(context)!.tyre
                                          ),
                                      LoadConfirmationTemplate(
                                          value: providerData.passingWeightValue
                                              .toString(),
                                          label: 'weight'.tr
                                          // AppLocalizations.of(context)!.weight
                                          ),
                                      LoadConfirmationTemplate(
                                          value: providerData.productType.tr,
                                          label: 'productType'.tr
                                          // AppLocalizations.of(context)!.productType
                                          ),
                                      LoadConfirmationTemplate(
                                          value: providerData.price == 0
                                              ? 'priceNotGiven'.tr
                                              // AppLocalizations.of(context)!
                                              //         .priceNotGiven
                                              : "Rs.${providerData.price}/${providerData.unitValue}",
                                          label: 'price'.tr
                                          // AppLocalizations.of(context)!.price
                                          ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: space_6),
                          child: Padding(
                            padding:
                                EdgeInsets.only(left: space_8, right: space_8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
                                    child: LoadConfirmationScreenButton(
                                        title: 'edit'.tr
                                        // AppLocalizations.of(context)!.edit
                                        )),
                                SizedBox(
                                  width: space_10,
                                ),
                                Expanded(
                                    child: LoadConfirmationScreenButton(
                                        title: 'confirm'.tr
                                        // AppLocalizations.of(context)!.confirm
                                        )),
                              ],
                            ),
                          ),
                        )

                        // HelpButtonWidget(),
                      ],
                    ),
                  )),
            ),
    );
  }
}
