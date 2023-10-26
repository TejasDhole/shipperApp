import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shipper_app/Web/screens/home_web.dart';
import 'package:shipper_app/Widgets/PublishMethodBidSearchTextFieldWidget.dart';
import 'package:shipper_app/Widgets/addTransporterWidget.dart';
import 'package:shipper_app/Widgets/loadDetailsWebWidgets/BiddingDateTime.dart';
import 'package:shipper_app/Widgets/postLoadLocationWidgets/PostLoadMultipleLocationWidget.dart';
import 'package:shipper_app/constants/colors.dart';
import 'package:shipper_app/constants/fontSize.dart';
import 'package:shipper_app/constants/fontWeights.dart';
import 'package:shipper_app/constants/screens.dart';
import 'package:shipper_app/controller/addLocationDrawerToggleController.dart';
import 'package:shipper_app/functions/shipperApis/TransporterListFromShipperApi.dart';
import 'package:shipper_app/providerClass/providerData.dart';
import 'package:shipper_app/responsive.dart';
import 'package:shipper_app/screens/PostLoadScreens/PostLoadScreenLoadDetails.dart';

import 'package:shipper_app/constants/spaces.dart';
import 'package:shipper_app/screens/PostLoadScreens/postloadnavigation.dart';

class PublishMethodBidWebScreen extends StatefulWidget {
  final publishMethod;

  const PublishMethodBidWebScreen({super.key, required this.publishMethod});

  @override
  State<PublishMethodBidWebScreen> createState() =>
      _PublishMethodBidWebScreenState();
}

class _PublishMethodBidWebScreenState extends State<PublishMethodBidWebScreen> {
  var transporterList = [];
  var selectedTransporterList = [];
  String controllerTxt = '';
  bool setSelectedTransporterList = true;
  bool enableFinishButton = false;
  AddLocationDrawerToggleController addLocationDrawerToggleController =
      Get.put(AddLocationDrawerToggleController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTransporterListFromShipperApi('');
  }

