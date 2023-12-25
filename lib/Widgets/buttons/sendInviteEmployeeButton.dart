import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shipper_app/constants/colors.dart';
import 'package:shipper_app/constants/fontSize.dart';
import 'package:shipper_app/responsive.dart';
import 'package:shipper_app/screens/add_user_screen.dart';

class SendInviteButton extends StatefulWidget {
  const SendInviteButton({Key? key}) : super(key: key);

  @override
  State<SendInviteButton> createState() => _SendInviteButtonState();
}

class _SendInviteButtonState extends State<SendInviteButton> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    bool isMobile = Responsive.isMobile(context);

    return Container(
      width: isMobile ? screenWidth * 0.46 : screenWidth * 0.15,
      height: 45,
      margin: isMobile
          ? const EdgeInsets.only(left: 14.0, top: 6.0, bottom: 10.0)
          : EdgeInsets.only(right: screenWidth * 0.03, top: screenHeight * 0.01, bottom: screenHeight * 0.06),
      decoration: BoxDecoration(
        border: Border.all(color: darkBlueTextColor),
        borderRadius: BorderRadius.circular(5),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          surfaceTintColor: Colors.transparent,
          backgroundColor: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text('Send Invite',
                style: GoogleFonts.montserrat(
                    color: const Color(0xFF000066),
                    fontWeight: FontWeight.w600,
                    fontSize: screenWidth * 0.0125)),
            const Image(image: AssetImage('assets/icons/telegramicon.png')),
          ],
        ),
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return const AddUser();
              });
        },
      ),
    );
  }
}
