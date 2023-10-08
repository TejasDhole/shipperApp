import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shipper_app/constants/colors.dart';
import 'package:shipper_app/functions/ongoingTrackUtils/FastTag.dart';
import 'package:shipper_app/models/vehicleDetails.dart';
import 'package:shipper_app/responsive.dart';
import 'package:xml/xml.dart';

class VehicleDetailsScreen extends StatefulWidget {
  String? truckNumber;
  VehicleDetailsScreen({super.key, this.truckNumber});

  @override
  State<VehicleDetailsScreen> createState() => _VehicleDetailsScreenState();
}

class _VehicleDetailsScreenState extends State<VehicleDetailsScreen> {
  VehicleDetails? _vehicleDetails;

  @override
  void initState() {
    super.initState();
    // Calling API function to fetch vehicle details here
    checkFastTag()
        .fetchVehicleDetails(widget.truckNumber!)
        .then((vehicleDetails) {
      setState(() {
        debugPrint('this is vehicle at 246 : ${vehicleDetails.toString()}');
        _vehicleDetails = vehicleDetails;
      });
    }).catchError((error) {
      // Handle the error, e.g., show an error message
      print("Error fetching vehicle details in init : $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    bool isMobile = Responsive.isMobile(context);
    List<Widget> rows = [];
    late final data;

    if (_vehicleDetails != null) {
      data = _vehicleDetails!.getData();
      debugPrint('this is data at 274 : $data');

      data.forEach((key, value) {
        Widget row;
        if (key != 'Owner_Name') {
          row = _buildRow(key, value);
          rows.add(row);
        }
      });
    } else {
      debugPrint('data is not coming in this if check');
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding: isMobile
                  ? EdgeInsets.only(
                      left: screenHeight * 0.015,
                      bottom: screenHeight * 0.01,
                      top: screenHeight * 0.02)
                  : EdgeInsets.only(
                      left: screenWidth * 0.01,
                      bottom: screenWidth * 0.01,
                      top: screenWidth * 0.01),
              width: screenWidth,
              color: formBackground,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Loads',
                  style: GoogleFonts.montserrat(
                    fontSize:
                        isMobile ? screenHeight * 0.03 : screenWidth * 0.018,
                    fontWeight: FontWeight.w500,
                    color: darkBlueTextColor,
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back),
                ),
                Padding(
                  padding: EdgeInsets.only(left: screenWidth * 0.01),
                  child: Text(
                    "Vehicle Details",
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w500,
                      fontSize:
                          isMobile ? screenHeight * 0.03 : screenWidth * 0.018,
                      color: darkBlueTextColor,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.01),
            Expanded(
              child: ListView(shrinkWrap: true, children: [
                Column(children: [
                  Padding(
                    padding: EdgeInsets.only(left: screenHeight * 0.013),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Owner Details',
                          textAlign: TextAlign.left,
                          style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.w500,
                              color: vehicleDetailsText)),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: screenHeight * 0.013),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(data['Owner_Name'] ?? 'N/A',
                          style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.w500, color: black)),
                    ),
                  ),
                ]),
                GridView(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  padding: const EdgeInsets.all(10),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 30,
                      mainAxisSpacing: 0,
                      mainAxisExtent: 70),
                  children: rows,
                )
              ]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String key, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(key,
              style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w500, color: vehicleDetailsText)),
          Text(value ?? 'N/A',
              style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w500, color: black)),
        ],
      ),
    );
  }
}