  refresh(bool allowToRefresh) {
    if (allowToRefresh) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        setState(() {});
      });
    }
  }

  getTransporterListFromShipperApi(String txt) async {
    await TransporterListFromShipperApi()
        .getTransporterListFromShipperApi(txt)
        .then((value) {
      if (mounted) {
        setState(() {
          transporterList = [...value];
          setSelectedTransporterList = true;
        });
      }
    });
  }

  bool areListsEqual(var list1, var list2) {
    // check if both are lists
    if (!(list1 is List && list2 is List)
        // check if both have same length
        ||
        list1.length != list2.length) {
      return false;
    }

    // check if elements are equal
    for (int i = 0; i < list1.length; i++) {
      if (list1[i] != list2[i]) {
        return false;
      }
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    ProviderData providerData = Provider.of<ProviderData>(context);
    if (setSelectedTransporterList && transporterList.isNotEmpty) {
      selectedTransporterList.clear();
      for (int i = 0; i < providerData.loadTransporterList.length; i++) {
        for (int j = 0; j < transporterList.length; j++) {
          if (areListsEqual(
              providerData.loadTransporterList[i], transporterList[j])) {
            selectedTransporterList.add(transporterList[j]);
          }
        }
      }
      setSelectedTransporterList = false;
    }

    if (widget.publishMethod == 'Bid') {
      if (selectedTransporterList.isNotEmpty &&
          providerData.biddingEndTime != null &&
          providerData.biddingEndDate != null &&
          providerData.biddingEndDate != '' &&
          providerData.biddingEndTime != '') {
        enableFinishButton = true;
      } else {
        enableFinishButton = false;
      }
    } else {
      if (selectedTransporterList.isNotEmpty) {
        enableFinishButton = true;
      } else {
        enableFinishButton = false;
      }
    }

    return Scaffold(
      floatingActionButton: SizedBox(
        height: space_8,
        width: space_33,
        child: TextButton(
          style: ButtonStyle(
            mouseCursor: MaterialStatePropertyAll((enableFinishButton)
                ? SystemMouseCursors.click
                : SystemMouseCursors.basic),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
              borderRadius: (Responsive.isMobile(context))
                  ? BorderRadius.circular(50)
                  : BorderRadius.all(Radius.zero),
            )),
            backgroundColor: MaterialStateProperty.all<Color>(
                (enableFinishButton) ? truckGreen : disableButtonColor),
          ),
          onPressed: () {
            if (enableFinishButton) {
              providerData.updateLoadTransporterList(selectedTransporterList);
              providerData.updatePublishMethod(widget.publishMethod);
              ((kIsWeb)
                  ? Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => HomeScreenWeb(
                                index: screens.indexOf(postLoadScreenTwo),
                                selectedIndex: screens.indexOf(postLoadScreen),
                              )))
                  : Get.to(() => PostLoadScreenTwo()));
            }
          },
          child: Text(
            'Finish', // AppLocalizations.of(context)!.postLoad,
            style: TextStyle(
                fontWeight: mediumBoldWeight,
                color: white,
                fontSize: size_8,
                fontFamily: 'Montserrat'),
          ),
        ),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterFloat,
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            (widget.publishMethod == 'Bid')
                ? Row(children: [
                    Expanded(
                      child: BiddingDateTime(
                        refreshParent: refresh,
                        width: 0.32,
                      ),
                    ),
                  ])
                : Container(),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                PublishBidSearchTextFieldWidget(),
                SizedBox(
                  width: 40,
                ),
                Expanded(
                  flex: 2,
                  child: TextButton(
                    onPressed: () {
                      addLocationDrawerToggleController
                          .toggleAddTransporter(true);
                    },
                    child: Container(
                      height: 50,
                      child: Center(
                        child: Text('Add Transporter',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                fontFamily: 'Montserrat',
                                fontSize: size_8,
                                letterSpacing: 2)),
                      ),
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(truckGreen),
                      mouseCursor: MaterialStatePropertyAll<MouseCursor>(
                          SystemMouseCursors.click),
                      padding: MaterialStatePropertyAll<EdgeInsets>(
                          EdgeInsets.only(
                              left: 20, right: 20, top: 10, bottom: 10)),
                      shape: MaterialStatePropertyAll<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              side: BorderSide(
                                color: truckGreen,
                                width: 2,
                              ))),
                      textStyle: MaterialStatePropertyAll<TextStyle>(TextStyle(
                          color: truckGreen,
                          fontFamily: 'Montserrat',
                          fontSize: size_6)),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 40,
            ),
            Expanded(
              child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.height * 0.8,
                  child: Obx(() {
                    if (addLocationDrawerToggleController
                            .searchTransporterText.value !=
                        controllerTxt) {
                      controllerTxt = addLocationDrawerToggleController
                          .searchTransporterText.value;
                      getTransporterListFromShipperApi(controllerTxt);
                    }
                    return (addLocationDrawerToggleController
                            .addTransporter.value)
                        ? addTransporter(context, transporterList)
                        : Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Transporters',
                                style: TextStyle(
                                    color: truckGreen,
                                    fontFamily: 'Montserrat',
                                    fontSize: size_10),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.all(15),
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      border: Border.all(
                                          color: borderLightColor, width: 1)),
                                  child: (transporterList.length == 0)
                                      ? Center(
                                          child: Text(
                                            'No Transporter Found!!',
                                            style: TextStyle(
                                                color: black,
                                                fontFamily: 'Montserrat',
                                                fontSize: size_10),
                                          ),
                                        )
                                      : GridView.builder(
                                          shrinkWrap: true,
                                          scrollDirection: Axis.vertical,
                                          padding: const EdgeInsets.all(10),
                                          gridDelegate:
                                              const SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: 2,
                                                  crossAxisSpacing: 20,
                                                  mainAxisSpacing: 0,
                                                  mainAxisExtent: 50),
                                          itemBuilder: (context, index) {
                                            return (transporterList.isEmpty)
                                                ? Container()
                                                : CheckboxListTile(
                                                    contentPadding:
                                                        EdgeInsets.only(
                                                            left: 40,
                                                            right: 20),
                                                    value:
                                                        selectedTransporterList
                                                            .contains(
                                                                transporterList[
                                                                    index]),
                                                    onChanged: (value) {
                                                      setState(() {
                                                        if (value!) {
                                                          if (widget
                                                                  .publishMethod !=
                                                              'Bid') {
                                                            selectedTransporterList
                                                                .clear();
                                                          }
                                                          selectedTransporterList
                                                              .add(
                                                                  transporterList[
                                                                      index]);
                                                        } else {
                                                          selectedTransporterList
                                                              .remove(
                                                                  transporterList[
                                                                      index]);
                                                        }
                                                      });
                                                    },
                                                    side: BorderSide(
                                                        width: 2,
                                                        color: truckGreen),
                                                    mouseCursor:
                                                        SystemMouseCursors
                                                            .click,
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    2))),
                                                    activeColor: truckGreen,
                                                    title: Text(
                                                      transporterList[index][1],
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontFamily:
                                                              'Montserrat',
                                                          fontSize: size_10),
                                                    ),
                                                    controlAffinity:
                                                        ListTileControlAffinity
                                                            .leading,
                                                  );
                                          },
                                          itemCount: transporterList.length,
                                        ),
                                ),
                              ),
                            ],
                          );
                  })),
            )
          ],
        ),
      ),
    );
  }
}
