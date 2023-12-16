import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:shipper_app/Web/screens/home_web.dart';
import 'package:shipper_app/Widgets/EwayBill_Table_Header.dart';
import 'package:shipper_app/constants/colors.dart';
import 'package:shipper_app/constants/fontSize.dart';
import 'package:shipper_app/constants/fontWeights.dart';
import 'package:shipper_app/constants/screens.dart';
import 'package:shipper_app/functions/eway_bill_api.dart';
import 'package:shipper_app/functions/shipperApis/isolatedShipperGetData.dart';
import 'package:shipper_app/screens/Eway_Bill_Details_Screen.dart';
import 'package:shipper_app/screens/FastTagScreen.dart';
import 'package:shipper_app/screens/track_all_fastag_screen.dart';

class EwayBills extends StatefulWidget {
  const EwayBills({super.key});

  @override
  State<EwayBills> createState() => _EwayBillsState();
}

class _EwayBillsState extends State<EwayBills> {
  String search = '';
  String selectedRange = '7 days';
  List<Map<String, dynamic>> EwayBills = [];
  DateTime now = DateTime.now();
  late DateTime yesterday;
  late String from;
  late String gstNo;
  late String to;

  Map<String, int> dateRanges = {
    "3 days": 3,
    "7 days": 7,
    "15 days": 15,
    "30 days": 30
  };

  @override
  void initState() {
    super.initState();
    setDateRange('7 days');
    getEwayBillsData();
  }

  void setDateRange(String range) {
    int days = dateRanges[range] ?? 7;
    yesterday = now.subtract(Duration(days: days));
    from = DateFormat('yyyy-MM-dd').format(yesterday);
  }

