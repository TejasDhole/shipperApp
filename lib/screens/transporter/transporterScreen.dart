import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:shipper_app/Widgets/addTransporterList.dart';
import 'package:shipper_app/constants/colors.dart';
import 'package:shipper_app/constants/fontSize.dart';
import 'package:shipper_app/constants/fontWeights.dart';
import 'package:shipper_app/constants/radius.dart';
import 'package:shipper_app/constants/spaces.dart';
import 'package:shipper_app/controller/addLocationDrawerToggleController.dart';
import 'package:shipper_app/controller/transporterController.dart';
import 'package:shipper_app/functions/shipperApis/TransporterListFromShipperApi.dart';
import 'package:shipper_app/functions/shipperApis/removeTransporterId.dart';
import 'package:shipper_app/models/popup_model_for_transporter.dart';
import 'package:shipper_app/screens/transporter/transporterListheader.dart';

class TransporterScreen extends StatefulWidget {
  const TransporterScreen({super.key});

  @override
  State<TransporterScreen> createState() => _TransporterScreenState();
}

class _TransporterScreenState extends State<TransporterScreen> {
  var transporterList = [];
  var displayedTransporterList = [];
  TransporterController transporterController =
      Get.put(TransporterController());
  TransporterListFromCompany transporterListFromCompany =
      TransporterListFromCompany();
  AddLocationDrawerToggleController addLocationDrawerToggleController =
      Get.put(AddLocationDrawerToggleController());

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    // Logic to determine font size and visibility based on screen width
    bool small = true;
    double textFontSize;

    if (screenWidth < 1160) {
      small = true;
    } else {
      small = false;
    }

    if (small) {
      textFontSize = 14;
    } else {
      textFontSize = 18;
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20, bottom: 10, top: 50),
          child: Align(
            alignment: Alignment.topLeft,
            child: Text(
              "Transporter",
              style: TextStyle(
                fontSize: size_15 + 2,
                color: black,
                fontWeight: mediumBoldWeight,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                child: Container(
                  width: screenWidth * 0.4,
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
                    style: TextStyle(color: black, fontSize: size_8),
                    onChanged: (value) {
                      // It filters the displayed transporter list based on the entered search text
                      addLocationDrawerToggleController
                          .updateSearchTransporterText(value);
                    },
                    cursorColor: kLiveasyColor,
                    cursorWidth: 1,
                    mouseCursor: SystemMouseCursors.click,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: '    Search by name,gst no.,vendor code',
                      hintStyle:
                          TextStyle(color: borderLightColor, fontSize: size_8),
                      prefixIcon: Icon(
                        Icons.search,
                        color: borderLightColor,
                      ),
                    ),
                  ),
                ),
              ),
              // This button is used to add transporter in this List
              ElevatedButton(
                  onPressed: () {
                    // Update the transporterController with new information
                    transporterController.updateName('Liveasy');
                    transporterController.updateEmailId('');
                    transporterController.updatePhoneNo('');
                    transporterController.updateGstNo('');
                    transporterController.updateVendorCode('');
                    transporterController.updatePanNo('');
                    transporterController.updateCreate(true);
                    // Show a dialog to add transporter information
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AddTransporterList();
                      },
                    );
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                    side: MaterialStateProperty.all(
                        const BorderSide(color: kLiveasyColor, width: 2.0)),
                    minimumSize: MaterialStateProperty.all(
                        Size(screenWidth * 0.175, 50)),
                  ),
                  child: const Text(
                    "+  Add Transporter",
                    style: TextStyle(color: kLiveasyColor, fontSize: 18),
                  ))
            ],
          ),
        ),
        transporterHeader(context),
        Expanded(child: Obx(() {
          return FutureBuilder(
            future: transporterListFromCompany.getTransporterListUsingCompanyId(
                addLocationDrawerToggleController.searchTransporterText.value),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // when data is loading
                return ListView.builder(
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.white,
                      child: transporterShimmerRow(
                          MediaQuery.of(context).size.width),
                    );
                  },
                );
              } else if (snapshot.hasError) {
                // when there is error in fetching data
                return Center(
                    child: Text(
                  'Error: ${snapshot.error}',
                ));
              } else if (snapshot.hasData) {
                // It displays list of transporters
                List data = snapshot.data!;
                return ListView.separated(
                  separatorBuilder: (context, index) {
                    return const Divider(
                      color: greyShade,
                      thickness: 1,
                      height: 0,
                    );
                  },
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return TransporterData(
                      name: data[index][1],
                      phoneNo: data[index][2],
                      emailId: data[index][0],
                      gstNumber: data[index][5],
                      vendorCode: data[index][6],
                      panNumber: data[index][4],
                      id: data[index][3].toString(),
                    );
                  },
                );
              } else {
                // Data is not available
                return const Center(child: Text('No Transporter available'));
              }
            },
          );
        })),
      ],
    );
  }

