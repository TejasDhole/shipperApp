import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:shipper_app/Widgets/invoice_trip_header.dart';
import 'package:shipper_app/constants/colors.dart';
import 'package:shipper_app/constants/fontSize.dart';
import 'package:shipper_app/constants/fontWeights.dart';
import 'package:shipper_app/controller/previewUploadedImage.dart';
import 'package:shipper_app/functions/documentApi/getDocumentApiCall.dart';
import 'package:shipper_app/functions/uploadingDoc.dart';
import 'package:http/http.dart' as http;

class InvoiceTrip extends StatefulWidget {
  List<String> bookingIds;
  DateTime invoiceDate;
  DateTime dueDate;

  InvoiceTrip({
    super.key,
    required this.bookingIds,
    required this.invoiceDate,
    required this.dueDate,
  });

  @override
  State<InvoiceTrip> createState() => _InvoiceTripState();
}

class _InvoiceTripState extends State<InvoiceTrip> {
  bool visiable = true;
  Map? loadData;

  bool showUploadedDocs = true;
  bool verified = false;
  String? currentBook;
  bool showAddMoreDoc = true;
  PreviewUploadedImage previewUploadedImage = Get.put(PreviewUploadedImage());

  // Function to fetch data from the Booking API based on bookingId
  Future<List<dynamic>> fetchDataFromBookingApi(String bookingId) async {
    currentBook = bookingId;
    final String bookingApiUrl = dotenv.get('bookingApiUrl');
    try {
      var response = await http.get(Uri.parse("$bookingApiUrl/$bookingId"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          });

      if (response.statusCode == 200) {
        dynamic responseBody = jsonDecode(response.body);

        List<dynamic> body = [responseBody];

        // Return  booking data
        return body;
      } else {
        debugPrint("empty");
        return [];
      }
    } catch (error) {
      // Handle any errors that occur during the API call
      debugPrint("Error: $error");
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    // Logic to determine font size and visibility based on screen width
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
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(
                        Icons.arrow_back_rounded,
                        color: darkBlueColor,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        'Trip Details',
                        style: GoogleFonts.montserrat(
                          fontWeight: mediumBoldWeight,
                          fontSize: 24,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Row(
            children: [
              Card(
                surfaceTintColor: transparent,
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: SizedBox(
                  height: 150,
                  width: 460,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 50,
                      ),
                      const Divider(
                        color: greyShade,
                        thickness: 1,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text(
                              "Invoice Date : ",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: mediumBoldWeight,
                              ),
                            ),
                          ),
                          Text(
                            DateFormat('dd MMM yyyy').format(
                              widget.invoiceDate,
                            ),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: normalWeight,
                            ),
                          ),
                        ],
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            children: [
                              Text(
                                "Due Date : ",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: mediumBoldWeight,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                DateFormat('dd MMM yyyy').format(
                                  widget.dueDate,
                                ),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: normalWeight,
                                ),
                              ),
                              const SizedBox(
                                width: 50,
                              ),
                              Text(
                                "Due in : ",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: mediumBoldWeight,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                "${widget.dueDate.difference(widget.invoiceDate).inDays} Days",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: normalWeight,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 40,
          ),
          InvoiceTripHeader(context, textFontSize),
          SizedBox(
            height: 350,
            child: ListView.builder(
              shrinkWrap: false,
              itemCount: widget.bookingIds.length,
              itemBuilder: (BuildContext context, int index) {
                return FutureBuilder(
                  future: fetchDataFromBookingApi(widget.bookingIds[index]),
                  builder: (context, snapshot) {
                    currentBook = widget.bookingIds[index];
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return SizedBox(
                        height: 30,
                        child: Shimmer.fromColors(
                          highlightColor: greyishWhiteColor,
                          baseColor: lightGrey,
                          child: ListView.builder(
                              itemCount: widget.bookingIds.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                  height: 50,
                                );
                              }),
                        ),
                      );
                    } else if (snapshot.hasError) {
                      // An error occurred while fetching data
                      return Text('Error: ${snapshot.error}');
                    } else if (!snapshot.hasData ||
                        (snapshot.data as List).isEmpty) {
                      // Data is not available
                      return const Text('No data available');
                    } else {
                      var bookingData = (snapshot.data)?.first;

                      return Column(
                        children: [
                          buildTripCard(
                              bookingData,
                              widget.invoiceDate,
                              textFontSize,
                              visiable,
                              context,
                              widget.bookingIds[index]),
                          const Divider(),
                        ],
                      );
                    }
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

Widget buildTripCard(
    bookingData, date, textFontSize, visiable, context, bookId) {
  final truckNo = bookingData['truckNo'];
  final loadingPoint = bookingData['loadingPointCity'];
  final unloadingPoint = bookingData['unloadingPointCity'];

  return SizedBox(
    height: 40,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: Center(
            child: Text(
              date != null ? DateFormat('dd/MM/yyyy').format(date) : 'NA',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: size_8,
                fontWeight: mediumBoldWeight,
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
            child: Text(
              "",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: size_8,
                fontWeight: mediumBoldWeight,
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
            child: Text(
              truckNo,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: size_8,
                fontWeight: mediumBoldWeight,
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
          flex: 5,
          child: Center(
              child: Text(
            "$unloadingPoint To $loadingPoint",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: black,
              fontSize: textFontSize,
              fontFamily: 'Montserrat',
            ),
          )),
        ),
        const VerticalDivider(
          color: greyShade,
          thickness: 1,
          width: 0,
        ),
        Expanded(
          flex: 3,
          child: Center(
            child: Text(
              '',
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              softWrap: false,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: black,
                fontSize: textFontSize,
                fontFamily: 'Montserrat',
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
            child: Text(
              '',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: textFontSize,
                  color: black,
                  fontFamily: 'Montserrat'),
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
            child: Text(
              '',
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              softWrap: false,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: black,
                fontSize: textFontSize,
                fontFamily: 'Montserrat',
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
            child: TextButton(
              child: Text(
                'Check POD',
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  fontSize: textFontSize - 2,
                  color: darkBlueColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () async {
                var docLinks = [];
                // Fetching document links for the given booking ID and document type "P"
                docLinks = await getDocumentApiCall(bookId.toString(), "P");
                if (docLinks.isNotEmpty) {
                  previewUploadedImage
                      .updatePreviewImage(docLinks[0].toString());

                  previewUploadedImage.updateIndex(0);

                  // Show POD in dialogue box
                  imageDownload(context, docLinks);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('No document uploaded.'),
                    ),
                  );
                }
              },
            ),
          ),
        ),
        const VerticalDivider(
          color: greyShade,
          thickness: 1,
          width: 0,
        ),
        const Expanded(
          flex: 3,
          child: Center(
            child: Text(
              '',
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              softWrap: false,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: black,
                fontFamily: 'Montserrat',
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
