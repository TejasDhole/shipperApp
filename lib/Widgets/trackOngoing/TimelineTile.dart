import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:shipper_app/constants/colors.dart';
import 'package:http/http.dart' as http;
import 'package:shipper_app/functions/ongoingTrackUtils/FastTag.dart';
import 'package:shipper_app/responsive.dart';
import 'package:timeline_tile/timeline_tile.dart';

class TimeLineWidget extends StatefulWidget {
  List<dynamic>? location;
  String? vehicle;

  TimeLineWidget({this.location, this.vehicle});

  @override
  _TimeLineWidgetState createState() => _TimeLineWidgetState();
}

class _TimeLineWidgetState extends State<TimeLineWidget> {
  // final String vehicle = "CG07BC9186";

  Future<List<dynamic>> fetchLocations() async {
    final locations = await checkFastTag().getVehicleLocation(widget.vehicle!);
    return locations;
  }

  Future<String> fetchAddressForWeb(double latitude, double longitude) async {
    final url =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=${dotenv.get('mapKey')}';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 'OK' && data['results'].isNotEmpty) {
        final String address = data['results'][0]['formatted_address'];
        return address.toString();
      }
    }
    return 'Address not found';
  }

  Future<String> getAddress(double latitude, double longitude) async {
    try {
      final List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        final Placemark placemark = placemarks[0];
        final String subThoroughfare = placemark.subThoroughfare ?? '';
        final String thoroughfare = placemark.thoroughfare ?? '';
        final String subLocality = placemark.subLocality ?? '';
        final String locality = placemark.locality ?? '';
        final String subAdminArea = placemark.subAdministrativeArea ?? '';
        final String adminArea = placemark.street ?? '';
        final String postalCode = placemark.postalCode ?? '';
        final String country = placemark.country ?? '';

        final String address =
            '$subThoroughfare $thoroughfare, $subLocality, $locality, $subAdminArea, $adminArea, $postalCode, $country';
        return address
            .toString(); // You can customize this to include more address details
      }
    } catch (e) {
      print('Error: $e');
    }
    return 'Address not found';
  }

  FutureBuilder<String> buildAddressWidget(
      double latitude, double longitude, BuildContext context) {
    bool isMobile = Responsive.isMobile(context);
    double screenHeight = MediaQuery.of(context).size.height;
    return FutureBuilder<String>(
      future: fetchAddressForWeb(latitude, longitude),
      builder: (context, addressSnapshot) {
        if (addressSnapshot.connectionState == ConnectionState.waiting) {
          return Shimmer.fromColors(
              baseColor: lightGrey,
              highlightColor: greyishWhiteColor,
              child: Container(
                height: screenHeight,
                color: lightGrey,
              ));
        } else if (addressSnapshot.hasError) {
          return Text('Error: ${addressSnapshot.error}');
        } else {
          return Text(
            addressSnapshot.data ?? 'Address not found',
            style: GoogleFonts.montserrat(
              fontSize: 14,
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return FutureBuilder<List<dynamic>>(
      future: fetchLocations(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // You can return a loading indicator here
          return Shimmer.fromColors(
              baseColor: lightGrey,
              highlightColor: greyishWhiteColor,
              child: Container(
                height: screenHeight,
                color: lightGrey,
              ));
        } else if (snapshot.hasError) {
          // Handle the error
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          // Handle the case where no data is available
          return const Text('No location data available');
        } else {
          final locations = snapshot.data;
          if (locations == null) {
            return Shimmer.fromColors(
                baseColor: lightGrey,
                highlightColor: greyishWhiteColor,
                child: Container(
                  height: screenHeight,
                  color: lightGrey,
                ));
          }
          return ListView.builder(
            itemCount: locations.length,
            itemBuilder: (context, index) {
              final location = locations[index];
              final time = DateTime.parse(location['readerReadTime']);
              final indianTime = DateFormat('dd MMM yyyy, hh:mm a', 'en_US')
                  .format(time.toLocal());

              Widget buildCustomIndicator(int number) {
                return Transform.scale(
                  scale: 2.0,
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: const BoxDecoration(
                      color: darkBlueTextColor,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      number.toString(),
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: 10,
                      ),
                    ),
                  ),
                );
              }

              return Container(
                color: headerLightBlueColor,
                child: TimelineTile(
                  alignment: TimelineAlign.start,
                  isFirst: index == 0,
                  isLast: index == locations.length - 1,
                  indicatorStyle: IndicatorStyle(
                    width: 50,
                    color: darkBlueTextColor,
                    padding: const EdgeInsets.all(6),
                    indicator: buildCustomIndicator(index + 1),
                  ),
                  beforeLineStyle: const LineStyle(
                    color: timelinesColor,
                    thickness: 2,
                  ),
                  endChild: Container(
                    padding: const EdgeInsets.only(
                      top: 25,
                      left: 30,
                      right: 30,
                      bottom: 25,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          location['tollPlazaName'],
                          style: GoogleFonts.montserrat(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        buildAddressWidget(
                            double.parse(
                                location['tollPlazaGeocode'].split(',')[0]),
                            double.parse(
                                location['tollPlazaGeocode'].split(',')[1]),
                            context),
                        Text(
                          indianTime.toString(),
                          style: GoogleFonts.montserrat(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}