// This function to create a container displaying transporter data
  Container TransporterData(
      {required final String name,
      required final String phoneNo,
      required final String emailId,
      required final String gstNumber,
      required final String vendorCode,
      required final String panNumber,
      required final String id}) {
    return Container(
      height: 90,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Center(
              child: Text(
                name,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: black,
                  fontSize: size_9,
                  fontWeight: normalWeight,
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
              child: Text(
                phoneNo,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: black,
                  fontSize: size_9,
                  fontWeight: normalWeight,
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
              child: Text(
                emailId,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: black,
                  fontSize: size_9,
                  fontWeight: normalWeight,
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
                gstNumber,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: black,
                  fontSize: size_8,
                  fontWeight: normalWeight,
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
              child: Text(
                panNumber,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: black,
                  fontSize: size_8,
                  fontWeight: normalWeight,
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Text(
                    vendorCode,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: black,
                      fontSize: size_8,
                      fontWeight: normalWeight,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Center(
                    child: PopupMenuButton<PopUpMenuForTransporter>(
                      offset: Offset(0, space_2),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.all(Radius.circular(radius_2)),
                      ),
                      onSelected: (item) => onSelect(context, item, id, name,
                          phoneNo, emailId, gstNumber, vendorCode, panNumber),
                      itemBuilder: (context) => [
                        ...MenuItemTransporter.listItem
                            .map(showEachItem)
                            .toList(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void onSelect(
      BuildContext context,
      PopUpMenuForTransporter item,
      String id,
      String name,
      String phoneNo,
      String emailId,
      String gstNumber,
      String vendorCode,
      String panNumber) {
    switch (item) {
      // Edit option selected: Update transporterController with details and show edit dialog
      case MenuItemTransporter.editText:
        transporterController.updateName(name);
        transporterController.updateEmailId(emailId);
        transporterController.updatePhoneNo(phoneNo);
        transporterController.updateGstNo(gstNumber);
        transporterController.updateVendorCode(vendorCode);
        transporterController.updatePanNo(panNumber);
        transporterController.updateCreate(false);
        transporterController.updateId(id);
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AddTransporterList();
          },
        );
        break;
      // Delete option selected: Delete transporter from the list
      case MenuItemTransporter.deleteText:
        transporterListFromCompany.deleteTransporter(id).then((bool state) {
          setState(() {});
        });
        removeTransporterList(id, context);
        break;
    }
  }

  Widget transporterShimmerRow(double screenWidth) {
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

// Function to create a PopupMenuItem for each item in the PopUpMenuForTransporter enum
  PopupMenuItem<PopUpMenuForTransporter> showEachItem(
          PopUpMenuForTransporter item) =>
      PopupMenuItem<PopUpMenuForTransporter>(
        value: item,
        child: Column(
          children: [
            // Display each item with an icon and text
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Icon(
                    item.icon,
                    color: item.color,
                  ),
                ),
                Text(
                  item.text,
                  style: TextStyle(
                    fontWeight: mediumBoldWeight,
                    color: item.color,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
}
