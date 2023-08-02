import 'dart:convert';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/status/http_status.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shipper_app/constants/colors.dart';
import 'package:shipper_app/constants/fontSize.dart';
import 'package:shipper_app/controller/shipperIdController.dart';

Widget addTransporter(diaLogContext, transporterList) {
  TextEditingController txtEdtNameController = TextEditingController(),
      txtEdtPhoneNoController = TextEditingController(),
      txtEdtEmailController = TextEditingController();
  return Container(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Enter Transporter Name',
          style: TextStyle(
              color: kLiveasyColor,
              fontSize: size_10,
              fontFamily: 'Montserrat'),
        ),
        SizedBox(
          height: 10,
        ),
        TextField(
          controller: txtEdtNameController,
          style: TextStyle(
              color: kLiveasyColor, fontFamily: 'Montserrat', fontSize: size_8),
          textAlign: TextAlign.center,
          cursorColor: kLiveasyColor,
          cursorWidth: 1,
          decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.zero,
                  borderSide: BorderSide(color: borderLightColor, width: 1.5)),
              hintText: 'Enter Transporter Name',
              hintStyle: TextStyle(
                  color: borderLightColor,
                  fontFamily: 'Montserrat',
                  fontSize: size_8),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.zero,
                  borderSide: BorderSide(color: truckGreen, width: 1.5))),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          'Enter Transporter Email',
          style: TextStyle(
              color: kLiveasyColor,
              fontSize: size_10,
              fontFamily: 'Montserrat'),
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'required*',
              style: TextStyle(
                  color: red, fontSize: size_5, fontFamily: 'Montserrat'),
            ),
          ],
        ),
        SizedBox(
          height: 5,
        ),
        TextField(
          controller: txtEdtEmailController,
          style: TextStyle(
              color: kLiveasyColor, fontFamily: 'Montserrat', fontSize: size_8),
          textAlign: TextAlign.center,
          cursorColor: kLiveasyColor,
          cursorWidth: 1,
          decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.zero,
                  borderSide: BorderSide(color: borderLightColor, width: 1.5)),
              hintText: 'Enter Transporter Email',
              hintStyle: TextStyle(
                  color: borderLightColor,
                  fontFamily: 'Montserrat',
                  fontSize: size_8),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.zero,
                  borderSide: BorderSide(color: truckGreen, width: 1.5))),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          'Enter Transporter Phone No',
          style: TextStyle(
              color: kLiveasyColor,
              fontSize: size_10,
              fontFamily: 'Montserrat'),
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'required*',
              style: TextStyle(
                  color: red, fontSize: size_5, fontFamily: 'Montserrat'),
            ),
          ],
        ),
        SizedBox(
          height: 5,
        ),
        TextField(
          controller: txtEdtPhoneNoController,
          style: TextStyle(
              color: kLiveasyColor, fontFamily: 'Montserrat', fontSize: size_8),
          textAlign: TextAlign.center,
          cursorColor: kLiveasyColor,
          cursorWidth: 1,
          decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.zero,
                  borderSide: BorderSide(color: borderLightColor, width: 1.5)),
              hintText: 'Enter Transporter Phone No',
              hintStyle: TextStyle(
                  color: borderLightColor,
                  fontFamily: 'Montserrat',
                  fontSize: size_8),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.zero,
                  borderSide: BorderSide(color: truckGreen, width: 1.5))),
        ),
        SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(
              onPressed: () {
                String name = txtEdtNameController.text;
                String phone = txtEdtPhoneNoController.text;
                String email = txtEdtEmailController.text;

                if (name.isNotEmpty &&
                    name != null &&
                    phone.isNotEmpty &&
                    phone != null &&
                    email.isNotEmpty &&
                    email != null) {
                  getTransporterIdByPhone(phone).then((value) {
                    List newAddedTransporter = [
                      email,
                      name,
                      phone,
                      value.toString()
                    ];
                    transporterList.add(newAddedTransporter);
                    updateShipperTransporterList(
                        transporterList, diaLogContext);
                  });
                }
              },
              child: Text(
                'Ok',
                style: TextStyle(fontFamily: 'Montserrat', color: Colors.white),
              ),
              style: ButtonStyle(
                  mouseCursor:
                      MaterialStatePropertyAll(SystemMouseCursors.click),
                  shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                      side: BorderSide(
                        color: truckGreen,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(5)))),
                  padding: MaterialStatePropertyAll(
                      EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 8)),
                  backgroundColor: MaterialStatePropertyAll(truckGreen)),
            ),
            SizedBox(
              width: 10,
            ),
            OutlinedButton(
                onPressed: () {
                  Navigator.of(diaLogContext).pop();
                },
                child: Text(
                  'Cancel',
                  style:
                      TextStyle(fontFamily: 'Montserrat', color: Colors.white),
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(red),
                  mouseCursor:
                      MaterialStatePropertyAll(SystemMouseCursors.click),
                  shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                      side: BorderSide(
                        color: red,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(5)))),
                  padding: MaterialStatePropertyAll(
                      EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 8)),
                )),
          ],
        )
      ],
    ),
  );
}

void updateShipperTransporterList(transporterList, diaLogContext) async {
  try {
    ShipperIdController shipperIdController = Get.put(ShipperIdController());
    String shipperId = shipperIdController.shipperId.value;
    Map<String, dynamic> data = {
      "transporterList": transporterList,
    };
    String body = json.encode(data);
    print(transporterList);
    final String shipperApiUrl = dotenv.get("shipperApiUrl");
    http.Response response = await http.put(
      Uri.parse('$shipperApiUrl/$shipperId'),
      body: body,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == HttpStatus.ok) {
      print("Transporter added successfully");
      Navigator.of(diaLogContext).pop();
    }
  } catch (e) {
    print('1 $e');
  }
}

Future<String> getTransporterIdByPhone(String phoneNo) async {
  try {
    Map<String, dynamic> data = {
      "phoneNo": phoneNo,
    };
    String body = json.encode(data);

    final String transporterApiUrl = dotenv.get("transporterApiUrl");
    http.Response response = await http.post(
      Uri.parse('$transporterApiUrl'),
      body: body,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    var jsonData = json.decode(response.body);
    print(
        "id -->> ${jsonData['transporterId'] != null ? jsonData['transporterId'] : 'Na'}");
    return jsonData['transporterId'] != null ? jsonData['transporterId'] : 'Na';
  } catch (e) {
    print('2 $e');
    return "";
  }
}
