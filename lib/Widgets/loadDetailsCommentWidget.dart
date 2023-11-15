import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:shipper_app/screens/PostLoadScreens/PostLoadScreenLoadDetails.dart';

import '../constants/colors.dart';
import '../constants/fontSize.dart';
import '../providerClass/providerData.dart';

class LoadDetailsCommentWidget extends StatefulWidget {
  @override
  State<LoadDetailsCommentWidget> createState() =>
      _LoadDetailsCommentWidgetState();
}

class _LoadDetailsCommentWidgetState extends State<LoadDetailsCommentWidget> {
  TextEditingController txtController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ProviderData providerData = Provider.of<ProviderData>(context);
    if (providerData.comment != '') {
      txtController.text = providerData.comment;
    } else {
      txtController.clear();
    }
    txtController
        .moveCursorToEnd(); // without this text will be inserted in backward

    return Container(
      child: TextField(
        showCursor: true,
        cursorColor: kLiveasyColor,
        cursorWidth: 1,
        maxLines: 5,
        controller: txtController,
        onChanged: (value) {
          providerData.updateResetActive(false);
          providerData.updateComment(value);
        },
        style: TextStyle(
            color: kLiveasyColor, fontFamily: 'Montserrat', fontSize: size_8),
        minLines: 5,
        maxLength: 500,
        decoration: InputDecoration(
            border: OutlineInputBorder(
                borderRadius: BorderRadius.zero,
                borderSide: BorderSide(color: borderLightColor, width: 1.5)),
            hintText: 'Enter your comment',
            hintStyle: TextStyle(
                color: borderLightColor,
                fontFamily: 'Montserrat',
                fontSize: size_8),
            label: Text('Comment',
                style: TextStyle(
                    color: kLiveasyColor,
                    fontFamily: 'Montserrat',
                    fontSize: size_10,
                    fontWeight: FontWeight.w600),
                selectionColor: kLiveasyColor),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.zero,
                borderSide: BorderSide(color: truckGreen, width: 1.5))),
      ),
    );
  }
}
