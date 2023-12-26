import 'dart:async';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:shipper_app/Web/screens/home_web.dart';
import 'package:shipper_app/Widgets/EwayBill_Table_Header.dart';
import 'package:shipper_app/constants/colors.dart';
import 'package:shipper_app/constants/fontWeights.dart';
import 'package:shipper_app/constants/screens.dart';
import 'package:shipper_app/functions/eway_bill_api.dart';
import 'package:shipper_app/functions/googleDirectionsApi.dart';
import 'package:shipper_app/functions/ongoingTrackUtils/FastTag.dart';
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
  String selectedRange = '3 days';
  List<Map<String, dynamic>> EwayBills = [];
  late Future<List<Map<String, dynamic>>> futureEwayBills;
  DateTime now = DateTime.now();
  late DateTime yesterday;
  late String from;
  late String gstNo;
  late String to;
  Map<String, String> etaCache = {};
  late Key futureBuilderKey = UniqueKey();

  Map<String, int> dateRanges = {
    "3 days": 3,
    "7 days": 7,
    "15 days": 15,
    "30 days": 30
  };

  @override
  void initState() {
    super.initState();
    setDateRange('3 days');
    futureEwayBills = getEwayBillsData();
  }

  void setDateRange(String range) {
    int days = dateRanges[range] ?? 7;
    yesterday = now.subtract(Duration(days: days));
    from = DateFormat('yyyy-MM-dd').format(yesterday);
    futureEwayBills = getEwayBillsData(); // Fetch new data
    futureBuilderKey = UniqueKey();
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

      List<Future<void>> etaCalculations = [];

      for (var bill in EwayBills) {
        String vehicleNo = bill['vehicleListDetails'][0]['vehicleNo'];
        String toAddr1 = bill['toAddr1'];
        String toAddr2 = bill['toAddr2'];
        String toPlace = bill['toPlace'];
        String completeAddress = '$toAddr1,$toAddr2,$toPlace';
        String cacheKey = '$vehicleNo-$completeAddress';
        // Add a Future to the list to calculate ETA for each bill

        if (!etaCache.containsKey(cacheKey)) {
          // Calculate ETA only if not present in the cache
          String eta = await getETA(vehicleNo, completeAddress);
          etaCache[cacheKey] = eta;
        }
        bill['eta'] = etaCache[cacheKey];
      }

      await Future.wait(etaCalculations);

      return EwayBills;
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<String> getETA(String vehicleNo, String recipientAddress) async {
    to = now.toIso8601String();
    try {
      List<dynamic>? locations =
          await checkFastTag().getVehicleLocation(vehicleNo);
      if (locations != null && locations.isNotEmpty) {
        final lastLocation = locations.last;
        DateTime readerReadTime =
            DateTime.parse(lastLocation['readerReadTime']);
        TimeOfDay readerTime =
            TimeOfDay(hour: readerReadTime.hour, minute: readerReadTime.minute);
        final geoCode = lastLocation['tollPlazaGeocode'].split(',');

        if (geoCode.length == 2) {
          final double latitude = double.tryParse(geoCode[0]) ?? 0.0;
          final double longitude = double.tryParse(geoCode[1]) ?? 0.0;
          LatLng currentLocation = LatLng(latitude, longitude);

          LatLng? lastAddress = await getCoordinatesForWeb(recipientAddress);

          String? estimatedTime = await EstimatedTime()
              .getEstimatedTime(currentLocation, lastAddress!);

          if (estimatedTime != null) {
            // Parse estimated time to total hours
            RegExp regExp = RegExp(r'(\d+) day[s]? (\d+) hour[s]?');
            var matches = regExp.firstMatch(estimatedTime);
            int days = int.parse(matches?.group(1) ?? '0');
            int hours = int.parse(matches?.group(2) ?? '0');
            int totalEtaHours = days * 24 + hours;

            // Get current time
            TimeOfDay nowTime = TimeOfDay.now();
        
            // Calculate the difference in hours and minutes from the readerTime to nowTime
            int hourDifference = nowTime.hour - readerTime.hour;
            int minuteDifference = nowTime.minute - readerTime.minute;

            // Adjust for any negative values
            if (minuteDifference < 0) {
              hourDifference -= 1;
              minuteDifference += 60;
            }

            // Subtract the difference from the total ETA hours
            int updatedEtaHours = totalEtaHours - hourDifference;
            int updatedEtaMinutes = minuteDifference;

            // Convert back to days and hours
            int updatedEtaDays = updatedEtaHours ~/ 24;
            updatedEtaHours %= 24;
            String formattedEta =
                '$updatedEtaDays day, $updatedEtaHours hours, $updatedEtaMinutes minutes';
            return formattedEta;
          }
        }
      }
    } catch (e) {
      print("Error fetching FastTag data in getETA function : $e");
    }
    return "Not Available";
  }

  Future<LatLng?> getCoordinatesForWeb(String placename) async {
    try {
      final encodedAddress = Uri.encodeComponent(placename);
      final url =
          'https://maps.googleapis.com/maps/api/geocode/json?address=$encodedAddress&key=${dotenv.get('mapKey')}';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'OK' && data['results'].isNotEmpty) {
          final location = data['results'][0]['geometry']['location'];
          final lat = location['lat']; // Corrected
          final lng = location['lng'];
          return LatLng(lat, lng);
        }
      }
    } catch (e) {
      debugPrint("Web function isn't working");
    }
    return null;
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
                        borderRadius:
                            const BorderRadius.all(Radius.circular(25)),
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
                                //futureEwayBills = getEwayBillsData();
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
                                  fontSize: screenWidth * 0.0125,
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
                key: futureBuilderKey,
                future: futureEwayBills,
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
                              String eta = ewayBill['eta'];

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
                                    date: ewayBillDate,
                                    eta: eta,
                                    screenWidth: screenWidth),
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

  Container ewayBillData(
      {required final String transporterName,
      required final String vehicleNo,
      required final String from,
      required final String to,
      required final String date,
      required final String eta,
      required final screenWidth}) {
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
                  fontSize: screenWidth * 0.0125,
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
                            fontSize: screenWidth * 0.0125,
                            fontWeight: normalWeight,
                          ),
                        ),
                        Text(
                          to,
                          textAlign: TextAlign.center,
                          selectionColor: sideBarTextColor,
                          style: GoogleFonts.montserrat(
                            color: Colors.black,
                            fontSize: screenWidth * 0.0125,
                            fontWeight: normalWeight,
                          ),
                        )
                      ],
                    )
                  ]))),
          const VerticalDivider(color: greyShade, thickness: 1),
          Expanded(
              flex: 45,
              child: Center(
                  child: Text(
                transporterName,
                textAlign: TextAlign.center,
                selectionColor: sideBarTextColor,
                style: GoogleFonts.montserrat(
                  color: Colors.black,
                  fontSize: screenWidth * 0.0125,
                  fontWeight: normalWeight,
                ),
              ))),
          const VerticalDivider(color: greyShade, thickness: 1),
          Expanded(
              flex: 15,
              child: Center(
                  child: Text(
                vehicleNo,
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(
                  fontSize: screenWidth * 0.0125,
                  color: Colors.black,
                  fontWeight: normalWeight,
                ),
              ))),
          const VerticalDivider(color: greyShade, thickness: 1),
          Expanded(
              flex: 15,
              child: Center(
                  child: Text(
                eta,
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(
                  fontSize: screenWidth * 0.0125,
                  color: Colors.black,
                  fontWeight: normalWeight,
                ),
              ))),
          const VerticalDivider(color: greyShade, thickness: 1),
          Expanded(
              flex: 15,
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
                          fontSize: screenWidth * 0.0125,
                          color: Colors.white,
                          fontWeight: mediumBoldWeight,
                        ),
                      )))),
        ]));
  }
}
