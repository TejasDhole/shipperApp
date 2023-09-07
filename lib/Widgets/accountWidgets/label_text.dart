import 'package:flutter/material.dart';

class LabelTextWidget extends StatelessWidget {
  final String labelText;
  final bool isEditing;
  final VoidCallback? onPressed;
  final TextEditingController controller;

  const LabelTextWidget({
    required this.labelText,
    required this.isEditing,
    this.onPressed,
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      readOnly: !isEditing,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(-2, 0, 0, 0),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        labelText: labelText,
        labelStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color(0xFF152968),
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
                onPressed: onPressed,
                icon: Image.asset('assets/icons/edit.png', width: 15),
              )
            : null,
        // Center the text within the TextFormField
        // Use textAlign property
        alignLabelWithHint: true,
      ),
      cursorColor: const Color(0xFF152968),
      // Center the text within the TextFormField
      textAlign: TextAlign.center,
    );
  }
}
