import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:shipper_app/Web/screens/home_web.dart';
import 'package:shipper_app/Widgets/invoice_details_dailog.dart';
import 'package:shipper_app/Widgets/invoice_header.dart';
import 'package:shipper_app/constants/colors.dart';
import 'package:shipper_app/constants/fontWeights.dart';
import 'package:shipper_app/constants/screens.dart';
import 'package:shipper_app/controller/shipperIdController.dart';
import 'package:shipper_app/functions/fetch_invoice_data.dart';
import 'package:shipper_app/screens/invoice_trip.dart';

class InvoiceScreen extends StatefulWidget {
  const InvoiceScreen({Key? key}) : super(key: key);

  @override
  State<InvoiceScreen> createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen> {
  var invoiceList = [];
  var selectedTransporterList = [];
  var displayedInvoiceList = [];
  int selectedDays = 100;
  bool visiable = true;
  DateTime from = DateTime(2000);
  DateTime to = DateTime.now();
  late Future<List<dynamic>> _invoicesFuture;
  @override
  void initState() {
    super.initState();
    _invoicesFuture = fetchInvoiceData();
  }

  // This function is used to fetch invoice data
  Future<List<dynamic>> fetchInvoiceData() async {
    ShipperIdController shipperIdController = Get.put(ShipperIdController());
    String companyId = shipperIdController.companyId.value;

    if (selectedDays == 100) {
      // Set 'from' date to 2000 if user select 'All Month' from dropdown
      from = DateTime(2000);
    } else {
      // Set 'from' date to the current date minus the selected number of days selected from dropdown
      from = DateTime.now().subtract(
        Duration(days: selectedDays, hours: 5, minutes: 30),
      );
    }

    try {
      // Call the ApiService to get invoice data within the specified date range
      List<dynamic> data = await ApiService.getInvoiceData(
        companyId,
        DateFormat('yyyy-MM-dd HH:mm:ss').format(from),
        DateFormat('yyyy-MM-dd HH:mm:ss').format(to),
      );
      setState(() {
        invoiceList = data;
        displayedInvoiceList = invoiceList;
      });

      // Return invoice data
      return data;
    } catch (e) {
      // Handle any errors that occur during the data fetching process
      debugPrint(e.toString());
      return [];
    }
  }

  // This functions filters the displayed invoice list based on the entered search text
  void filterInvoices(String searchText) {
    setState(() {
      displayedInvoiceList = invoiceList
          .where((invoice) =>
              (invoice['invoiceNo']
                      ?.toLowerCase()
                      .contains(searchText.toLowerCase()) ??
                  false) ||
              (invoice['invoiceDate']
                      ?.toLowerCase()
                      .contains(searchText.toLowerCase()) ??
                  false) ||
              (invoice['transporterName']
                      ?.toLowerCase()
                      .contains(searchText.toLowerCase()) ??
                  false) ||
              (invoice['invoiceId']
                      ?.toLowerCase()
                      .contains(searchText.toLowerCase()) ??
                  false))
          .toList();
    });
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
                child: Text(
                  'Invoice',
                  style: GoogleFonts.montserrat(
                    fontWeight: mediumBoldWeight,
                    fontSize: 24,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Container(
                  width: screenWidth * 0.3,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 5,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: TextField(
                    cursorWidth: 1,
                    mouseCursor: SystemMouseCursors.click,
                    decoration: InputDecoration(
                      hintText: 'Search by name, invoice no',
                      border: InputBorder.none,
                      hintStyle: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w400,
                        color: searchBar,
                      ),
                      prefixIcon: const Icon(Icons.search),
                    ),
                    onChanged: (value) {
                      // It filters the displayed invoice list based on the entered search text
                      filterInvoices(value);
                    },
                  ),
                ),
              ),
              // This dropdown is used to set 'from' date from the user
              Padding(
                padding: const EdgeInsets.all(30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 50.0, bottom: 20),
                      child: Text(
                        "Date ",
                        style: TextStyle(
                            color: black,
                            fontWeight: mediumBoldWeight,
                            fontSize: 20),
                      ),
                    ),
                    Container(
                      height: 55,
                      width: 115,
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
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<int>(
                            alignment: Alignment.center,
                            value: selectedDays,
                            style: const TextStyle(color: Colors.white),
                            icon: const Icon(Icons.arrow_drop_down,
                                color: Colors.black),
                            underline: const SizedBox(),
                            iconSize: 24,
                            isExpanded: true,
                            itemHeight: null,
                            items: [
                              DropdownMenuItem<int>(
                                value: 100,
                                child: Text(
                                  'All Months',
                                  style: TextStyle(
                                    fontWeight: mediumBoldWeight,
                                    color: black,
                                  ),
                                ),
                              ),
                              DropdownMenuItem<int>(
                                value: 3,
                                child: Text(
                                  '3 Days',
                                  style: TextStyle(
                                      fontWeight: mediumBoldWeight,
                                      color: black),
                                ),
                              ),
                              DropdownMenuItem<int>(
                                value: 7,
                                child: Text(
                                  '7 Days',
                                  style: TextStyle(
                                      fontWeight: mediumBoldWeight,
                                      color: black),
                                ),
                              ),
                              DropdownMenuItem<int>(
                                value: 10,
                                child: Text(
                                  '10 Days',
                                  style: TextStyle(
                                      fontWeight: mediumBoldWeight,
                                      color: black),
                                ),
                              ),
                              DropdownMenuItem<int>(
                                value: 14,
                                child: Text(
                                  '14 Days',
                                  style: TextStyle(
                                    fontWeight: mediumBoldWeight,
                                    color: black,
                                  ),
                                ),
                              ),
                              DropdownMenuItem<int>(
                                value: 21,
                                child: Text(
                                  '21 Days',
                                  style: TextStyle(
                                    fontWeight: mediumBoldWeight,
                                    color: black,
                                  ),
                                ),
                              ),
                              DropdownMenuItem<int>(
                                value: 30,
                                child: Text(
                                  '30 Days',
                                  style: TextStyle(
                                      fontWeight: mediumBoldWeight,
                                      color: black),
                                ),
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                selectedDays = value!;
                                from = selectedDays == 100
                                    ? DateTime(2000)
                                    : DateTime.now().subtract(
                                        Duration(
                                            days: selectedDays,
                                            hours: 5,
                                            minutes: 30),
                                      );
                                // Re-fetch the invoice data
                                _invoicesFuture = fetchInvoiceData();
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          InvoiceHeader(context, textFontSize),
          const SizedBox(
            height: 4,
          ),
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: _invoicesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // when data is loading
                  return ListView.builder(
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      return Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.white,
                        child: invoiceShimmerRow(
                            MediaQuery.of(context).size.width),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  // when there is error in fetching data
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                  // Data is not available
                  return const Center(
                    child: Text(
                      'No invoices found',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                } else {
                  return ListView.separated(
                    padding: const EdgeInsets.only(left: 5, right: 5),
                    separatorBuilder: (context, index) => const Divider(
                      color: greyShade,
                      thickness: 1,
                      height: 0,
                    ),
                    itemCount: displayedInvoiceList.length,
                    itemBuilder: (context, index) {
                      var invoice = displayedInvoiceList[index];
                      return GestureDetector(
                        // When user taps, it will redirect to Trip Details
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomeScreenWeb(
                                      visibleWidget: InvoiceTrip(
                                        bookingIds: (invoice['bookingId']
                                                    as List<dynamic>?)
                                                ?.map((id) => id.toString())
                                                .toList() ??
                                            [],
                                        invoiceDate: DateFormat('dd-MM-yyyy')
                                            .parse(invoice['invoiceDate']),
                                        dueDate: DateFormat('dd-MM-yyyy')
                                            .parse(invoice['dueDate']),
                                      ),
                                      index: 1000,
                                      selectedIndex:
                                          screens.indexOf(invoiceScreen),
                                    )),
                          );
                        },
                        child: Container(
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            invoice['invoiceDate'] != null
                                                ? "${invoice['invoiceDate'].substring(0, 2)}/${invoice['invoiceDate'].substring(3, 5)}/${invoice['invoiceDate'].substring(6)}"
                                                : ' ',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: black,
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            invoice['invoiceNo'] ?? ' ',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: black,
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            invoice['invoiceAmount'] ?? ' ',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: black,
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            invoice['transporterName'] ?? ' ',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: black,
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              invoice['dueDate'] != null
                                                  ? "${invoice['dueDate'].substring(0, 2)}/${invoice['dueDate'].substring(3, 5)}/${invoice['dueDate'].substring(6)}"
                                                  : ' ',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: black,
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            invoice['invoiceStatus'] ?? ' ',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: black,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                                                decoration:
                                                    TextDecoration.underline,
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
                                              return InvoiceDetails(
                                                invoiceId:
                                                    invoice['invoiceId'] ??
                                                        'NA',
                                              );
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
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget invoiceShimmerRow(double screenWidth) {
    // Adjust this method according to your shimmer design
    return Container(
      height: 70,
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: greyShade, width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(
          5, // Number of columns in your shimmer
          (index) => Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              color: Colors.grey[300],
            ),
          ),
        ),
      ),
    );
  }
}
