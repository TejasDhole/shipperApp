import 'package:flutter/material.dart';
import 'package:shipper_app/constants/colors.dart';
import 'package:shipper_app/constants/fontSize.dart';

class InputTextField extends StatelessWidget {
  final String labelText;
  final bool isEditing;
  final TextEditingController? controller;

  const InputTextField({
    required this.labelText,
    required this.isEditing,
    Key? key,
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
              Text(
                labelText,
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: size_7,
                    color: black,
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 10,
              ),
          TextFormField(
            controller: controller,
            readOnly: !isEditing,
            style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: size_7,
                color: black,
                fontWeight: FontWeight.w600
            ),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  width: 2,
                  color: lightGrey
                ),
                borderRadius: BorderRadius.circular(2.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  width: 2,
                  color: black,
                ),
                borderRadius: BorderRadius.circular(2.0),
              ),
              suffixIcon: isEditing
                  ? IconButton(
                      onPressed: () {},
                      icon: Image.asset('assets/icons/edit.png', width: 15),
                    )
                  : null,
              alignLabelWithHint: true,
            ),
            cursorColor: darkBlueColor
          ),
        ],
      ),
    );
  }
}
