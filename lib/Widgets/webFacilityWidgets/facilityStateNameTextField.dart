import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:shipper_app/constants/colors.dart';
import 'package:shipper_app/constants/fontSize.dart';
import 'package:shipper_app/controller/facilityController.dart';

class FacilityStateNameTextField extends StatelessWidget {
  TextEditingController stateNameController = TextEditingController();
  FacilityController facilityController = Get.put(FacilityController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      String stateName = facilityController.state.value;
      if (stateName != '') {
        stateNameController.text = stateName.trim();
      } else {
        stateNameController.clear();
      }
      return Container(
          width: MediaQuery.of(context).size.width * 0.2,
          child: TypeAheadField(
            textFieldConfiguration: TextFieldConfiguration(
              controller: stateNameController,
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
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    borderSide: BorderSide(color: black, width: 0.5)),
                suffixIcon: Icon(
                  Icons.arrow_drop_down,
                  color: black,
                ),
              ),
            ),
            itemBuilder: (BuildContext context, itemData) {
              return ListTile(
                title: Text(itemData),
              );
            },
            itemSeparatorBuilder: (context, index) =>
                Divider(height: 0, color: grey, thickness: 0.5),
            noItemsFoundBuilder: (context) => Container(
              height: 80,
              child: Center(child: Text('Not Found')),
            ),
            errorBuilder: (context, error) => Container(
              height: 80,
              child: Center(child: Text('Not Found')),
            ),
            hideOnLoading: true,
            suggestionsCallback: (String searchString) {
              List<String> indianStates = [
                'Andhra Pradesh',
                'Arunachal Pradesh',
                'Assam',
                'Bihar',
                'Chhattisgarh',
                'Goa',
                'Gujarat',
                'Haryana',
                'Himachal Pradesh',
                'Jharkhand',
                'Karnataka',
                'Kerala',
                'Madhya Pradesh',
                'Maharashtra',
                'Manipur',
                'Meghalaya',
                'Mizoram',
                'Nagaland',
                'Odisha',
                'Punjab',
                'Rajasthan',
                'Sikkim',
                'Tamil Nadu',
                'Telangana',
                'Tripura',
                'Uttar Pradesh',
                'Uttarakhand',
                'West Bengal'
              ];

              List<String> matchingStates = [];

              for (String state in indianStates) {
                if (state.toLowerCase().contains(searchString.toLowerCase())) {
                  matchingStates.add(state);
                }
              }

              return matchingStates;
            },
            onSuggestionSelected: (selectedSuggestion) {
              facilityController.updateState(selectedSuggestion.toString());
            },
          ));
    });
  }
}
