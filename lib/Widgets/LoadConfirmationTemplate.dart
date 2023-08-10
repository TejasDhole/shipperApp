import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shipper_app/responsive.dart';
import '/constants/colors.dart';
import '/constants/fontSize.dart';
import '/constants/fontWeights.dart';
import '/constants/spaces.dart';
import 'package:marquee/marquee.dart';

class LoadConfirmationTemplate extends StatelessWidget {
  final String? label;
  final String? value;

  LoadConfirmationTemplate({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: space_3),
      child: Container(
        margin: EdgeInsets.only(top: space_1),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    '$label',
                    style: TextStyle(fontWeight: normalWeight),
                  ),
                ),
                Text(":"),
                SizedBox(
                  width: 20,
                ),
                (label == 'Location')
                    ? Expanded(
                        flex: 6,
                        child: SizedBox(
                          height: 20,
                          child: Marquee(
                            text: value!,
                            style: TextStyle(
                                fontWeight: mediumBoldWeight,
                                color: veryDarkGrey,
                                fontSize: size_6),
                            scrollAxis: Axis.horizontal,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            blankSpace: 20.0,
                            velocity: 100.0,
                            pauseAfterRound: const Duration(seconds: 1),
                            accelerationDuration:
                                const Duration(milliseconds: 10),
                            accelerationCurve: Curves.linear,
                            decelerationDuration:
                                const Duration(milliseconds: 500),
                            decelerationCurve: Curves.easeOut,
                          ),
                        ),
                      )
                    : Expanded(
                        flex: 6,
                        child: Text(
                          value!,
                          style: TextStyle(
                              fontWeight: mediumBoldWeight,
                              color: veryDarkGrey,
                              fontSize: size_6),
                        ),
                      ),
              ],
            ),
            SizedBox(
              height: space_3,
            ),
            Divider(
              color: (label == 'Select' ||
                      label == 'Contract' ||
                      label == 'Bidding End Date & Time')
                  ? transparent
                  : grey,
              height: 0,
            )
          ],
        ),
      ),
    );
  }
}
