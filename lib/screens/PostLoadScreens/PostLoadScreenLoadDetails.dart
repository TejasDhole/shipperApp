import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:screenshot/screenshot.dart';
import 'package:shipper_app/Web/screens/home_web.dart';
import 'package:shipper_app/Widgets/loadDetailsCommentWidget.dart';
import 'package:shipper_app/Widgets/loadDetailsWebWidgets/BiddingDateTime.dart';
import 'package:shipper_app/Widgets/loadDetailsWebWidgets/loadDetailsHeader.dart';
import 'package:shipper_app/Widgets/loadDetailsWebWidgets/loadingDateWebWidget.dart';
import 'package:shipper_app/Widgets/loadDetailsWebWidgets/loadingTimeWebWidget.dart';
import 'package:shipper_app/Widgets/loadDetailsWebWidgets/moveLoadConfirmationScreenButtonWidget.dart';
import 'package:shipper_app/Widgets/loadDetailsWebWidgets/productTypeWebWidget.dart';
import 'package:shipper_app/Widgets/loadDetailsWebWidgets/truckTypeWebWidget.dart';
import 'package:shipper_app/Widgets/loadDetailsWebWidgets/tyresWebWidget.dart';
import 'package:shipper_app/Widgets/postLoadLocationWidgets/PostLoadMultipleLocationWidget.dart';
import 'package:shipper_app/constants/fontSize.dart';
import 'package:shipper_app/constants/fontWeights.dart';
import 'package:shipper_app/constants/screens.dart';
import 'package:shipper_app/responsive.dart';
import 'package:shipper_app/screens/PostLoadScreens/postloadnavigation.dart';
import '../../Widgets/loadDetailsWebWidgets/loadPublishMethodWebWidget.dart';
import '/constants/colors.dart';
import '/constants/spaces.dart';
import '/providerClass/providerData.dart';
import '/variables/truckFilterVariablesForPostLoad.dart';
import '/widgets/PostLoadScreenTwoSearch.dart';
import '/widgets/PriceTextFieldWidget.dart';
import '/widgets/UnitValueWidget.dart';
import '/widgets/addPostLoadHeader.dart';
import '/widgets/addTruckCircularButtonTemplate.dart';
import '/widgets/addTruckRectangularButtontemplate.dart';
import '/widgets/addTruckSubtitleText.dart';
import '/widgets/buttons/ApplyButton.dart';
import 'package:provider/provider.dart';

class PostLoadScreenTwo extends StatefulWidget {
  const PostLoadScreenTwo({Key? key}) : super(key: key);

  @override
  _PostLoadScreenTwoState createState() => _PostLoadScreenTwoState();
}

TextEditingController controller = TextEditingController();
TextEditingController controllerOthers = TextEditingController();

List<int> numberOfTyresList = [6, 10, 12, 14, 16, 18, 22, 26];
List<int> weightList = [6, 8, 12, 14, 18, 24, 26, 28, 30, 0];
TruckFilterVariablesForPostLoad truckFilterVariables =
    TruckFilterVariablesForPostLoad();

