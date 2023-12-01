import 'package:flutter/material.dart';

import 'package:shipper_app/Widgets/alertDialog/CompletedDialog.dart';
import 'package:shipper_app/constants/colors.dart';
import 'package:shipper_app/constants/elevation.dart';
import 'package:shipper_app/functions/truckApis/consentApi.dart';
import '../../constants/spaces.dart';

//This button is used to send the consent to the user
class SendConsentButton extends StatefulWidget {
  String? mobileno;
  String? selectedOperator;
  String? responseStatus;
  String? title;
  SendConsentButton({
    required this.mobileno,
    required this.selectedOperator,
    this.title,
  });
  @override
  State<SendConsentButton> createState() => _SendConsentButtonState();
}

class _SendConsentButtonState extends State<SendConsentButton> {
  String? responseStatus; // Store the response status

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: darkBlueColor,
        elevation: elevation_0,
      ),
      onPressed: () async {
        final response = await consentApiCall(
          mobileNumber: widget.mobileno,
          operator: widget.selectedOperator,
        );
        // Check the response status
        responseStatus = response['status'];

        // Show dialog based on the response status
        _showDialogBasedOnStatus(responseStatus);
      },
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.only(left: space_2),
            child: Text(widget.title!),
          ),
        ],
      ),
    );
  }

  void _showDialogBasedOnStatus(String? status) {
    if (status == "Consent Send to driver") {
      // Show dialog 1 for "consent send to the driver"
      showDialog(
        context: context,
        builder: (BuildContext context) {
          const Duration dialogDisplayDuration = Duration(seconds: 3);
          Future<void>.delayed(dialogDisplayDuration, () {
            Navigator.of(context).pop();
          });
          return completedDialog(
            lowerDialogText: '',
            upperDialogText: 'Consent has been sent to the driver.',
          );
        },
      );
    } else if (status == "Device already registered") {
      // Show dialog 2 for "device already registered"
      showDialog(
        context: context,
        builder: (BuildContext context) {
          const Duration dialogDisplayDuration = Duration(seconds: 3);
          Future<void>.delayed(dialogDisplayDuration, () {
            Navigator.of(context).pop();
          });
          return completedDialog(
            lowerDialogText: '',
            upperDialogText: 'The device is already registered.',
          );
        },
      );
    } else {
      // Show a generic dialog for other cases
      showDialog(
        context: context,
        builder: (BuildContext context) {
          const Duration dialogDisplayDuration = Duration(seconds: 3);
          Future<void>.delayed(dialogDisplayDuration, () {
            Navigator.of(context).pop();
          });
          return AlertDialog(
            title: const Text(
              "Response Status",
              style: TextStyle(fontFamily: 'Montserrat'),
            ),
            content: SizedBox(
              width: MediaQuery.of(context).size.width / 2,
              height: MediaQuery.of(context).size.height / 5,
              child: Column(
                children: [
                  Image(
                    image: const AssetImage("assets/images/alert.png"),
                    width: space_10,
                    height: space_10,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: space_2),
                    child: Text(
                        status ?? "Something went wrong please try again!!"),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
  }
}