  Future<List<Map<String, dynamic>>> getEwayBillsData() async {
    try {
      final DocumentReference documentRef = FirebaseFirestore.instance
          .collection('/Companies')
          .doc(shipperIdController.companyId.value);

      await documentRef.get().then((doc) {
        if (doc.exists) {
          Map data = doc.data() as Map;
          Map companyDetails = data["company_details"];

          gstNo = companyDetails["gst_no"];
        }
      });

      from = DateFormat('yyyy-MM-dd').format(yesterday);
      to = DateFormat('yyyy-MM-dd').format(now);
      EwayBills = await EwayBill().getAllEwayBills(gstNo, from, to);
      //print("$EwayBills");
      return EwayBills;
    } catch (e) {
      print(e);
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: screenHeight * 0.05,
            ),
            child: Text('E-way Bill',
                textAlign: TextAlign.left,
                style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w600,
                    fontSize: screenWidth * 0.02,
                    color: darkBlueTextColor)),
          ),
          Padding(
            padding: EdgeInsets.only(left: screenWidth * 0.19),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Text('Date',
                  textAlign: TextAlign.left,
                  style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w600,
                      fontSize: screenWidth * 0.016,
                      color: Colors.black)),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                top: screenHeight * 0.022, bottom: screenHeight * 0.035),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  flex: 40,
                  child: Container(
                      alignment: Alignment.centerLeft,
                      height: screenHeight * 0.07,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.all(Radius.circular(25)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 0,
                            blurRadius: 12,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                            fillColor: Colors.white,
                            hintText: 'Search by name, bill no',
                            hintStyle: GoogleFonts.montserrat(
                                fontWeight: FontWeight.w500,
                                color: grey2,
                                fontSize: screenWidth * 0.012),
                            border: InputBorder.none,
                            prefixIconColor:
                                const Color.fromARGB(255, 109, 109, 109),
                            prefixIcon: const Icon(Icons.search)),
                        onChanged: (value) {
                          setState(() {
                            search = value.toLowerCase();
                          });
                        },
                      )),
                ),
                const Expanded(flex: 19, child: SizedBox()),
                Expanded(
                    flex: 16,
                    child: Container(
                      height: 55,
                      margin: EdgeInsets.only(
                        right: screenWidth * 0.02,
                      ),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(7),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 5,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                          color: white),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                            value: selectedRange,
                            dropdownColor: Colors.white,
                            alignment: Alignment.center,
                            icon: Padding(
                                padding:
                                    EdgeInsets.only(right: screenWidth * 0.015),
                                child: Icon(Icons.arrow_drop_down,
                                    size: screenWidth * 0.02)),
                            items: dateRanges.keys.map((String key) {
                              return DropdownMenuItem<String>(
                                value: key,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: screenWidth * 0.015),
                                  child: Text(key,
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.montserrat(
                                          fontWeight: FontWeight.w500,
                                          fontSize: screenWidth * 0.013,
                                          color: Colors.black)),
                                ),
                              );
                            }).toList(),
                            onChanged: (newValue) {
                              setState(() {
                                selectedRange = newValue!;
                                setDateRange(newValue);
                                getEwayBillsData();
                              });
                            }),
                      ),
                    )),
                Expanded(
                  flex: 25,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HomeScreenWeb(
                                  visibleWidget:
                                      TrackAllFastagScreen(EwayData: EwayBills),
                                  index: 1000,
                                  selectedIndex:
                                      screens.indexOf(ewayBillScreen),
                                )),
                      );
                    },
                    child: Container(
                      height: 55,
                      margin: EdgeInsets.only(
                          right: screenWidth * 0.02, left: screenWidth * 0.02),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(7),
                          border: Border.all(color: darkBlueTextColor),
                          color: white),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Image.asset('assets/icons/Track.png'),
                          Text('Track All Loads',
                              style: GoogleFonts.montserrat(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: darkBlueTextColor)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          EwayBillsTableHeader(context),
          Expanded(
            child: FutureBuilder(
                future: getEwayBillsData(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Shimmer.fromColors(
                      highlightColor: Colors.white,
                      baseColor: shimmerGrey,
                      child: SizedBox(
                        height: screenHeight,
                        child: Container(
                          width: double.infinity,
                          height: double.infinity,
                          color: Colors.white,
                        ),
                      ),
                    );
                  } else if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError) {
                      // An error occurred while fetching data
                      return Text('Error: ${snapshot.error}');
                    } else if (!snapshot.hasData || snapshot.data == null) {
                      // Data is not available
                      return const Text('No EwayBills are available');
                    } else {
                      List<Map<String, dynamic>> filteredEwayBills =
                          EwayBills.where((bill) => bill['transporterName']
                              .toLowerCase()
                              .contains(search)).toList();
                      return Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 5,
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: filteredEwayBills.length,
                            itemBuilder: (BuildContext context, int index) {
                              final ewayBill = filteredEwayBills[index];
                              final String transporterName =
                                  ewayBill['transporterName'];
                              final String date = ewayBill['ewayBillDate'];
                              DateTime parsedDate =
                                  DateFormat("dd/MM/yyyy hh:mm:ss a")
                                      .parse(date);
                              String ewayBillDate =
                                  DateFormat("dd/MM/yyyy").format(parsedDate);
                              final String fromPlace = ewayBill['fromPlace'];
                              final String toPlace = ewayBill['toPlace'];
                              final String vehicleNumber =
                                  ewayBill['vehicleListDetails'][0]
                                      ['vehicleNo'];                   
                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HomeScreenWeb(
                                              visibleWidget:
                                                  EwayBillDetailScreen(
                                                      ewayBillData: ewayBill),
                                              index: 1000,
                                              selectedIndex: screens
                                                  .indexOf(ewayBillScreen),
                                            )),
                                  );
                                },
                                child: ewayBillData(
                                    transporterName: transporterName,
                                    vehicleNo: vehicleNumber,
                                    from: fromPlace,
                                    to: toPlace,
                                    date: ewayBillDate),
                              );
                            },
                          ));
                    }
                  } else {
                    return const Text("Something went wrong");
                  }
                }),
          )
        ]);
  }

  Container ewayBillData({
    required final String transporterName,
    required final String vehicleNo,
    required final String from,
    required final String to,
    required final String date,
  }) {
    return Container(
        height: 70,
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: greyShade, width: 1)),
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          Expanded(
            flex: 20,
            child: Center(
              child: Text(
                date,
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(
                  color: Colors.black,
                  fontSize: size_8,
                  fontWeight: normalWeight,
                ),
              ),
            ),
          ),
          const VerticalDivider(color: greyShade, thickness: 1),
          Expanded(
              flex: 25,
              child: Center(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                    Image.asset('assets/images/Route.png'),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          from,
                          textAlign: TextAlign.center,
                          selectionColor: sideBarTextColor,
                          style: GoogleFonts.montserrat(
                            color: Colors.black,
                            fontSize: size_8,
                            fontWeight: normalWeight,
                          ),
                        ),
                        Text(
                          to,
                          textAlign: TextAlign.center,
                          selectionColor: sideBarTextColor,
                          style: GoogleFonts.montserrat(
                            color: Colors.black,
                            fontSize: size_8,
                            fontWeight: normalWeight,
                          ),
                        )
                      ],
                    )
                  ]))),
          const VerticalDivider(color: greyShade, thickness: 1),
          Expanded(
              flex: 50,
              child: Center(
                  child: Text(
                transporterName,
                textAlign: TextAlign.center,
                selectionColor: sideBarTextColor,
                style: GoogleFonts.montserrat(
                  color: Colors.black,
                  fontSize: size_8,
                  fontWeight: normalWeight,
                ),
              ))),
          const VerticalDivider(color: greyShade, thickness: 1),
          Expanded(
              flex: 20,
              child: Center(
                  child: Text(
                vehicleNo,
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(
                  fontSize: size_8,
                  color: Colors.black,
                  fontWeight: normalWeight,
                ),
              ))),
          const VerticalDivider(color: greyShade, thickness: 1),
          Expanded(
              flex: 20,
              child: Center(
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HomeScreenWeb(
                                    visibleWidget: MapScreen(
                                      loadingPoint: from,
                                      unloadingPoint: to,
                                      truckNumber: vehicleNo,
                                    ),
                                    index: 1000,
                                    selectedIndex:
                                        screens.indexOf(ewayBillScreen),
                                  )),
                        );
                      },
                      style: ButtonStyle(
                          fixedSize: MaterialStateProperty.all<Size>(
                              const Size.fromWidth(110)),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              darkBlueTextColor)),
                      child: Text(
                        "Track",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.montserrat(
                          fontSize: size_8,
                          color: Colors.white,
                          fontWeight: mediumBoldWeight,
                        ),
                      )))),
        ]));
  }
}
