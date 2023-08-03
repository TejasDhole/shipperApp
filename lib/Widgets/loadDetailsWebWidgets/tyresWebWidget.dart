
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:shipper_app/providerClass/providerData.dart';
import '../../constants/colors.dart';
import '../../constants/fontSize.dart';

class TyresWebWidget extends StatefulWidget {
  @override
  State<TyresWebWidget> createState() => _TyresWebWidgetState();
}

class _TyresWebWidgetState extends State<TyresWebWidget> {
  List<String> numberOfTyresList = [
    '6',
    '10',
    '12',
    '14',
    '16',
    '18',
    '22',
    '26',
  ];
  String selectedTyreNo = '';
  dynamic providerFunction = () {};

  @override
  Widget build(BuildContext context) {
    ProviderData providerData = Provider.of<ProviderData>(context);
    selectedTyreNo = providerData.totalTyresValue.toString();
    providerFunction = providerData.updateTotalTyresValue;
    return Expanded(
      child: Container(
          child: DropdownSearch(

            selectedItem: (selectedTyreNo!='' && selectedTyreNo != '0')? selectedTyreNo : null,

            dropdownButtonProps: DropdownButtonProps(
              icon: Icon(Icons.expand_more_outlined),
              selectedIcon: Icon(Icons.expand_less_outlined),
            ),
            onChanged: (value) {
              selectedTyreNo = value.toString();
              providerData.updateResetActive(true);
              print(value);
              providerFunction(int.parse(value.toString()));
            },
            items: numberOfTyresList,
            dropdownDecoratorProps: DropDownDecoratorProps(
              textAlign: TextAlign.center,
              baseStyle: TextStyle(
                  color: kLiveasyColor, fontFamily: 'Montserrat', fontSize: size_8),
              dropdownSearchDecoration: InputDecoration(
                border: OutlineInputBorder(
                borderRadius: BorderRadius.zero,
                borderSide: BorderSide(color: borderLightColor, width: 1.5)),
                  hintText: 'Choose no of  Tyres',
                  hintStyle: TextStyle(
                      color: borderLightColor,
                      fontFamily: 'Montserrat',
                      fontSize: size_8),
                  label: Text('Tyres',
                      style: TextStyle(
                          color: kLiveasyColor,
                          fontFamily: 'Montserrat',
                          fontSize: size_10,
                          fontWeight: FontWeight.w600),
                      selectionColor: kLiveasyColor),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  suffixIcon: Icon(
                    Icons.arrow_forward,
                    color: borderLightColor,
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.zero,
                      borderSide: BorderSide(color: truckGreen, width: 1.5))
                ),

          ),
            popupProps: PopupProps.menu(
              constraints: BoxConstraints.expand(width: double.maxFinite,height: 70),
              scrollbarProps: ScrollbarProps(
                thumbColor: truckGreen,
              ),

              listViewProps: ListViewProps(scrollDirection: Axis.horizontal,itemExtent: 65,padding: EdgeInsets.all(5),),

              itemBuilder: (context, item, isSelected) =>Container(
                margin: EdgeInsets.only(left: 10, right: 10),
                decoration: BoxDecoration(
                  color: (selectedTyreNo == item)
                      ? truckGreen
                      : Colors.white,
                  border: Border(
                      bottom: BorderSide(color: truckGreen, width: 1),
                      left: BorderSide(color: truckGreen, width: 1),
                      top: BorderSide(color: truckGreen, width: 1),
                      right: BorderSide(color: truckGreen, width: 1)),
                  borderRadius: BorderRadius.all(Radius.circular(2)),
                ),
                padding: EdgeInsets.only(
                    left: 10, right: 10, top: 15, bottom: 15),
                child: Center(
                  child: Text(
                    item.toString(),
                    style: TextStyle(
                        color: (selectedTyreNo == item)
                            ? Colors.white
                            : kLiveasyColor,
                        fontFamily: 'Montserrat',
                        fontSize: size_8),
                  ),
                ),
              ),
            ),

          ),
    ));
  }
}