class _PostLoadScreenTwoState extends State<PostLoadScreenTwo> {
  refresh(bool allowToRefresh) {
    if (allowToRefresh) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        setState(() {});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    bool visible = false;
    ProviderData providerData = Provider.of<ProviderData>(context);

    return Scaffold(
      backgroundColor: white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                LoadDetailsHeader(
                    reset: () {
                      controller.text = "";
                      controllerOthers.text = "";

                      providerData.updatePrice(0);
                      providerData.PerTonTrue(false, false);
                      providerData.resetOnNewType();
                      providerData.updateResetActive(false);
                      providerData.updateBorderColor(darkBlueColor);

                      //reset bidding end date and time
                      providerData.updateBiddingEndDateTime(null, null);
                      //reset comment
                      providerData.updateComment("");
                      //reset publish method
                      providerData.updatePublishMethod('');
                      //reset schedule loading date and time
                      providerData.updateScheduleLoadingDate('');
                      providerData.scheduleLoadingTime = '';
                      //reset tyre
                      providerData.updateTotalTyresValue(0);
                      //reset product type
                      providerData.updateProductType("Choose Product Type");
                      //reset trucks
                      List<String> empList = [];
                      providerData.updateResetActive(true);
                      providerData.updateTruckTypeValue("");
                      providerData.resetOnNewType();
                      providerData.updatePassingWeightMultipleValue(empList);
                      providerData.updateLoadTransporterList(empList);
                    },
                    title: 'Load Details',
                    subTitle: 'Select Load details',
                    previousScreen: (kIsWeb)
                        ? HomeScreenWeb(
                            visibleWidget: PostLoadNav(
                                setChild: postLoadMultipleLocationWidget(
                                    context,
                                    HomeScreenWeb(
                                      selectedIndex: 0,
                                      index: 0,
                                    )),
                                index: 0),
                            index: 1000,
                            selectedIndex: screens.indexOf(postLoadScreen),
                          )
                        : PostLoadNav(
                            setChild: postLoadMultipleLocationWidget(
                                context,
                                HomeScreenWeb(
                                  selectedIndex: 0,
                                  index: 0,
                                )),
                            index: 0)),
                (Responsive.isMobile(context))
                    ? SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(
                              space_4, space_4, space_4, space_4),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AddTruckSubtitleText(text: 'truckType'.tr
                                  // "Truck Type"
                                  ),
                              SizedBox(height: space_2),
                              GridView.count(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                childAspectRatio: 4,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                                padding: EdgeInsets.all(10.0),
                                crossAxisCount: kIsWeb ? 7 : 2,
                                children: truckFilterVariables
                                    .truckTypeValueList
                                    .map((e) =>
                                        AddTruckRectangularButtonTemplate(
                                            value: e,
                                            text: truckFilterVariables
                                                    .truckTypeTextList[
                                                truckFilterVariables
                                                    .truckTypeValueList
                                                    .indexOf(e)]))
                                    .toList(),
                              ),
                              SizedBox(height: space_3),
                              AddTruckSubtitleText(text: 'tyres'.tr
                                  // "Tyres(chakka)"
                                  ),
                              SizedBox(height: space_2),
                              Padding(
                                padding: EdgeInsets.only(
                                  left: space_2,
                                  right: space_2,
                                ),
                                child: Container(
                                  child: GridView.count(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    crossAxisCount: kIsWeb ? 18 : 6,
                                    children: numberOfTyresList
                                        .map((e) => Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child:
                                                  AddTruckCircularButtonTemplate(
                                                value: e,
                                                text:
                                                    e != 0 ? e.toString() : "+",
                                                category: 'tyres',
                                              ),
                                            ))
                                        .toList(),
                                  ),
                                ),
                              ),
                              SizedBox(height: space_2),
                              AddTruckSubtitleText(text: 'productType'.tr
                                  // "Product Type"
                                  ),
                              SizedBox(height: space_2),
                              PostLoadScreenTwoSearch(
                                  hintText: 'chooseproductType'.tr
                                  // "Choose Product Type"
                                  ),
                              SizedBox(height: space_3),
                              AddTruckSubtitleText(text: 'weights'.tr
                                  // "Weight(in tons)"
                                  ),
                              SizedBox(height: space_2),
                              providerData.truckTypeValue == ''
                                  ? SizedBox()
                                  : Container(
                                      child: GridView.count(
                                        physics: NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        crossAxisCount: kIsWeb ? 18 : 6,
                                        children: truckFilterVariables
                                            .passingWeightList[
                                                providerData.truckTypeValue]!
                                            .map((e) => Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child:
                                                      AddTruckCircularButtonTemplate(
                                                    value: e,
                                                    text: e != 0
                                                        ? e.toString()
                                                        : "+",
                                                    category: 'weight',
                                                  ),
                                                ))
                                            .toList(),
                                      ),
                                    ),
                              SizedBox(height: space_3),
                              AddTruckSubtitleText(text: 'priceoptional'.tr
                                  // text: "Freight(Optional)"
                                  ),
                              SizedBox(height: space_2),
                              UnitValueWidget(),
                              SizedBox(height: space_3),
                              PriceTextFieldWidget(),
                              SizedBox(height: space_3),
                              LoadDetailsCommentWidget(),
                              SizedBox(height: space_3),
                              ApplyButton(),
                              SizedBox(height: space_18),
                            ],
                          ),
                        ),
                      )
                    : SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TruckTypeWebWidget(),
                              SizedBox(height: 35),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ProductTypeWebWidget(),
                                  SizedBox(
                                    width: 35,
                                  ),
                                  TyresWebWidget()
                                ],
                              ),
                              SizedBox(height: 35),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  LoadingDateWebWidget(),
                                  SizedBox(
                                    width: 35,
                                  ),
                                  LoadingTimeWebWidget()
                                ],
                              ),
                              SizedBox(height: 35),
                              LoadPublishMethodWebWidget(
                                  refreshParent: refresh),
                              Visibility(
                                visible: (providerData.publishMethod == 'Bid' &&
                                        providerData.biddingEndTime != null &&
                                        providerData
                                            .biddingEndTime!.isNotEmpty &&
                                        providerData.biddingEndDate != null &&
                                        providerData.biddingEndDate!.isNotEmpty)
                                    ? true
                                    : false,
                                child: Column(
                                  children: [
                                    SizedBox(height: 35),
                                    BiddingDateTime(
                                        refreshParent: refresh, width: 0.402),
                                  ],
                                ),
                              ),
                              SizedBox(height: 35),
                              LoadDetailsCommentWidget(),
                              SizedBox(height: 10),
                              moveLoadConfirmationScreenButtonWidget(),
                              SizedBox(height: 40),
                            ],
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
