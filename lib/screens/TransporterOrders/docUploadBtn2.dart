import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '/constants/colors.dart';
import 'package:shipper_app/responsive.dart';
import '/constants/fontSize.dart';
import '/constants/fontWeights.dart';
import '/constants/spaces.dart';

// ignore: must_be_immutable
class docUploadbtn2 extends StatelessWidget {
  String assetImage;
  var onPressed;
  var imageFile;

  docUploadbtn2({
    required this.onPressed,
    required this.imageFile,
    required this.assetImage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          child: imageFile == null
              ? Center(child: Image(image: AssetImage(assetImage)))
              : Stack(
                  children: [
                    Center(
                        child: imageFile != null
                            ? Image(image: Image.file(imageFile).image)
                            : Container()),
                    Center(
                      child: imageFile == null
                          ? Center(
                              child: Container(),
                            )
                          : Center(
                              child: Text(
                                "Tap to Open",
                                style: TextStyle(
                                    fontSize: size_6, color: liveasyGreen),
                              ),
                            ),
                    ),
                  ],
                ),
          onTap: onPressed,
        ),
      ],
    ));
  }
}
