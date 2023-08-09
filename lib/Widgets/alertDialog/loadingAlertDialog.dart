import 'package:flutter/material.dart';
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
    return AlertDialog(
      alignment: Alignment.bottomCenter,
      content: Container(
          width: MediaQuery.of(context).size.width * 0.4,
          height: MediaQuery.of(context).size.height * 0.08,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                (txt != null && txt!.isNotEmpty) ? txt! : 'Loading!',
                style: TextStyle(
                    fontWeight: mediumBoldWeight,
                    fontSize: size_15,
                    color: kLiveasyColor),
              ),
              SizedBox(
                width: 40,
              ),
              LoadingWidget(),
            ],
          )),
    );
  }
}
