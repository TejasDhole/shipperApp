import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '/constants/colors.dart';
import '/constants/fontSize.dart';
import '/constants/fontWeights.dart';
import '/constants/spaces.dart';

class completedDialog extends StatefulWidget {
  String? upperDialogText;
  String? lowerDialogText;

  completedDialog(
      {Key? key, required this.upperDialogText, required this.lowerDialogText})
      : super(key: key);

  @override
  _completedDialogState createState() => _completedDialogState();
}

class _completedDialogState extends State<completedDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
          width: MediaQuery.of(context).size.width / 2,
          height: MediaQuery.of(context).size.height / 3.9,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Image.asset(
                "assets/icons/complete_alert_animation.gif",
                width: space_22,
                height: space_22,
              ),
              Text(
                widget.upperDialogText!,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: mediumBoldWeight,
                    fontSize: size_8,
                    color: liveasyBlackColor),
              ),
              Text(
                widget.lowerDialogText!,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: mediumBoldWeight,
                    fontSize: size_8,
                    color: liveasyBlackColor),
              ),
            ],
          )),
    );
  }
}
