import 'package:flutter/material.dart';
import 'package:shipper_app/constants/colors.dart';

class InputTextField extends StatelessWidget {
  final String labelText;
  final bool isEditing;
  final TextEditingController controller;

  const InputTextField({
    required this.labelText,
    required this.isEditing,
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      child: TextFormField(
        controller: controller,
        readOnly: !isEditing,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelText: labelText,
          labelStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: darkBlueColor,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.black12,
            ),
            borderRadius: BorderRadius.circular(1.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.black87,
            ),
            borderRadius: BorderRadius.circular(1.0),
          ),
          suffixIcon: isEditing
              ? IconButton(
                  onPressed: () {},
                  icon: Image.asset('assets/icons/edit.png', width: 15),
                )
              : null,
          alignLabelWithHint: true,
        ),
        cursorColor: darkBlueColor,
        textAlign: TextAlign.center,
      ),
    );
  }
}
