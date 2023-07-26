import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shipper_app/Widgets/loadDetailsWebWidgets/BiddingDateTime.dart';
import 'package:shipper_app/constants/colors.dart';
import 'package:shipper_app/constants/fontSize.dart';

class PublishMethodBidWebScreen extends StatefulWidget {
  final publishMethod;
  const PublishMethodBidWebScreen({super.key, required this.publishMethod});

  @override
  State<PublishMethodBidWebScreen> createState() =>
      _PublishMethodBidWebScreenState();
}

class _PublishMethodBidWebScreenState extends State<PublishMethodBidWebScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            (widget.publishMethod == 'Bid')
                ? Row(
                    children: [
                      BiddingDateTime(),
                      SizedBox(
                        width: 40,
                      ),
                      Expanded(
                          flex: 4,
                          child: Container(
                            child: TextField(
                              style: TextStyle(
                                  color: kLiveasyColor,
                                  fontFamily: 'Montserrat',
                                  fontSize: size_8),
                              textAlign: TextAlign.center,
                              showCursor: false,
                              mouseCursor: SystemMouseCursors.click,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.zero,
                                      borderSide: BorderSide(
                                          color: borderLightColor, width: 1.5)),
                                  hintText: 'Choose Date and Time',
                                  hintStyle: TextStyle(
                                      color: borderLightColor,
                                      fontFamily: 'Montserrat',
                                      fontSize: size_8),
                                  label: Text('Bidding end Date and Time',
                                      style: TextStyle(
                                          color: kLiveasyColor,
                                          fontFamily: 'Montserrat',
                                          fontSize: size_10,
                                          fontWeight: FontWeight.w600),
                                      selectionColor: kLiveasyColor),
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                  suffixIcon: Icon(
                                    Icons.search,
                                    color: borderLightColor,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.zero,
                                      borderSide: BorderSide(
                                          color: truckGreen, width: 1.5))),
                            ),
                          )),
                      SizedBox(
                        width: 40,
                      ),
                      Expanded(
                        flex: 1,
                        child: TextButton(
                          onPressed: () {},
                          child: Container(
                            height: 50,
                            child: Center(
                              child: Text('Add Transporter',
                                  style: TextStyle(
                                      color: truckGreen,
                                      fontFamily: 'Montserrat',
                                      fontSize: size_7)),
                            ),
                          ),
                          style: ButtonStyle(
                            mouseCursor: MaterialStatePropertyAll<MouseCursor>(
                                SystemMouseCursors.click),
                            padding: MaterialStatePropertyAll<EdgeInsets>(
                                EdgeInsets.only(
                                    left: 20, right: 20, top: 10, bottom: 10)),
                            shape:
                                MaterialStatePropertyAll<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.all(Radius.zero),
                                        side: BorderSide(
                                          color: truckGreen,
                                          width: 2,
                                        ))),
                            textStyle: MaterialStatePropertyAll<TextStyle>(
                                TextStyle(
                                    color: truckGreen,
                                    fontFamily: 'Montserrat',
                                    fontSize: size_6)),
                          ),
                        ),
                      )
                    ],
                  )
                : Container(),
            SizedBox(
              height: 80,
            ),
            Container(
              width: 420,
              child: InputDecorator(
                  child: SizedBox(
                    width: 400,
                    height: 400,
                  ),
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                        color: truckGreen,
                        width: 2,
                      )),
                      contentPadding: EdgeInsets.all(20),
                      label: Container(
                        padding: EdgeInsets.only(left: 10),
                        width: 200,
                        child: Row(
                          children: [
                            Text(
                              'Transporter',
                              style: TextStyle(
                                  color: truckGreen,
                                  fontFamily: 'Montserrat',
                                  fontSize: size_10),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: Image.asset(
                                    'assets/images/filter.png',
                                    fit: BoxFit.contain,
                                    filterQuality: FilterQuality.high,
                                  )),
                            )
                          ],
                        ),
                      ))),
            )
          ],
        ),
      ),
    );
  }
}
