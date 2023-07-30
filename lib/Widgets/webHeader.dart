import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shipper_app/constants/colors.dart';
import 'package:sizer/sizer.dart';

class WebHeader extends StatelessWidget {
  const WebHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.only(top: 6.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image(
                width: MediaQuery.of(context).size.width * 0.02,
                height: MediaQuery.of(context).size.width * 0.02,
                image: const AssetImage("assets/images/logoWebLogin.png")),
            Padding(
              padding: EdgeInsets.only(left: 1.w),
              child: Text("Liveasy",
                  style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w700,
                      color: darkBlueTextColor,
                      fontSize: 28)),
            ),
          ],
        ),
      ),
    );
  }
}
