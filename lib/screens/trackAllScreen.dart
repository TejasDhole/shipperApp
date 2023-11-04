import 'dart:convert';
import 'dart:ui' as ui;
import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:shipper_app/constants/colors.dart';
import 'package:shipper_app/functions/bookingApiCalls.dart';
import 'package:shipper_app/functions/mapUtils/getLoactionUsingImei.dart';
import 'package:shipper_app/functions/ongoingTrackUtils/FastTag.dart';
import 'package:shipper_app/models/BookingModel.dart';

class TrackAllScreen extends StatefulWidget {
  const TrackAllScreen({super.key});

  @override
  State<TrackAllScreen> createState() => _TrackAllScreenState();
}

class _TrackAllScreenState extends State<TrackAllScreen> {
  BookingApiCalls bookingApi = BookingApiCalls();
  List<List<LatLng>> routes = [];
  List<dynamic>? locations;
  List<dynamic>? stoppages;
  DateTime yesterday =
      DateTime.now().subtract(const Duration(days: 1, hours: 5, minutes: 30));
  late String from;
  late String to;
  DateTime now = DateTime.now().subtract(const Duration(hours: 5, minutes: 30));

  CustomInfoWindowController customInfoWindowController =
      CustomInfoWindowController();
  List<Marker> _markers = [];
  final Set<Polyline> _polyline = {};
  final List<String> paths = [
    'assets/images/TollImage.png',
    'assets/images/TollImage.png',
    'assets/images/TollImage.png',
  ];

  @override
  void initState() {
    super.initState();
    fetchBookingData();
  }

  Future<void> fetchBookingData() async {
    String geoCode;
    from = yesterday.toIso8601String();
    to = now.toIso8601String();
    debugPrint('fromDate : $from');
    debugPrint('toDate : $to');
    try {
      List<BookingModel> bookingData =
          await bookingApi.getDataByPostLoadIdOnGoing();

      //access all the bookings
      for (BookingModel booking in bookingData) {
        //Get the coordinates of the loadingPoint
        print('one by one booking : $booking');
        print('one by one booking : ${booking.loadingPointCity}');
        List<LatLng> eachBookingCompleteCoordinates = [];
        LatLng? loadingPointCoordinates =
            await getCoordinatesForWeb(booking.loadingPointCity!);

        print('first contains loadingpoint one : $loadingPointCoordinates');

        //Add the marker for the loadingPoint
        if (loadingPointCoordinates != null) {
          eachBookingCompleteCoordinates.add(loadingPointCoordinates);
          final Uint8List loadingPointMarker =
              await getBytesFromAssets('assets/icons/StartingPoint.png', 55);

          _markers.add(Marker(
            markerId: const MarkerId("loading_Point"),
            position: loadingPointCoordinates,
            icon: BitmapDescriptor.fromBytes(loadingPointMarker),
            onTap: () {
              customInfoWindowController.addInfoWindow!(
                  Container(
                    alignment: Alignment.center,
                    height: 50,
                    width: 200,
                    decoration: const BoxDecoration(color: Colors.white),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(booking.loadingPointCity ?? '',
                            style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.w500,
                                color: diffDeleteButtonColor)),
                      ],
                    ),
                  ),
                  loadingPointCoordinates);
            },
          ));
        } else {
          debugPrint("loading point is  null");
        }

        locations = await checkFastTag()
            .getVehicleLocation(booking.truckId!.toString());
        stoppages = await MapUtil().getTraccarStoppages(
            deviceId: booking.deviceId, from: from, to: to);
        debugPrint('Printing stoppages before if else : $stoppages');

        if (locations!.isNotEmpty) {
          for (int i = 0; i < locations!.length; i++) {
            final location = locations![i];
            String combinedDateTime = location['readerReadTime'];
            DateTime dateTime = DateTime.parse(combinedDateTime);
            String formattedDate = DateFormat('dd MM yyyy').format(dateTime);
            String formattedTime = DateFormat('hh:mm a').format(dateTime);

            geoCode = location['tollPlazaGeocode'];
            final List<String> geoCodeParts = geoCode.split(',');

            if (geoCodeParts.length == 2) {
              final double latitude = double.tryParse(geoCodeParts[0]) ?? 0.0;
              final double longitude = double.tryParse(geoCodeParts[1]) ?? 0.0;

              final Uint8List marker = await getBytesFromAssets(paths[i], 35);

              _markers.add(Marker(
                  markerId: MarkerId(i.toString()),
                  position: LatLng(latitude, longitude),
                  icon: BitmapDescriptor.fromBytes(marker),
                  onTap: () {
                    customInfoWindowController.addInfoWindow!(
                        Container(
                            height: 400,
                            width: 400,
                            decoration:
                                const BoxDecoration(color: Colors.transparent),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                    width: 200,
                                    height: 60,
                                    decoration: const BoxDecoration(
                                        color: Color.fromRGBO(0, 0, 0, 0.7)),
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text(location['tollPlazaName'],
                                              style: GoogleFonts.montserrat(
                                                  fontWeight: FontWeight.w500,
                                                  color: white)),
                                          Text(formattedDate,
                                              style: GoogleFonts.montserrat(
                                                  fontWeight: FontWeight.w500,
                                                  color: white)),
                                          Text(formattedTime,
                                              style: GoogleFonts.montserrat(
                                                  fontWeight: FontWeight.w500,
                                                  color: white)),
                                        ]))
                              ],
                            )),
                        LatLng(latitude, longitude));
                  }));
              eachBookingCompleteCoordinates.add(LatLng(latitude, longitude));
            }
          }
        } else if (stoppages!.isNotEmpty) {
          debugPrint('Stoppages List by Aman : $stoppages');
        } else {
          debugPrint("dono hi nhi aaye");
        }

        LatLng? unloadingPointCoordinates =
            await getCoordinatesForWeb(booking.unloadingPointCity!);
        if (unloadingPointCoordinates != null) {
          eachBookingCompleteCoordinates.add(unloadingPointCoordinates);
          final Uint8List unloadingPointMarker =
              await getBytesFromAssets('assets/icons/Endingpoint.png', 55);

          _markers.add(Marker(
              markerId: const MarkerId('unloading_Point'),
              position: unloadingPointCoordinates,
              icon: BitmapDescriptor.fromBytes(unloadingPointMarker),
              onTap: () {
                customInfoWindowController.addInfoWindow!(
                    Container(
                      alignment: Alignment.center,
                      height: 50,
                      width: 200,
                      decoration: const BoxDecoration(color: Colors.white),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(booking.unloadingPointCity ?? '',
                              style: GoogleFonts.montserrat(
                                  fontWeight: FontWeight.w500,
                                  color: okButtonColor)),
                        ],
                      ),
                    ),
                    unloadingPointCoordinates);
              }));
        } else {
          debugPrint("no unloading point");
        }
        routes.add(eachBookingCompleteCoordinates);
      }
      print(routes);
    } catch (e) {
      print('Error fetching data: $e');
    }
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

  Future<Uint8List> getBytesFromAssets(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetHeight: width);
    ui.FrameInfo info = await codec.getNextFrame();
    return (await info.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}
