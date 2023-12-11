import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:popover/popover.dart';
import 'package:shipper_app/Widgets/filterWidgets/DateTextFieldWidget.dart';
import 'package:shipper_app/constants/colors.dart';
import 'package:shipper_app/controller/myLoadFilterController.dart';

class MyLoadsFilterWidget extends StatefulWidget{
  const MyLoadsFilterWidget({super.key});

  @override
  State<MyLoadsFilterWidget> createState() => _MyLoadsFilterWidgetState();
}

class _MyLoadsFilterWidgetState extends State<MyLoadsFilterWidget> {

  MyLoadsFilterController myLoadsFilterController = Get.put(MyLoadsFilterController());
  TextEditingController startDate = TextEditingController();
  TextEditingController endDate = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return InkWell(
      onTap: () {
        showPopover(
            context: context,
            arrowWidth: 15,
            arrowHeight: 15,
            arrowDyOffset: 10,
            height: MediaQuery.of(context).size.height * 0.28,
            transition: PopoverTransition.other,
            barrierColor: transparent,
            radius: 0,
            direction: PopoverDirection.bottom,
            bodyBuilder: (context) {
              return Container(
                width: MediaQuery.of(context).size.width*0.5,
                padding: const EdgeInsets.symmetric(vertical: 15),
                decoration: const BoxDecoration(
                  color: white,
                  boxShadow: [
                     BoxShadow(
                      color: lightGrey,
                      blurRadius: 5,
                       offset: Offset(0, 5)
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text('Select Start and End Dates', textAlign: TextAlign.center, style: TextStyle(color: kLiveasyColor,fontSize: 15, fontFamily: "Montserrat"),),
                    const Divider(color: lightGrey, thickness: 1),
                    const SizedBox(height: 10,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          DateTextFieldWidget(controller : startDate, labelText: "Start Date"),
                          DateTextFieldWidget(controller : endDate, labelText: "End Date"),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20,),
                    InkWell(
                      onTap: () {
                        if(startDate.text !='' && endDate.text !=''){
                          myLoadsFilterController.updateDate(DateFormat.yMMMMd('en_US')
                              .parse(startDate.text).toString(), DateFormat.yMMMMd('en_US')
                              .parse(endDate.text).toString());
                          myLoadsFilterController.updateToggleDate(true);
                          myLoadsFilterController.updateRefreshBuilder(true);
                          Get.back();
                        }
                        else{
                          myLoadsFilterController.updateToggleDate(false);
                        }
                      },
                      child: Container(
                        width : 100,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: truckGreen,
                          borderRadius: BorderRadius.circular(10)
                        ),
                        child: const Text('Apply', textAlign: TextAlign.center, style: TextStyle(fontSize: 15, color: white, fontFamily: "Montserrat"),),
                      ),
                    ),
                    const SizedBox(height: 20,),
                  ],
                ),
              );
            });
      },
      child: Container(
        margin: const EdgeInsets.only(left: 10, right: 5),
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
        decoration: BoxDecoration(
            color: myLoadsFilterController.toggleDate.value ? kLiveasyColor : white,
            border: Border.all(color: kLiveasyColor,width: 2),
            borderRadius: BorderRadius.circular(5)
        ),
        child: Text(
          'Date', style: TextStyle(color: myLoadsFilterController.toggleDate.value ? white : kLiveasyColor, fontSize: 15, fontFamily: 'Montserrat'), textAlign: TextAlign.center,
        ),
      ),
    );
    },);
  }
}