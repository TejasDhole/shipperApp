import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shipper_app/Widgets/showSnackBarTop.dart';
import 'package:shipper_app/constants/colors.dart';
import 'package:shipper_app/constants/fontSize.dart';
import 'package:shipper_app/controller/facilityController.dart';
import 'package:shipper_app/responsive.dart';

class ShowMapAddressPicker extends StatefulWidget {
  @override
  State<ShowMapAddressPicker> createState() => _ShowMapAddressPickerState();
}

class _ShowMapAddressPickerState extends State<ShowMapAddressPicker> {
  CustomInfoWindowController customInfoWindowController =
      CustomInfoWindowController();
  FacilityController facilityController = Get.put(FacilityController());
  bool islocationPermission = false;
  late Position currentPosition;
  late LatLng pickedPosition;
  late GoogleMapController googleMapController;
  CameraPosition? currentCameraPosition;
  double mapZoom = 12.0;
  List<Marker> marker = [];
  TextEditingController txtAddress = TextEditingController(),
      txtCity = TextEditingController(),
      txtState = TextEditingController();

  @override
  void initState() {
    if (facilityController.lat.isEmpty || facilityController.long.isEmpty) {
      getCurrentPosition().then((value) {
        currentCameraPosition = CameraPosition(
          target: LatLng(currentPosition.latitude, currentPosition.longitude),
          // Initial camera position
          zoom: mapZoom, // Initial zoom level
        );
      });
    } else {
      currentCameraPosition = CameraPosition(
        target: LatLng(double.parse(facilityController.lat.value),
            double.parse(facilityController.long.value)),
        // Initial camera position
        zoom: mapZoom, // Initial zoom level
      );
      handleOnTapEvent(LatLng(double.parse(facilityController.lat.value),
          double.parse(facilityController.long.value)));
    }

    super.initState();
  }

