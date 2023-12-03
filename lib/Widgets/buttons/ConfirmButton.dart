import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shipper_app/constants/colors.dart';
import 'package:shipper_app/responsive.dart';
import 'package:sizer/sizer.dart';

class ConfirmButton extends StatelessWidget {
  var onPressed;
  final String text;

  ConfirmButton({required this.text, required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 30,bottom: 20,left: Responsive.isMobile(context) ? 15: 25),
      width: MediaQuery.of(context).size.width * (Responsive.isMobile(context) ? 0.83 : 0.33),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          backgroundColor: kLiveasyColor,
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                text,
                style: GoogleFonts.montserrat(
                  color: Colors.white,
                  fontSize: Responsive.isMobile(context) ? 15 :20,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
