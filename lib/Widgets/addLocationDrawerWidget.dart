import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:shipper_app/Widgets/showSnackBarTop.dart';
import 'package:shipper_app/Widgets/webFacilityWidgets/facilityAddressTextFieldWidget.dart';
import 'package:shipper_app/Widgets/webFacilityWidgets/facilityPinCodeTextFieldWidget.dart';
import 'package:shipper_app/Widgets/webFacilityWidgets/facilityStateNameTextField.dart';
import 'package:shipper_app/controller/addLocationDrawerToggleController.dart';
import 'package:shipper_app/controller/facilityController.dart';
import 'package:shipper_app/functions/traccarCalls/createGeoFence.dart';
import '/constants/colors.dart';
import '/constants/fontSize.dart';
import '/constants/spaces.dart';

class AddLocationDrawerWidget extends StatefulWidget {
  final context;

  AddLocationDrawerWidget({required this.context});

  @override
  State<AddLocationDrawerWidget> createState() =>
      _AddLocationDrawerWidgetState();
}

class _AddLocationDrawerWidgetState extends State<AddLocationDrawerWidget> {
  FacilityController facilityController = Get.put(FacilityController());
  AddLocationDrawerToggleController addLocationDrawerToggleController =
      Get.put(AddLocationDrawerToggleController());

  TextEditingController cityNameController = TextEditingController();
  TextEditingController countryNameController = TextEditingController();
  TextEditingController partyNameController = TextEditingController();