  Future<void> getCurrentPosition() async {
    await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.medium)
        .then((Position position) {
      setState(() {
        currentPosition = position;
      });
    }).catchError((e) {
      debugPrint(e);
    });
  }

  handleOnTapEvent(LatLng position) {
    marker = [];
    setState(() {
      marker.add(Marker(
          markerId: MarkerId(position.toString()),
          icon: BitmapDescriptor.defaultMarker,
          position: position));
    });
    pickedPosition = position;
    //update text field
    fetchAddress(position).then((address) {
      formatAddress(address);
    });
  }

  formatAddress(String address) {
    List<String> result = address.split(",");
    int resultLength = 0;
    for (var r in result) {
      resultLength++;
      r = r.trimLeft();
      r = r.trimRight();
    }

    if (resultLength == 1) {
      //do nothing
      //Example --> India or Delhi --> These type of addresses are not acceptable
    } else if (resultLength == 2) {
      if (result[resultLength - 1].toString() == " India" ||
          result[resultLength - 1].toString() == " india" ||
          result[resultLength - 1].toString() == " INDIA") {
        //do nothing
        //Example--> West Bengal, India ...
      } else {
        //Example --> Kolkata, WestBengal then placeName : Kolkata, addresscomponent1: "", placeCityName: Kolkata, placeStateName: West Bengal
        txtAddress.text = "${result[0].toString()}";
        txtCity.text = "${result[0].toString()}";
        txtState.text = "${result[1].toString()}";
      }
    } else if (resultLength == 3) {
      if (result[resultLength - 1].toString() == " India" ||
          result[resultLength - 1].toString() == " india" ||
          result[resultLength - 1].toString() == " INDIA") {
        //Example--> kolkata, West Bengal, India ...
        //placeName: kolkata, addresscomponent1:"", placeCityName: kolkata, placeStateName: West Bengal, India

        txtAddress.text = "${result[0].toString()}";
        txtCity.text = "${result[0].toString()}";
        txtState.text = "${result[1].toString()},${result[2].toString()}";
      } else {
        //Example: Jadavpur, Kolkata, West Bengal
        //placeName: Jadavpur, addresscomponent1:"", placeCityName: kolkata, placeStateName: West Bengal
        txtAddress.text = "${result[0].toString()}";
        txtCity.text = "${result[1].toString()}";
        txtState.text = "${result[2].toString()}";
      }
    } else {
      String addressDetail = "";
      if (resultLength > 4) {
        if (result[resultLength - 1].toString() == " India" ||
            result[resultLength - 1].toString() == " india" ||
            result[resultLength - 1].toString() == " INDIA") {
          for (int i = 1; i < resultLength - 3; i++) {
            addressDetail += result[i].toString();
          }

          String fullAddress = "${result[0].toString()}" +
              ((addressDetail == null)
                  ? "${result[resultLength - 1].toString()}"
                  : "$addressDetail");

          txtAddress.text = fullAddress;
          txtCity.text = "${result[resultLength - 3].toString()}";
          txtState.text =
              "${result[resultLength - 2].toString()},${result[resultLength - 1].toString()}";
        } else {
          for (int i = 1; i < resultLength - 2; i++) {
            addressDetail += result[i].toString();
          }

          String fullAddress = "${result[0].toString()}" +
              ((addressDetail == null) ? " " : "$addressDetail");

          txtAddress.text = fullAddress;
          txtCity.text = "${result[resultLength - 2].toString()}";
          txtState.text = "${result[resultLength - 1].toString()}";
        }
      } else {
        if (result[resultLength - 1].toString() == " India" ||
            result[resultLength - 1].toString() == " india" ||
            result[resultLength - 1].toString() == " INDIA") {
          txtAddress.text = "${result[0].toString()}";
          txtCity.text = "${result[resultLength - 3].toString()}";
          txtState.text =
              "${result[resultLength - 2].toString()},${result[resultLength - 1].toString()}";
        } else {
          txtAddress.text = "${result[0].toString()} ${result[1].toString()}";
          txtCity.text = "${result[2].toString()}";
          txtState.text = "${result[3].toString()}";
        }
      }
    }
  }

  fetchAddress(LatLng position) async {
    final url =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=${dotenv.get('mapKey')}';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 'OK' && data['results'].isNotEmpty) {
        final String address = data['results'][0]['formatted_address'];
        return address.toString();
      }
    }
    return 'Address not found';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      width: MediaQuery.of(context).size.width * 0.7,
      height: MediaQuery.of(context).size.height * 0.7,
      child: Row(
        children: [
          (currentCameraPosition != null)
              ? SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: Stack(
                    children: <Widget>[
                      SizedBox(
                        child: GoogleMap(
                          initialCameraPosition: currentCameraPosition!,
                          onTap: (LatLng position) {
                            handleOnTapEvent(position);
                          },
                          onMapCreated: (GoogleMapController controller) {
                            setState(() {
                              googleMapController = controller;
                              customInfoWindowController.googleMapController =
                                  controller;
                            });
                          },
                          onCameraMove: (CameraPosition newPosition) {
                            if (newPosition != null) {
                              // customInfoWindowController.onCameraMove!();
                              currentCameraPosition = newPosition;
                            }
                          },
                          markers: Set.from(marker),
                          mapType: MapType.normal,
                          myLocationButtonEnabled: true,
                          myLocationEnabled: false,
                          zoomGesturesEnabled: true,
                          padding: const EdgeInsets.all(0),
                          buildingsEnabled: true,
                          cameraTargetBounds: CameraTargetBounds.unbounded,
                          compassEnabled: true,
                          indoorViewEnabled: false,
                          mapToolbarEnabled: true,
                          minMaxZoomPreference: MinMaxZoomPreference.unbounded,
                          rotateGesturesEnabled: true,
                          scrollGesturesEnabled: true,
                          tiltGesturesEnabled: true,
                          trafficEnabled: false,
                        ),
                      ),
                      Positioned(
                        bottom: 120,
                        right: 10,
                        child: Container(
                          color: Colors.white,
                          child: IconButton(
                            onPressed: () async {
                              googleMapController.animateCamera(
                                  CameraUpdate.newCameraPosition(CameraPosition(
                                      target: LatLng(currentPosition.latitude,
                                          currentPosition.longitude),
                                      zoom: currentCameraPosition!.zoom)));
                            },
                            icon: const Icon(Icons.my_location),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : Expanded(
                  flex: 3,
                  child: Container(
                    color: Color.fromRGBO(242, 239, 233, 1),
                  )),
          Expanded(
              child: Container(
            padding: EdgeInsets.only(left: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                txtField('Address', txtAddress, false),
                SizedBox(
                  height: 20,
                ),
                txtField('City', txtCity, false),
                SizedBox(
                  height: 20,
                ),
                txtField('State', txtState, false),
                Expanded(child: Container()),
                (Responsive.isDesktop(context))
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [cancelButton(), proceedButton()],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          proceedButton(),
                          SizedBox(
                            height: 20,
                          ),
                          cancelButton()
                        ],
                      )
              ],
            ),
          ))
        ],
      ),
    );
  }

  cancelButton() {
    return TextButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Container(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(width: 0.5, color: kLiveasyColor)),
            child: Text(
              'Close',
              style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: size_7,
                  color: kLiveasyColor),
            )));
  }

  proceedButton() {
    return TextButton(
        onPressed: () async {
          if (marker.isEmpty) {
            showSnackBar('Pick an Address First', deleteButtonColor,
                Icon(Icons.warning), context);
          } else if (!txtState.text.contains(", India")) {
            showSnackBar('Please Select Location inside India Only',
                deleteButtonColor, Icon(Icons.warning), context);
          } else if (txtAddress.text.isEmpty ||
              txtAddress == null ||
              txtCity.text.isEmpty ||
              txtCity == null ||
              txtState.text.isEmpty ||
              txtState == null) {
            showSnackBar('Enter every field', deleteButtonColor,
                Icon(Icons.warning), context);
          } else {
            String stateName = txtState.text.toString();
            facilityController.updateCountry('India');
            if (stateName.contains(', India')) {
              stateName = stateName.replaceAll(', India', '');
            }
            facilityController.updateState(stateName);
            facilityController.updateCity(txtCity.text);
            facilityController.updateAddress(txtAddress.text);
            facilityController.placeId('');
            facilityController.updateFacilityLatLng(
                pickedPosition.latitude.toString(),
                pickedPosition.longitude.toString());
            Navigator.pop(context);
          }
        },
        child: Container(
            padding: EdgeInsets.symmetric(
                horizontal: (Responsive.isTablet(context)) ? 20 : 30,
                vertical: 12),
            decoration: BoxDecoration(
                color: kLiveasyColor,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(width: 0.5, color: kLiveasyColor)),
            child: Text(
              'Proceed',
              style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: (Responsive.isTablet(context)) ? size_6 : size_7,
                  color: white),
            )));
  }

  txtField(String labelTxt, TextEditingController controller, bool status) {
    return TextField(
      controller: controller,
      readOnly: status,
      style: TextStyle(
          color: kLiveasyColor, fontFamily: 'Montserrat', fontSize: size_8),
      textAlign: TextAlign.start,
      decoration: InputDecoration(
          border: OutlineInputBorder(
              borderRadius: BorderRadius.zero,
              borderSide: BorderSide(color: borderLightColor, width: 1.5)),
          label: Text(labelTxt,
              style: TextStyle(
                  color: kLiveasyColor,
                  fontFamily: 'Montserrat',
                  fontSize: size_10,
                  fontWeight: FontWeight.w600),
              selectionColor: kLiveasyColor),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          suffixIcon: Icon(
            Icons.edit,
            color: borderLightColor,
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.zero,
              borderSide: BorderSide(color: truckGreen, width: 1.5))),
    );
  }
}
