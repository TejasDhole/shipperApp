import 'package:flutter/material.dart';
import 'package:shipper_app/constants/colors.dart';

class PopUpMenuForTransporter {
  final String text;
  final Color color;
  final IconData icon;

  const PopUpMenuForTransporter({
    required this.text,
    required this.color,
    required this.icon,
  });
}

class MenuItemTransporter {
  static const editText = PopUpMenuForTransporter(
    text: "Edit ",
    color: darkBlueColor,
    icon: Icons.edit_outlined,
  );
  static const deleteText = PopUpMenuForTransporter(
    text: "Delete ",
    color: darkBlueColor,
    icon: Icons.delete_outline,
  );
  static List<PopUpMenuForTransporter> listItem = [editText, deleteText];
}
