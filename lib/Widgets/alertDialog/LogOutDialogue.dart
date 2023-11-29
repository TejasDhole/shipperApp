import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import '/constants/colors.dart';
import '/constants/fontSize.dart';
import '/constants/fontWeights.dart';
import '/constants/spaces.dart';
import '/widgets/buttons/CancelLogoutButton.dart';
import '/widgets/buttons/LogoutOkButton.dart';

class LogoutDialogue extends StatelessWidget {
  const LogoutDialogue({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return AlertDialog(
      surfaceTintColor: transparent,
        backgroundColor: white,
        shadowColor: gradientGreyColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        elevation: 50,
        titlePadding: EdgeInsets.only(top: space_17),
        title: Center(
          child: Text('Are you sure you want to \n Signout ?'.tr,
              // "Are you sure you want to signout" ,
              style: TextStyle(
                  color: bidBackground,
                  fontSize: size_9,
                  fontWeight: mediumBoldWeight),
              textAlign: TextAlign.center),
        ),
        content: Container(
          width: screenWidth * 0.1,
          height: screenHeight * 0.03,
        ),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: LogoutOkButton(),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CancelLogoutButton(),
              ),
            ],
          )
        ]);
  }
}
