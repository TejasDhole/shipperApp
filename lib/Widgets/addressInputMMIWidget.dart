import 'package:flutter/material.dart';
import 'package:popover/popover.dart';
import 'package:shimmer/shimmer.dart';
import 'package:shipper_app/controller/addLocationDrawerToggleController.dart';
import 'package:shipper_app/controller/facilityController.dart';
import 'package:shipper_app/functions/selectedLocationPostLoad.dart';
import 'package:shipper_app/functions/traccarCalls/fetchAllGeoFences.dart';
import 'package:shipper_app/responsive.dart';
import '/constants/borderWidth.dart';
import '/constants/colors.dart';
import '/constants/spaces.dart';
import '/providerClass/providerData.dart';
import '/screens/cityNameInputScreen.dart';
import 'package:get/get.dart';
import '/widgets/cancelIconWidget.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';

// ignore: must_be_immutable
class AddressInputMMIWidget extends StatefulWidget {
  final String page;
  final String hintText;
  final Widget icon;
  final TextEditingController controller;
  var onTap;

  AddressInputMMIWidget(
      {required this.page,
      required this.hintText,
      required this.icon,
      required this.controller,
      required this.onTap});

  @override
  State<AddressInputMMIWidget> createState() => _AddressInputMMIWidgetState();
}

class _AddressInputMMIWidgetState extends State<AddressInputMMIWidget> {
  TextEditingController facilityPopUpSearchController = TextEditingController();
  FacilityController facilityController = Get.put(FacilityController());
  AddLocationDrawerToggleController addLocationDrawerToggleController =
      Get.put(AddLocationDrawerToggleController());

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  List filterFacility(searchedLocation, allLocation) {
    List filteredGeoFence = [];
    if (searchedLocation != '') {
      for (Map geoFence in allLocation) {
        if (geoFence['name']
                .toString()
                .toLowerCase()
                .contains(searchedLocation) ||
            geoFence['attributes']['pinCode']
                .toString()
                .toLowerCase()
                .contains(searchedLocation) ||
            geoFence['attributes']['address']
                .toString()
                .toLowerCase()
                .contains(searchedLocation) ||
            geoFence['attributes']['city']
                .toString()
                .toLowerCase()
                .contains(searchedLocation) ||
            geoFence['attributes']['state']
                .toString()
                .toLowerCase()
                .contains(searchedLocation)) {
          filteredGeoFence.add(geoFence);
        }
      }
    } else {
      filteredGeoFence = allLocation;
    }
    return filteredGeoFence;
  }

