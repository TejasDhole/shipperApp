import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shipper_app/constants/colors.dart';
import 'package:sizer/sizer.dart';

class ConfirmButton extends StatelessWidget {
  var onPressed;
  final String text;

  ConfirmButton({required this.text, required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        backgroundColor: kLiveasyColor,
        fixedSize: Size(33.w, 7.h),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: GoogleFonts.montserrat(
          color: Colors.white,
          fontSize: 4.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
