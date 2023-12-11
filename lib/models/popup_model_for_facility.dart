import 'package:flutter/material.dart';
import 'package:shipper_app/constants/colors.dart';

class PopUpMenuForFacility {
  final String text;
  final Color color;
  const PopUpMenuForFacility({
    required this.text,
    required this.color,
  });
}

class MenuItemFacility {
  static const editText =
      PopUpMenuForFacility(text: "Edit Facility", color: Colors.black);
  static const deleteText =
      PopUpMenuForFacility(text: "Delete Facility", color: declineButtonRed);
  static List<PopUpMenuForFacility> listItem = [editText, deleteText];
}
