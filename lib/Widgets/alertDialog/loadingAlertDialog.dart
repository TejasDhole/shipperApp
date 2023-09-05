import 'package:flutter/material.dart';
import 'package:shipper_app/responsive.dart';
import '/constants/colors.dart';
import '/constants/fontSize.dart';
import '/constants/fontWeights.dart';
import '/constants/spaces.dart';
import '/widgets/loadingWidget.dart';

class LoadingAlertDialog extends StatelessWidget {
  final String? txt;

  LoadingAlertDialog(this.txt, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return AlertDialog(
      alignment: Alignment.bottomCenter,
      content: Container(
          width: (Responsive.isMobile(context)) ? width * 0.8 : width * 0.4,
          height:
              (Responsive.isMobile(context)) ? height * 0.06 : height * 0.08,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                (txt != null && txt!.isNotEmpty) ? txt! : 'Loading!',
                style: TextStyle(
                    fontWeight: mediumBoldWeight,
                    fontSize: (Responsive.isMobile(context)) ? size_8 : size_15,
                    color: kLiveasyColor),
              ),
              SizedBox(
                width: (Responsive.isMobile(context)) ? 20 : 40,
              ),
              LoadingWidget(),
            ],
          )),
    );
  }
}