  @override
  Widget build(BuildContext context) {
    ProviderData providerData = Provider.of<ProviderData>(context);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(0),
        border: Border.all(color: kLiveasyColor, width: borderWidth_20),
      ),
      padding: EdgeInsets.symmetric(horizontal: space_3),
      child: TextFormField(
        readOnly: true,
        onTap: () async {
          final hasPermission = await _handleLocationPermission();
          if (hasPermission && Responsive.isMobile(context)) {
            providerData.updateResetActive(true);
            FocusScope.of(context).requestFocus(FocusNode());
            Get.to(() => CityNameInputScreen(widget.page, widget.hintText));
          } else {
            // ignore: use_build_context_synchronously
            showPopover(
                context: context,
                arrowWidth: 0,
                arrowHeight: 0,
                arrowDxOffset: -120.80,
                arrowDyOffset: 10,
                height: MediaQuery.of(context).size.height * 0.35,
                transition: PopoverTransition.other,
                barrierColor: transparent,
                radius: 0,
                direction: (widget.hintText.contains("Unloading"))?PopoverDirection.top:PopoverDirection.bottom,
                bodyBuilder: (context) {
                  return Container(
                    padding: const EdgeInsets.all(15),
                    decoration: const BoxDecoration(
                      color: offWhite,
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: 250,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: white),
                          padding: const EdgeInsets.all(5),
                          child: TextButton(
                            child: const Text(
                              '+ Add Facility',
                              style: TextStyle(
                                  fontSize: 15,
                                  fontFamily: "Montserrat",
                                  color: kLiveasyColor,
                                  fontWeight: FontWeight.w600),
                            ),
                            onPressed: () {
                              facilityController.updateCreate(true);
                              Navigator.of(context).pop();
                              addLocationDrawerToggleController
                                  .toggleDrawer(true);
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          width: 250,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: white),
                          child: TextField(
                            controller: facilityPopUpSearchController,
                            onChanged: (value) {
                              facilityController
                                  .updateFacilityPopUpSearchText(value);
                            },
                            style: const TextStyle(
                                fontSize: 13,
                                fontFamily: "Montserrat",
                                color: kLiveasyColor,
                                fontWeight: FontWeight.w400),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.only(
                                  bottom: 0, left: 5, right: 5, top: 15),
                              prefixIcon:
                                  Icon(Icons.search, color: grey, size: 20),
                              hintText: "Search using place name",
                              hintStyle: TextStyle(
                                  fontSize: 13,
                                  fontFamily: "Montserrat",
                                  color: grey,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        FutureBuilder(
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Obx(() {
                                List filteredGeoFence = filterFacility(
                                    facilityController
                                        .facilityPopUpSearchText.value
                                        .toLowerCase(),
                                    snapshot.data);
                                if (filteredGeoFence.isEmpty) {
                                  return Container(
                                    width: 250,
                                    padding: const EdgeInsets.all(15),
                                    child: const Center(
                                      child: Text('No GeoFence Found!!!',
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontFamily: "Montserrat",
                                            color: grey,
                                            fontWeight: FontWeight.w400,
                                          )),
                                    ),
                                  );
                                } else {
                                  return Expanded(
                                    child: SizedBox(
                                        width: 250,
                                        child: ListView.builder(
                                          shrinkWrap: true,
                                          itemBuilder: (context, index) {
                                            Map singleGeoFence =
                                                filteredGeoFence[index];
                                            return InkWell(
                                              onTap: () {
                                                selectedLocationPostLoad(
                                                    context,
                                                    singleGeoFence['attributes']
                                                            ['address']
                                                        .toString()
                                                        .trim(),
                                                    null,
                                                    singleGeoFence['attributes']
                                                            ['city']
                                                        .toString()
                                                        .trim(),
                                                    singleGeoFence['attributes']
                                                            ['state']
                                                        .toString()
                                                        .trim(),
                                                    widget.hintText);
                                                Navigator.pop(context);
                                              },
                                              child: Container(
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 10),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    color: white),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 10,
                                                        horizontal: 10),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    const Icon(
                                                      Icons.home_outlined,
                                                      color: black,
                                                      size: 30,
                                                    ),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          singleGeoFence['name']
                                                              .toString(),
                                                          style: const TextStyle(
                                                              fontSize: 15,
                                                              fontFamily:
                                                                  "Montserrat",
                                                              color:
                                                                  kLiveasyColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                          overflow:
                                                              TextOverflow.fade,
                                                        ),
                                                        const SizedBox(
                                                          height: 5,
                                                        ),
                                                        Text(
                                                          singleGeoFence[
                                                                      'attributes']
                                                                  ['city']
                                                              .toString()
                                                              .trim(),
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 13,
                                                            fontFamily:
                                                                "Montserrat",
                                                            color: grey,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                          ),
                                                          overflow:
                                                              TextOverflow.fade,
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                          itemCount: filteredGeoFence.length,
                                        )),
                                  );
                                }
                              });
                            } else if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Expanded(
                                child: SizedBox(
                                    width: 250,
                                    child: ListView.builder(
                                      scrollDirection: Axis.vertical,
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        return Container(
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 10),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: white),
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 10),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              const Icon(
                                                Icons.home_outlined,
                                                color: black,
                                                size: 30,
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Shimmer.fromColors(
                                                    highlightColor:
                                                        greyishWhiteColor,
                                                    baseColor: lightGrey,
                                                    child: Container(
                                                      height: space_3,
                                                      width: 120,
                                                      color: lightGrey,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Shimmer.fromColors(
                                                    highlightColor:
                                                        greyishWhiteColor,
                                                    baseColor: lightGrey,
                                                    child: Container(
                                                      width: 180,
                                                      height: space_2,
                                                      color: lightGrey,
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        );
                                      },
                                      itemCount: 3,
                                    )),
                              );
                            } else {
                              return Container(
                                padding: const EdgeInsets.all(15),
                                child: const Center(
                                  child: Text('Something went wrong!!!',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontFamily: "Montserrat",
                                        color: grey,
                                        fontWeight: FontWeight.w400,
                                      )),
                                ),
                              );
                            }
                          },
                          future: fetchAllGeoFences(),
                        )
                      ],
                    ),
                  );
                });
          }
        },
        controller: widget.controller,
        decoration: InputDecoration(
          hintText: widget.hintText,
          icon: widget.icon,
          suffixIcon: GestureDetector(
              onTap: widget.onTap,
              child: widget.hintText == "Loading point 2" ||
                      widget.hintText == "Unloading point 2"
                  ? const Icon(Icons.delete_outline)
                  : CancelIconWidget()),
        ),
      ),
    );
  }
}