  final padding = EdgeInsets.only(left: space_1, right: space_7);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.7,
      child: Scaffold(
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Add New Facility',
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: size_10,
                          color: black,
                          fontWeight: FontWeight.w600),
                    ),
                    IconButton(
                        onPressed: () {
                          addLocationDrawerToggleController.toggleDrawer(false);
                        },
                        icon: FaIcon(
                          FontAwesomeIcons.xmark,
                          color: black,
                          size: 25,
                        ))
                  ],
                ),
              ),
              Divider(
                color: grey,
                thickness: 0.5,
                height: 0,
              ),
              Container(
                padding: EdgeInsets.only(top: 50, left: 20, right: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Facility Address',
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: size_9,
                              color: black,
                              fontWeight: FontWeight.w600),
                        ),
                        Text(
                          ' *',
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: size_8,
                              color: declineButtonRed,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        FacilityAddressTextFieldWidget(),
                        SizedBox(
                          width: 30,
                        ),
                        TextButton(
                            onPressed: () {},
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 15),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                      width: 0.5, color: kLiveasyColor)),
                              child: Row(
                                children: [
                                  Image.asset('assets/images/spoon.png',
                                      height: 20, width: 8, fit: BoxFit.fill),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    'Pick From Map',
                                    style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize: size_9,
                                        color: kLiveasyColor),
                                  )
                                ],
                              ),
                            ))
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'PinCode',
                              style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: size_9,
                                  color: black,
                                  fontWeight: FontWeight.w600),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            FacilityPinCodeTextFieldWidget()
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'City',
                              style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: size_9,
                                  color: black,
                                  fontWeight: FontWeight.w600),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Obx(() {
                              String cityName = facilityController.city.value;
                              if (cityName != '') {
                                cityNameController.text = cityName.trim();
                              } else {
                                cityNameController.clear();
                              }
                              return Container(
                                width: MediaQuery.of(context).size.width * 0.2,
                                child: TextField(
                                  controller: cityNameController,
                                  style: TextStyle(
                                      color: kLiveasyColor,
                                      fontFamily: 'Montserrat',
                                      fontSize: size_8),
                                  textAlign: TextAlign.center,
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5)),
                                          borderSide: BorderSide(
                                              color: borderLightColor,
                                              width: 0.5)),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5)),
                                          borderSide: BorderSide(
                                              color: black, width: 0.5))),
                                ),
                              );
                            })
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'State',
                              style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: size_9,
                                  color: black,
                                  fontWeight: FontWeight.w600),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            FacilityStateNameTextField()
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Country',
                              style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: size_9,
                                  color: black,
                                  fontWeight: FontWeight.w600),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.1,
                              child: Obx(() {
                                if (facilityController.country.value != '') {
                                  countryNameController.text =
                                      facilityController.country.value;
                                } else {
                                  countryNameController.clear();
                                }
                                return TextField(
                                  controller: countryNameController,
                                  readOnly: true,
                                  style: TextStyle(
                                      color: kLiveasyColor,
                                      fontFamily: 'Montserrat',
                                      fontSize: size_8),
                                  textAlign: TextAlign.center,
                                  showCursor: false,
                                  mouseCursor: SystemMouseCursors.click,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5)),
                                        borderSide: BorderSide(
                                            color: borderLightColor,
                                            width: 0.5)),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5)),
                                        borderSide: BorderSide(
                                            color: black, width: 0.5)),
                                    suffixIcon: Icon(
                                      Icons.arrow_drop_down,
                                      color: black,
                                    ),
                                  ),
                                );
                              }),
                            )
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      'Party Name',
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: size_9,
                          color: black,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: Obx(() {
                          if (facilityController.partyName.value != '') {
                            partyNameController.text =
                                facilityController.partyName.value;
                          } else {
                            partyNameController.clear();
                          }
                          partyNameController.moveCursorToEnd();
                          return TextField(
                            controller: partyNameController,
                            onChanged: (value) {
                              facilityController
                                  .updatePartyName(partyNameController.text);
                            },
                            style: TextStyle(
                                color: kLiveasyColor,
                                fontFamily: 'Montserrat',
                                fontSize: size_8),
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)),
                                    borderSide: BorderSide(
                                        color: borderLightColor, width: 0.5)),
                                hintText: 'Enter Party Name',
                                hintStyle: TextStyle(
                                    color: borderLightColor,
                                    fontFamily: 'Montserrat',
                                    fontSize: size_8),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)),
                                    borderSide:
                                        BorderSide(color: black, width: 0.5))),
                          );
                        })),
                    SizedBox(
                      height: 60,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                            onPressed: () {
                              Navigator.pop(widget.context);
                            },
                            child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 40, vertical: 12),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                        width: 0.5, color: kLiveasyColor)),
                                child: Text(
                                  'Close',
                                  style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontSize: size_9,
                                      color: kLiveasyColor),
                                ))),
                        SizedBox(
                          width: 30,
                        ),
                        TextButton(
                            onPressed: () async {
                              if (facilityController.address == '') {
                                showSnackBar(
                                    'Enter Address !!!',
                                    deleteButtonColor,
                                    Icon(Icons.warning),
                                    context);
                              } else if (facilityController.city == '') {
                                showSnackBar(
                                    'Enter city !!!',
                                    deleteButtonColor,
                                    Icon(Icons.warning),
                                    context);
                              } else if (facilityController.state == '') {
                                showSnackBar(
                                    'Enter State !!!',
                                    deleteButtonColor,
                                    Icon(Icons.warning),
                                    context);
                              } else if (facilityController.partyName == '') {
                                showSnackBar(
                                    'Enter Party Name !!!',
                                    deleteButtonColor,
                                    Icon(Icons.warning),
                                    context);
                              } else if (facilityController.pinCode.value ==
                                      '' ||
                                  facilityController.pinCode
                                          .toString()
                                          .length !=
                                      6) {
                                showSnackBar(
                                    'Enter a valid PinCode !!!',
                                    deleteButtonColor,
                                    Icon(Icons.warning),
                                    context);
                              } else {
                                try {
                                  bool status = await createFacility();
                                  if (status) {
                                    showSnackBar(
                                        'Facility Created Successfully!!!',
                                        truckGreen,
                                        Icon(Icons
                                            .check_circle_outline_outlined),
                                        context);
                                    facilityController.updatePartyName('');
                                    facilityController.updateCountry('');
                                    facilityController.updateState('');
                                    facilityController.updateCity('');
                                    facilityController.updateAddress('');
                                    facilityController.updatePinCode('');
                                  } else {
                                    showSnackBar(
                                        'Something went Wrong, Try again Later!!!',
                                        deleteButtonColor,
                                        Icon(Icons.warning),
                                        context);
                                  }
                                } catch (error) {
                                  showSnackBar(
                                      error.toString(),
                                      deleteButtonColor,
                                      Icon(Icons.report_gmailerrorred_sharp),
                                      context);
                                }
                              }
                            },
                            child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 40, vertical: 12),
                                decoration: BoxDecoration(
                                    color: kLiveasyColor,
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                        width: 0.5, color: kLiveasyColor)),
                                child: Text(
                                  'Create Facility',
                                  style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontSize: size_9,
                                      color: white),
                                )))
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
