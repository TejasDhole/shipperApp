import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
    bool isMobile = Responsive.isMobile(context);

    return Container(
      width: isMobile ? screenWidth * 0.46 : screenWidth * 0.15,
      height: 65,
      child: Padding(
        padding: isMobile ? const EdgeInsets.only(left: 14.0,top: 6.0, bottom: 10.0) : const EdgeInsets.only(right: 8.0, top: 8.0, bottom: 16.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            backgroundColor: const Color(0xFF000066),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text('Send Invite',
                  style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w600, fontSize: size_8)),
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
      ),
    );
  }
}
