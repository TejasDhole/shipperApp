import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shipper_app/Widgets/invoice_details_dailog.dart';
import 'package:shipper_app/Widgets/invoice_header.dart';
import 'package:shipper_app/constants/colors.dart';
import 'package:shipper_app/constants/fontSize.dart';
import 'package:shipper_app/constants/spaces.dart';
import 'package:shipper_app/controller/shipperIdController.dart';
import 'package:shipper_app/functions/BackgroundAndLocation.dart';
import 'package:shipper_app/functions/fatch_invoice_data.dart';
import 'package:shipper_app/functions/shipperApis/TransporterListFromShipperApi.dart';
import 'package:http/http.dart' as http;
import 'package:sizer/sizer.dart';

class InvoiceScreen extends StatefulWidget {
  const InvoiceScreen({Key? key}) : super(key: key);

  @override
  State<InvoiceScreen> createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen> {
  var inoviceList = [];
  var selectedTransporterList = [];
  bool setSelectedTransporterList = true;
  bool visiable = true;

  
  bool enableFinishButton = false;
  @override
  void initState() {
    super.initState();
    _fetchInvoiceData();
  }

  Future<void> _fetchInvoiceData() async {
    String shipperId = shipperIdController.ownerShipperId.value;

    try {
      List<dynamic> data = await ApiService.getInvoiceData(shipperId);
      setState(() {
        inoviceList = data;
      });
    } catch (e) {
      print('Error fetching invoice data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    bool small = true;
    double textFontSize;
    var screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 1160) {
      small = true;
    } else {
      small = false;
    }

    if (small) {
      textFontSize = 12;
      visiable = false;
    } else {
      textFontSize = 16;
      visiable = true;
    }

    return Scaffold(
      backgroundColor: teamBar,
      body: Column(
        children: [
          Container(
            decoration: const BoxDecoration(color: teamBar),
            height: 70,
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    const Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Invoice',
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: SizedBox(
                    width: screenWidth * 0.3,
                    height: 50,
                    child: Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search',
                          hintStyle: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w400,
                            color: searchBar,
                          ),
                          border: const OutlineInputBorder(
                            borderSide: BorderSide(color: greyShade),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          prefixIcon: const Icon(Icons.search),
                        ),
                        onChanged: (value) {},
                      ),
                    )),
              ),
              Column(
                children: [
                  SizedBox(
                    width: screenWidth * 0.15,
                    height: 75,
                    child: const Padding(
                        padding: EdgeInsets.only(
                          right: 8.0,
                          top: 35.0,
                        ),
                        child: Text(
                          "Date",
                          style: TextStyle(
                              color: black, fontWeight: FontWeight.bold),
                        )),
                  ),
                  Container(
                    color: white,
                    width: screenWidth * 0.1,
                    height: 20,
                    child: const Text(
                      "All month",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          InvoiceHeader(context, textFontSize),
          SizedBox(
            height: space_3,
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.only(left: 5, right: 5),
              separatorBuilder: (context, index) => const Divider(
                color: greyShade,
                thickness: 1,
                height: 0,
              ),
              itemCount: inoviceList.length,
              itemBuilder: (context, index) {
                var invoice = inoviceList[index];
                return Container(
                  color: white,
                  child: IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 3,
                          child: Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 15),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    invoice['invoiceDate'] ?? 'NA',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: kLiveasyColor,
                                      fontSize: textFontSize,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Montserrat',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const VerticalDivider(
                          color: greyShade,
                          thickness: 1,
                          width: 0,
                        ),
                        Expanded(
                          flex: 3,
                          child: Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 15),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    invoice['invoiceNo'] ?? 'NA',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: kLiveasyColor,
                                      fontSize: textFontSize,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Montserrat',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const VerticalDivider(
                          color: greyShade,
                          thickness: 1,
                          width: 0,
                        ),
                        Expanded(
                          flex: 3,
                          child: Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 15),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    invoice['invoiceAmount'] ?? 'NA',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: kLiveasyColor,
                                      fontSize: textFontSize,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Montserrat',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const VerticalDivider(
                          color: greyShade,
                          thickness: 1,
                          width: 0,
                        ),
                        
                        Expanded(
                          flex: 4,
                          child: Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 15),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    invoice['transporterName'] ?? 'NA',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: kLiveasyColor,
                                      fontSize: textFontSize,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Montserrat',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const VerticalDivider(
                          color: greyShade,
                          thickness: 1,
                          width: 0,
                        ),
                        Expanded(
                          flex: 3,
                          child: Align(
                            alignment: Alignment.center,
                            child: Center(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 15),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      invoice['dueDate'] ?? 'NA',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: kLiveasyColor,
                                        fontSize: textFontSize,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Montserrat',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        const VerticalDivider(
                          color: greyShade,
                          thickness: 1,
                          width: 0,
                        ),
                        Expanded(
                          flex: 2,
                          child: Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 15),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    invoice['invoiceStatus'] ?? 'NA',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: kLiveasyColor,
                                      fontSize: textFontSize,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Montserrat',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const VerticalDivider(
                          color: greyShade,
                          thickness: 1,
                          width: 0,
                        ),
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextButton(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Check Invoice',
                                      style: TextStyle(
                                        decoration: TextDecoration.underline,
                                        fontSize: textFontSize - 2,
                                        color: darkBlueColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Visibility(
                                      visible: visiable,
                                      child: const Icon(
                                        Icons.arrow_forward_ios_sharp,
                                        color: kLiveasyColor,
                                        size: 13,
                                      ),
                                    ),
                                  ],
                                ),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return InvoiceDetails();
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
