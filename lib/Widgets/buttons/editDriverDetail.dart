import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shipper_app/constants/colors.dart';
import 'package:shipper_app/constants/fontWeights.dart';
import 'package:shipper_app/responsive.dart';

class EditDriverDetail extends StatefulWidget {
  String? driverName;
  String? driverPhoneNum;
  String? bookingId;
  EditDriverDetail(
      {required this.driverName,
      required this.driverPhoneNum,
      required this.bookingId});

  @override
  State<EditDriverDetail> createState() => _EditDriverDetailState();
}

class _EditDriverDetailState extends State<EditDriverDetail> {
  late TextEditingController nameController;
  late TextEditingController phoneNumController;

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController(text: widget.driverName);
    phoneNumController = TextEditingController(text: widget.driverPhoneNum);
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        showDialogToEdit(
            widget.driverName, widget.driverPhoneNum, widget.bookingId);
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.white),
        side: MaterialStateProperty.all(
            const BorderSide(color: kLiveasyColor, width: 2.0)),
      ),
      child: Text(
        "Edit",
        style: TextStyle(
          color: darkBlueColor,
          fontSize: Responsive.isMobile(context) ? 10 : 16,
        ),
      ),
    );
  }

  void showDialogToEdit(
      String? driverName, String? driverPhoneNum, String? bookingId) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Center(
                child: Text(
              "Edit Driver Detail",
              style: TextStyle(fontWeight: mediumBoldWeight, fontSize: 28),
            )),
            content: SizedBox(
              width: 400,
              height: 350,
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Driver Name",
                          style: TextStyle(
                            color: darkBlueColor,
                            fontSize: Responsive.isMobile(context) ? 18 : 34.0,
                            fontWeight: mediumBoldWeight,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          width: 350,
                          child: TextField(
                            controller: nameController,
                            mouseCursor: SystemMouseCursors.click,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(5)),
                                  borderSide: BorderSide(
                                      color: borderLightColor, width: 0.5)),
                              focusedBorder: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                  borderSide:
                                      BorderSide(color: black, width: 0.5)),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Column(
                      children: [
                        Text(
                          "Driver Phone number",
                          style: TextStyle(
                            color: darkBlueColor,
                            fontSize: Responsive.isMobile(context) ? 18 : 30,
                            fontWeight: mediumBoldWeight,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          width: 350,
                          child: TextField(
                            controller: phoneNumController,
                            mouseCursor: SystemMouseCursors.click,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(5)),
                                  borderSide: BorderSide(
                                      color: borderLightColor, width: 0.5)),
                              focusedBorder: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                  borderSide:
                                      BorderSide(color: black, width: 0.5)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              Align(
                alignment: Alignment.topCenter,
                child: ElevatedButton(
                  onPressed: () {
                    saveChanges(bookingId!);
                    Navigator.of(context).pop();
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(kLiveasyColor),
                  ),
                  child: const Text("Save"),
                ),
              ),
              const SizedBox(
                height: 40,
              )
            ],
          );
        });
  }

  saveChanges(String id) async {
    String driverName = nameController.text;
    String driverPhoneNum = phoneNumController.text;
    final String bookingApiUrl = dotenv.get('bookingApiUrl');

    Map data = {"driverName": driverName, "driverPhoneNum": driverPhoneNum};
    String body = json.encode(data);
    var response = await http.put(Uri.parse("$bookingApiUrl/$id"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: body);
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
