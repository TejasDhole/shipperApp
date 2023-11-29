import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:shipper_app/Widgets/facilitiesTableHeader.dart';
import 'package:shipper_app/constants/colors.dart';
import 'package:shipper_app/constants/fontSize.dart';
import 'package:shipper_app/constants/fontWeights.dart';
import 'package:shipper_app/constants/radius.dart';
import 'package:shipper_app/constants/spaces.dart';
import 'package:shipper_app/controller/addLocationDrawerToggleController.dart';
import 'package:shipper_app/controller/facilityController.dart';
import 'package:shipper_app/functions/traccarCalls/deleteGeofences.dart';
import 'package:shipper_app/functions/traccarCalls/fetchAllGeoFences.dart';
import 'package:shipper_app/models/popup_model_for_facility.dart';

class Facilities extends StatefulWidget {
  const Facilities({
    super.key,
  });

  @override
  State<Facilities> createState() => _FacilitiesState();
}

class _FacilitiesState extends State<Facilities> {
  @override
  void initState() {
    super.initState();
  }

  FacilityController facilityController = Get.put(FacilityController());
  AddLocationDrawerToggleController addLocationDrawerToggleController =
      Get.put(AddLocationDrawerToggleController());
  TextEditingController searchTextController = TextEditingController();
  late List<dynamic> geofences;
  Future<List<dynamic>> getGeoFenceData() async {
    geofences = await fetchAllGeoFences();

    return geofences;
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
    double screenWidth = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(30),
          child: Text(
            "Facility",
            style: TextStyle(
              fontSize: size_15 + 2,
              color: darkBlueColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: screenWidth * 0.4,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 5,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: TextField(
                  style: TextStyle(color: black, fontSize: size_8),
                  onChanged: (value) {
                    facilityController.updateFacilityPopUpSearchText(value);
                  },
                  cursorColor: kLiveasyColor,
                  cursorWidth: 1,
                  mouseCursor: SystemMouseCursors.click,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: '    Search by party name, city',
                    hintStyle:
                        TextStyle(color: borderLightColor, fontSize: size_8),
                    prefixIcon: Icon(
                      Icons.search,
                      color: borderLightColor,
                    ),
                  ),
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    facilityController.updatePartyName('');
                    facilityController.updateState('');
                    facilityController.updateCity('');
                    facilityController.updateAddress('');
                    facilityController.updatePinCode('');
                    facilityController.updateFacilityLatLng('', '');
                    facilityController.updateCountry('India');
                    facilityController.updateCreate(true);
                    addLocationDrawerToggleController.toggleDrawer(true);
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                    side: MaterialStateProperty.all(
                        const BorderSide(color: kLiveasyColor, width: 2.0)),
                    minimumSize: MaterialStateProperty.all(
                        Size(screenWidth * 0.175, 50)),
                  ),
                  child: const Text(
                    "+  Add Facility",
                    style: TextStyle(color: kLiveasyColor, fontSize: 18),
                  ))
            ],
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        FacilitiesTableHeader(context),
        FutureBuilder(
          future: fetchAllGeoFences(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Shimmer.fromColors(
                highlightColor: greyishWhiteColor,
                baseColor: lightGrey,
                child: SizedBox(
                  height: 100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 4,
                        child: Center(
                          child: Container(
                            width: double.infinity,
                            height: double.infinity,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const VerticalDivider(color: Colors.grey, thickness: 1),
                      Expanded(
                        flex: 5,
                        child: Center(
                          child: Container(
                            width: double.infinity,
                            height: double.infinity,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const VerticalDivider(color: Colors.grey, thickness: 1),
                      Expanded(
                        flex: 5,
                        child: Center(
                          child: Container(
                            width: double.infinity,
                            height: double.infinity,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const VerticalDivider(color: Colors.grey, thickness: 1),
                      Expanded(
                        flex: 2,
                        child: Center(
                          child: Container(
                            width: double.infinity,
                            height: double.infinity,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                // An error occurred while fetching data
                return Text('Error: ${snapshot.error}');
              } else if (!snapshot.hasData || snapshot.data == null) {
                // Data is not available
                return const Text('No Facility available');
              } else {
                return Obx(() {
                  final List geoFencesData = filterFacility(
                      facilityController.facilityPopUpSearchText.value
                          .toLowerCase(),
                      snapshot.data);
                  if (geoFencesData.isEmpty) {
                    return const Center(
                      child: Text('No result found'),
                    );
                  }
                  return Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 5,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: ListView.builder(
                        shrinkWrap: false,
                        itemCount: geoFencesData.length,
                        itemBuilder: (context, index) {
                          final geofence = geoFencesData[index];
                          final name = geofence['name'] ?? ' ';
                          final address =
                              geofence['attributes']['address'] ?? ' ';
                          final city = geofence['attributes']['city'] ?? ' ';
                          final state = geofence['attributes']['state'] ?? ' ';
                          final String pincode =
                              geofence['attributes']['pinCode'] ?? '';
                          final latlog = geofence['area'] ?? ' ';
                          final String id = geofence['id'].toString();

                          return facilityData(
                              name: name,
                              address: address,
                              city: city,
                              state: state,
                              pincode: pincode,
                              latlog: latlog,
                              id: id.toString());
                        },
                      ),
                    ),
                  );
                });
              }
            } else {
              return Text("Something went wrong");
            }
          },
        )
      ],
    );
  }

  Container facilityData({
    required final String name,
    required final String address,
    required final String city,
    required final String state,
    required final String pincode,
    required final String latlog,
    required final String id,
  }) {
    return Container(
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            flex: 4,
            child: Center(
              child: Text(
                name,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: size_8,
                  fontWeight: mediumBoldWeight,
                ),
              ),
            ),
          ),
          const VerticalDivider(color: greyShade, thickness: 1),
          Expanded(
            flex: 5,
            child: Center(
              child: Text(
                address,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: size_8,
                  fontWeight: mediumBoldWeight,
                ),
              ),
            ),
          ),
          const VerticalDivider(color: greyShade, thickness: 1),
          Expanded(
            flex: 5,
            child: Center(
              child: Text(
                (city == ' ' || state == ' ')
                    ? '$city  $state'
                    : '$city , $state',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: size_8,
                  fontWeight: mediumBoldWeight,
                ),
              ),
            ),
          ),
          const VerticalDivider(color: greyShade, thickness: 1),
          Expanded(
            flex: 2,
            child: Center(
              child: PopupMenuButton<PopUpMenuForFacility>(
                offset: Offset(0, space_2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(radius_2)),
                ),
                onSelected: (item) => onSelect(
                  context,
                  item,
                  name,
                  address,
                  city,
                  state,
                  pincode,
                  latlog,
                  id,
                ),
                itemBuilder: (context) => [
                  ...MenuItemFacility.listItem.map(showEachItem).toList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void onSelect(
      BuildContext context,
      PopUpMenuForFacility item,
      String name,
      String address,
      String city,
      String state,
      String pincode,
      String latlog,
      String id) {
    switch (item) {
      case MenuItemFacility.editText:
        facilityController.updateCreate(false);
        facilityController.updateCountry('India');
        facilityController.updatePartyName(name);
        if (state.contains(', India')) {
          state = state.replaceAll(', India', '');
        }
        facilityController.updateState(state);
        facilityController.updateCity(city);
        facilityController.updateAddress(address);
        facilityController.updatePinCode(pincode);
        facilityController.updateId(id);
        String scr = latlog.substring(8, latlog.length - 1);
        scr = scr.split(",")[0];
        List lot = scr.split(" ");
        facilityController.updateFacilityLatLng(lot[0], lot[1]);
        addLocationDrawerToggleController.toggleDrawer(true);
        break;
      case MenuItemFacility.deleteText:
        deleteGeofences(id).then((bool state) {
          setState(() {});
        });

        break;
    }
  }

  PopupMenuItem<PopUpMenuForFacility> showEachItem(PopUpMenuForFacility item) =>
      PopupMenuItem<PopUpMenuForFacility>(
        value: item,
        child: Row(
          children: [
            Text(
              item.text,
              style: TextStyle(
                fontWeight: normalWeight,
                color: item.color,
              ),
            )
          ],
        ),
      );
}
