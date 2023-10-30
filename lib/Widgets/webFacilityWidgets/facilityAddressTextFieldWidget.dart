import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:shipper_app/constants/colors.dart';
import 'package:shipper_app/constants/fontSize.dart';
import 'package:shipper_app/controller/facilityController.dart';
import 'package:shipper_app/functions/placeAutoFillUtils/autoFillGoogle.dart';

class FacilityAddressTextFieldWidget extends StatelessWidget {
  FacilityController facilityController = Get.put(FacilityController());
  TextEditingController addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(child: Obx(() {
        if (facilityController.address.value.toString() != '') {
          addressController.text = facilityController.address.value.toString();
        } else {
          addressController.clear();
        }
        addressController.moveCursorToEnd();
        return TypeAheadField(
          textFieldConfiguration: TextFieldConfiguration(
            controller: addressController,
            style: TextStyle(
                color: kLiveasyColor,
                fontFamily: 'Montserrat',
                fontSize: size_8),
            textAlign: TextAlign.center,
            decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    borderSide:
                        BorderSide(color: borderLightColor, width: 0.5)),
                hintText: 'Enter Facility Address',
                hintStyle: TextStyle(
                    color: borderLightColor,
                    fontFamily: 'Montserrat',
                    fontSize: size_8),
                suffixIcon: Icon(
                  Icons.arrow_drop_down,
                  color: black,
                ),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    borderSide: BorderSide(color: black, width: 0.5))),
          ),
          itemBuilder: (BuildContext context, itemData) {
            return ListTile(
                title: Text(itemData.placeName),
                subtitle: Text((itemData.addresscomponent1 != null)
                    ? "${itemData.addresscomponent1}, ${itemData.placeCityName}, ${itemData.placeStateName}"
                        .trim()
                    : "${itemData.placeCityName}, ${itemData.placeStateName}"
                        .trim()));
          },
          itemSeparatorBuilder: (context, index) =>
              Divider(height: 0, color: grey, thickness: 0.5),
          noItemsFoundBuilder: (context) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              facilityController.updateAddress(addressController.text);
            });

            return Container(
              height: 80,
              child: Center(
                  child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('No Item Found, Click to '),
                  Text(
                    'Add Custom Address',
                    style: TextStyle(
                        color: kLiveasyColor, fontWeight: FontWeight.w600),
                  )
                ],
              )),
            );
          },
          errorBuilder: (context, error) => Container(
            height: 80,
            child: Center(
                child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('No Item Found, Try Picking From Map Or '),
                Text(
                  'Add Custom Address',
                  style: TextStyle(
                      color: kLiveasyColor, fontWeight: FontWeight.w600),
                )
              ],
            )),
          ),
          hideOnLoading: true,
          suggestionsCallback: (String value) async {
            try {
              Position currentPosition;
              currentPosition = await Geolocator.getCurrentPosition(
                  desiredAccuracy: LocationAccuracy.medium);
              return fillCityGoogle(value, currentPosition);
            } catch (error) {
              return [];
            }
          },
          onSuggestionSelected: (selectedSuggestion) {
            suggestionSelection(selectedSuggestion);
          },
        );
      })),
    );
  }

  suggestionSelection(selectedSuggestion) {
    facilityController.updateAddress(selectedSuggestion.placeName);
    facilityController.updateCity(selectedSuggestion.placeCityName);
    facilityController.updateCountry('India');
    facilityController.updatePlaceId(selectedSuggestion.placeId);
    String stateName = selectedSuggestion.placeStateName.toString();
    if (stateName.contains(', India')) {
      stateName = stateName.replaceAll(', India', '');
    }
    facilityController.updateState(stateName);
  }
}
