import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shipper_app/constants/colors.dart';
import 'package:shipper_app/controller/myLoadFilterController.dart';

Widget ClearALLWidget(){
  MyLoadsFilterController myLoadsFilterController = Get.put(MyLoadsFilterController());
  return InkWell(
    onTap: () {
      myLoadsFilterController.clearAll();
    },
    child: Container(
      margin: const EdgeInsets.only(left: 10, right: 10),
      child: DottedBorder(
        borderType: BorderType.RRect,
        radius: const Radius.circular(10),
        strokeWidth: 2,
        color: deleteButtonColor,
        dashPattern: const [5,5],
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
          decoration: const BoxDecoration(
            color: white,
          ),
          child: const Text(
            'Clear All', style: TextStyle(color: deleteButtonColor, fontSize: 15, fontFamily: 'Montserrat'), textAlign: TextAlign.center,
          ),
        ),
      ),
    ),
  );
}