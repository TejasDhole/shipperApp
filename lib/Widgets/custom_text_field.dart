import 'package:flutter/material.dart';
import 'package:shipper_app/constants/colors.dart';

class CustomTextField extends StatefulWidget {
  final String labelText;
  final String? hintText;
  
  final TextEditingController? controller;
  final VoidCallback? onPressed;

  final String? Function(String?)? validator;

  const CustomTextField({
    Key? key,
    required this.labelText,
    this.hintText,
    this.controller,
    this.onPressed,
    this.validator,
  }) : super(key: key);

  @override
  CustomTextFieldState createState() => CustomTextFieldState();
}

class CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        labelText: widget.labelText,
        hintText: widget.hintText,
        labelStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: darkBlueColor,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: darkBlueColor,
          ),
          borderRadius: BorderRadius.circular(1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: darkBlueColor,
          ),
          borderRadius: BorderRadius.circular(1.0),
        ),
      ),
      cursorColor: kLiveasyColor,
      textAlign: TextAlign.center,
      validator: widget.validator,
    );
  }
}
