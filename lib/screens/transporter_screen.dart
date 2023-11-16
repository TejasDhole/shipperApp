import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shipper_app/Widgets/addTransporterWidget.dart';
import 'package:shipper_app/Widgets/transporter_dialog.dart';
import 'package:shipper_app/Widgets/transporter_edit_dialog.dart';
import 'package:shipper_app/Widgets/transporter_header.dart';
import 'package:shipper_app/constants/colors.dart';
import 'package:shipper_app/constants/fontSize.dart';
import 'package:shipper_app/functions/shipperApis/TransporterListFromShipperApi.dart';
import 'package:shipper_app/models/transporterModel.dart';
import 'package:http/http.dart' as http;
import '../constants/spaces.dart';

class TransporterScreen extends StatefulWidget {
  const TransporterScreen({Key? key}) : super(key: key);

  @override
  State<TransporterScreen> createState() => _TransporterScreenState();
}

class _TransporterScreenState extends State<TransporterScreen> {
  var transporterList = [];
  var selectedTransporterList = [];
  bool setSelectedTransporterList = true;
  bool enableFinishButton = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTransporterListFromShipperApi();
  }

  getTransporterListFromShipperApi() async {
    await TransporterListFromShipperApi()
        .getTransporterListFromShipperApi(" ")
        .then((value) {
      setState(() {
        transporterList = [...value];
        setSelectedTransporterList = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            decoration: const BoxDecoration(color: teamBar),
            height: 90,
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Transporters',
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w500,
                    fontSize: 30,
                    color: darkBlueTextColor,
                  ),
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text(
                  "List of Transporter",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 7,
            padding: const EdgeInsets.all(8.0),
            margin: const EdgeInsets.only(top: 5, bottom: 5),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [kLiveasyColor, truckGreen]),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 1.0),
                child: SizedBox(
                  width: screenWidth * 0.3,
                  height: 45,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search',
                      hintStyle: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w400,
                        color: searchBar,
                      ),
                      border: const OutlineInputBorder(
                        borderSide: BorderSide(color: greyShade),
                        borderRadius: BorderRadius.all(Radius.zero),
                      ),
                      suffixIcon: const Icon(Icons.search),
                    ),
                    onChanged: (value) {
                      // Handle search functionality
                    },
                  ),
                ),
              ),
              SizedBox(
                width: screenWidth * 0.15,
                height: 65,
                child: Padding(
                  padding:
                      const EdgeInsets.only(right: 8.0, top: 8.0, bottom: 16.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      backgroundColor: truckGreen,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          'Add Transporter',
                          style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w600,
                            fontSize: size_8,
                          ),
                        ),
                      ],
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            backgroundColor: Colors.white,
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
                            elevation: 10,
                            content: addTransporters(context, transporterList),
                          );
                        },
                      ).then((value) => getTransporterListFromShipperApi());
                    },
                  ),
                ),
              ),
            ],
          ),
          TransporterHeader(context),
          Expanded(
            child: ListView.builder(
              itemCount: transporterList.length,
              itemBuilder: (context, index) {
                return Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(top: 10, right: 5),
                  padding: const EdgeInsets.all(10.0),
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: greyShade, width: 1),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 4,
                        child: Center(
                          child: Text(
                            transporterList[index][1],
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: kLiveasyColor,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Montserrat',
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: Center(
                          child: Text(
                            transporterList[index][2],
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: kLiveasyColor,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Montserrat',
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: Center(
                          child: Text(
                            transporterList[index][0],
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: kLiveasyColor,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Montserrat',
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: Center(
                          child: Text(
                            transporterList[index].length > 3 ? 'null' : 'NA',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: kLiveasyColor,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Montserrat',
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: Center(
                          child: Text(
                            transporterList[index].length > 3 ? 'null' : 'NA',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: kLiveasyColor,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Montserrat',
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: Center(
                          child: Text(
                            transporterList[index].length > 3 ? 'null' : 'NA',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: kLiveasyColor,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Montserrat',
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return TransporterEditDialog(); // Call TransporterWidget to show as a dialog
                            },
                          );
                        },
                        icon: const Icon(Icons.edit),
                        color: Colors.green, // Set the icon color
                      ),
                    ],
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
