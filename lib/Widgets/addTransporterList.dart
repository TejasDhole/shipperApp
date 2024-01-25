import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:shipper_app/Widgets/showSnackBarTop.dart';
import 'package:shipper_app/constants/colors.dart';
import 'package:shipper_app/constants/fontSize.dart';
import 'package:shipper_app/constants/fontWeights.dart';
import 'package:shipper_app/controller/addLocationDrawerToggleController.dart';
import 'package:shipper_app/controller/transporterController.dart';
import 'package:shipper_app/functions/shipperApis/TransporterListFromShipperApi.dart';
import 'package:shipper_app/functions/shipperApis/updateShipperTransporterList.dart';
import 'package:shipper_app/functions/transporterApis/getTransporterIdByPhone.dart';

class AddTransporterList extends StatefulWidget {
  const AddTransporterList({super.key});

  @override
  State<AddTransporterList> createState() => _AddTransporterListState();
}

class _AddTransporterListState extends State<AddTransporterList> {
  TransporterController transporterController =
      Get.put(TransporterController());
  TransporterListFromCompany transporterListFromCompany =
      TransporterListFromCompany();
  AddLocationDrawerToggleController addLocationDrawerToggleController =
      Get.put(AddLocationDrawerToggleController());
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneNoController = TextEditingController();
  TextEditingController emailIdController = TextEditingController();
  TextEditingController gstNoController = TextEditingController();
  TextEditingController vendorCodeController = TextEditingController();
  TextEditingController panNoController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      surfaceTintColor: Colors.transparent,
      content: Container(
        color: white,
        width: MediaQuery.of(context).size.width * 0.7,
        height: MediaQuery.of(context).size.height * 0.8,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              color: white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    transporterController.create.value == true
                        ? 'Transporter Details'
                        : 'Edit Details',
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: size_10,
                        color: darkBlueColor,
                        fontWeight: mediumBoldWeight),
                  ),
                  IconButton(
                      onPressed: () {
                        transporterController.updateName('');
                        transporterController.updateEmailId('');
                        transporterController.updatePhoneNo('');
                        transporterController.updateGstNo('');
                        transporterController.updateVendorCode('');
                        transporterController.updatePanNo('');
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(
                        Icons.close,
                      ))
                ],
              ),
            ),
            const Divider(
              color: grey,
              thickness: 0.5,
              height: 0,
            ),
            Container(
              padding: const EdgeInsets.only(top: 50, left: 20, right: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 22),
                            child: SizedBox(
                                width: 320,
                                height: 70,
                                child: Obx(() {
                                  // Update the Name TextField based on the value in transporterController.
                                  if (transporterController.name.value != '') {
                                    nameController.text =
                                        transporterController.name.value;
                                  } else {
                                    nameController.clear();
                                  }
                                  nameController.moveCursorToEnd();
                                  return TextField(
                                    textAlign: TextAlign.start,
                                    controller: nameController,
                                    onChanged: (value) {
                                      // Update the name value in transporterController on change.
                                      transporterController
                                          .updateName(nameController.text);
                                    },
                                    decoration: InputDecoration(
                                      hintText: 'Enter Transporter Name',
                                      border: OutlineInputBorder(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(5)),
                                          borderSide: BorderSide(
                                              color: borderLightColor,
                                              width: 0.5)),
                                      focusedBorder: const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5)),
                                          borderSide: BorderSide(
                                              color: black, width: 0.5)),
                                      hintStyle: TextStyle(
                                          color: borderLightColor,
                                          fontFamily: 'Montserrat',
                                          fontWeight: regularWeight,
                                          fontSize: size_8),
                                    ),
                                  );
                                })),
                          ),
                          // Positioned container displaying the label for the Name
                          Positioned(
                            top: 7,
                            left: 15,
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                              color: white,
                              child: Row(
                                children: [
                                  Text(
                                    'Transporter Name',
                                    style: TextStyle(
                                        backgroundColor: white,
                                        color: darkBlueColor,
                                        fontSize: size_9,
                                        fontWeight: regularWeight),
                                  ),
                                  const Text(
                                    "*",
                                    style: TextStyle(
                                      color: declineButtonRed,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 22),
                            child: SizedBox(
                                width: 320,
                                height: 70,
                                child: Obx(
                                  // Update the Phone no. TextField based on the value in transporterController.
                                  () {
                                    if (transporterController.phoneNo.value !=
                                        '') {
                                      phoneNoController.text =
                                          transporterController.phoneNo.value;
                                    } else {
                                      phoneNoController.clear();
                                    }
                                    phoneNoController.moveCursorToEnd();
                                    return TextField(
                                      textAlign: TextAlign.start,
                                      controller: phoneNoController,
                                      // User cannot change the phone number when they edit details
                                      enabled:
                                          transporterController.create.value ==
                                                  true
                                              ? true
                                              : false,
                                      onChanged: (value) {
                                        // Update the phone value in transporterController on change.
                                        transporterController.updatePhoneNo(
                                            phoneNoController.text);
                                      },
                                      decoration: InputDecoration(
                                        hintText: 'Enter Contact Number',
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(5)),
                                            borderSide: BorderSide(
                                                color: borderLightColor,
                                                width: 0.5)),
                                        focusedBorder: const OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5)),
                                            borderSide: BorderSide(
                                                color: black, width: 0.5)),
                                        hintStyle: TextStyle(
                                            color: borderLightColor,
                                            fontFamily: 'Montserrat',
                                            fontWeight: regularWeight,
                                            fontSize: size_8),
                                      ),
                                    );
                                  },
                                )),
                          ),
                          // Positioned container displaying the label for the phone no.
                          Positioned(
                            top: 7,
                            left: 15,
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                              color: white,
                              child: Row(
                                children: [
                                  Text(
                                    'Contact Number',
                                    style: TextStyle(
                                        backgroundColor: white,
                                        color: darkBlueColor,
                                        fontSize: size_9,
                                        fontWeight: regularWeight),
                                  ),
                                  const Text(
                                    "*",
                                    style: TextStyle(
                                      color: declineButtonRed,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 22),
                            child: SizedBox(
                                width: 320,
                                height: 70,
                                child: Obx(() {
                                  // Update the Email id TextField based on the value in transporterController.
                                  if (transporterController.emailId.value !=
                                      '') {
                                    emailIdController.text =
                                        transporterController.emailId.value;
                                  } else {
                                    emailIdController.clear();
                                  }
                                  emailIdController.moveCursorToEnd();
                                  return TextField(
                                    textAlign: TextAlign.start,
                                    // User cannot change email id when they edit details
                                    enabled:
                                        transporterController.create.value ==
                                                true
                                            ? true
                                            : false,
                                    controller: emailIdController,
                                    onChanged: (value) {
                                      // Update the email id value in transporterController on change.
                                      transporterController.updateEmailId(
                                          emailIdController.text);
                                    },
                                    decoration: InputDecoration(
                                      hintText: 'Enter Email id',
                                      border: OutlineInputBorder(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(5)),
                                          borderSide: BorderSide(
                                              color: borderLightColor,
                                              width: 0.5)),
                                      focusedBorder: const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5)),
                                          borderSide: BorderSide(
                                              color: black, width: 0.5)),
                                      hintStyle: TextStyle(
                                          color: borderLightColor,
                                          fontFamily: 'Montserrat',
                                          fontWeight: regularWeight,
                                          fontSize: size_8),
                                    ),
                                  );
                                })),
                          ),
                          // Positioned container displaying the label for the Email id
                          Positioned(
                            top: 7,
                            left: 15,
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                              color: white,
                              child: Row(
                                children: [
                                  Text(
                                    'Email id',
                                    style: TextStyle(
                                        backgroundColor: white,
                                        color: darkBlueColor,
                                        fontSize: size_9,
                                        fontWeight: regularWeight),
                                  ),
                                  const Text(
                                    "*",
                                    style: TextStyle(
                                      color: declineButtonRed,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 22),
                            child: SizedBox(
                                width: 320,
                                height: 70,
                                child: Obx(
                                  // Update the PAN no. TextField based on the value in transporterController.
                                  () {
                                    if (transporterController.panNo.value !=
                                        '') {
                                      panNoController.text =
                                          transporterController.panNo.value;
                                    } else {
                                      panNoController.clear();
                                    }
                                    panNoController.moveCursorToEnd();
                                    return TextField(
                                      textAlign: TextAlign.start,
                                      controller: panNoController,
                                      onChanged: (value) {
                                        // Update the PAN no. value in transporterController on change.
                                        transporterController
                                            .updatePanNo(panNoController.text);
                                      },
                                      decoration: InputDecoration(
                                        hintText: 'Enter Pan Number',
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(5)),
                                            borderSide: BorderSide(
                                                color: borderLightColor,
                                                width: 0.5)),
                                        focusedBorder: const OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5)),
                                            borderSide: BorderSide(
                                                color: black, width: 0.5)),
                                        hintStyle: TextStyle(
                                            color: borderLightColor,
                                            fontFamily: 'Montserrat',
                                            fontWeight: regularWeight,
                                            fontSize: size_8),
                                      ),
                                    );
                                  },
                                )),
                          ),
                          // Positioned container displaying the label for the PAN no.
                          Positioned(
                            top: 7,
                            left: 15,
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                              color: white,
                              child: Text(
                                'Pan Number',
                                style: TextStyle(
                                    backgroundColor: white,
                                    color: darkBlueColor,
                                    fontSize: size_9,
                                    fontWeight: regularWeight),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 22),
                            child: SizedBox(
                                width: 320,
                                height: 70,
                                child: Obx(
                                  // Update the GST NO. TextField based on the value in transporterController.
                                  () {
                                    if (transporterController.gstNo.value !=
                                        '') {
                                      gstNoController.text =
                                          transporterController.gstNo.value;
                                    } else {
                                      gstNoController.clear();
                                    }
                                    gstNoController.moveCursorToEnd();
                                    return TextField(
                                      textAlign: TextAlign.start,
                                      controller: gstNoController,
                                      onChanged: (value) {
                                        // Update the GST no. value in transporterController on change.
                                        transporterController
                                            .updateGstNo(gstNoController.text);
                                      },
                                      decoration: InputDecoration(
                                        hintText: 'Enter GST Number',
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(5)),
                                            borderSide: BorderSide(
                                                color: borderLightColor,
                                                width: 0.5)),
                                        focusedBorder: const OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5)),
                                            borderSide: BorderSide(
                                                color: black, width: 0.5)),
                                        hintStyle: TextStyle(
                                            color: borderLightColor,
                                            fontFamily: 'Montserrat',
                                            fontWeight: regularWeight,
                                            fontSize: size_8),
                                      ),
                                    );
                                  },
                                )),
                          ),
                          // Positioned container displaying the label for the GST NO.
                          Positioned(
                            top: 7,
                            left: 15,
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                              color: white,
                              child: Text(
                                'GST Number',
                                style: TextStyle(
                                    backgroundColor: white,
                                    color: darkBlueColor,
                                    fontSize: size_9,
                                    fontWeight: regularWeight),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 22),
                            child: SizedBox(
                                width: 320,
                                height: 70,
                                child: Obx(
                                  // Update the vendor code TextField based on the value in transporterController.
                                  () {
                                    if (transporterController
                                            .vendorCode.value !=
                                        '') {
                                      vendorCodeController.text =
                                          transporterController
                                              .vendorCode.value;
                                    } else {
                                      vendorCodeController.clear();
                                    }
                                    vendorCodeController.moveCursorToEnd();
                                    return TextField(
                                      textAlign: TextAlign.start,
                                      controller: vendorCodeController,
                                      onChanged: (value) {
                                        // Update the vendor code value in transporterController on change.
                                        transporterController.updateVendorCode(
                                            vendorCodeController.text);
                                      },
                                      decoration: InputDecoration(
                                        hintText: 'Enter Vendor Number',
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(5)),
                                            borderSide: BorderSide(
                                                color: borderLightColor,
                                                width: 0.5)),
                                        focusedBorder: const OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5)),
                                            borderSide: BorderSide(
                                                color: black, width: 0.5)),
                                        hintStyle: TextStyle(
                                            color: borderLightColor,
                                            fontFamily: 'Montserrat',
                                            fontWeight: regularWeight,
                                            fontSize: size_8),
                                      ),
                                    );
                                  },
                                )),
                          ),
                          // Positioned container displaying the label for the vendor code
                          Positioned(
                            top: 7,
                            left: 15,
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                              color: white,
                              child: Text(
                                'Vendor Number',
                                style: TextStyle(
                                    backgroundColor: white,
                                    color: darkBlueColor,
                                    fontSize: size_9,
                                    fontWeight: regularWeight),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                          width: 200,
                          height: 60,
                          child: ElevatedButton(
                              onPressed: () {
                                // Validation checks for transporter information.
                                if (transporterController.name.isEmpty) {
                                  showSnackBar(
                                      'Enter Name !!!',
                                      deleteButtonColor,
                                      const Icon(Icons.warning),
                                      context);
                                } else if (transporterController
                                    .phoneNo.isEmpty) {
                                  showSnackBar(
                                      'Enter Contact !!!',
                                      deleteButtonColor,
                                      const Icon(Icons.warning),
                                      context);
                                } else if (transporterController
                                    .emailId.isEmpty) {
                                  showSnackBar(
                                      'Enter Email id !!!',
                                      deleteButtonColor,
                                      const Icon(Icons.warning),
                                      context);
                                } else if ((!RegExp(
                                            r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$')
                                        .hasMatch(transporterController
                                            .emailId.value)) &&
                                    transporterController.create.value ==
                                        true) {
                                  showSnackBar(
                                      'Enter a valid Email id !!!',
                                      deleteButtonColor,
                                      const Icon(Icons.warning),
                                      context);
                                } else if ((!RegExp(r'^[0-9]{10}$').hasMatch(
                                        transporterController.phoneNo.value)) &&
                                    transporterController.create.value ==
                                        true) {
                                  showSnackBar(
                                      'Enter a valid 10-digit Phone Number !!!',
                                      deleteButtonColor,
                                      const Icon(Icons.warning),
                                      context);
                                } else {
                                  try {
                                    // Extracting information from various controllers.
                                    String name = nameController.text;
                                    String phone = phoneNoController.text;
                                    String emailId = emailIdController.text;
                                    String gst = gstNoController.text;
                                    String pan = panNoController.text;
                                    String vendor = vendorCodeController.text;
                                    // Check if essential fields are not empty.
                                    // if (name.isNotEmpty &&
                                    //     name != null &&
                                    //     phone.isNotEmpty &&
                                    //     phone != null) {

                                    if (transporterController.create.value ==
                                        true) {
                                      // Creates a transporter add transporter id in transporter list
                                      getTransporterIdByPhone(phone, emailId,
                                              name, gst, pan, vendor)
                                          .then((transporterId) {
                                        updateCompanyTransporterList(
                                            transporterId, context);
                                      });
                                    } else {
                                      // Update transporter list when editing.
                                      transporterListFromCompany
                                          .updateTransporterList(
                                        transporterController.id.value,
                                      );
                                      showSnackBar(
                                          "Transporter edited Successfully!!",
                                          truckGreen,
                                          const Icon(Icons
                                              .check_circle_outline_outlined),
                                          context);
                                    }
                                    // } else {
                                    //   // Show an error if essential fields are empty.

                                    //   showSnackBar(
                                    //       'Something went Wrong, Try again Later!!!',
                                    //       deleteButtonColor,
                                    //       const Icon(Icons.warning),
                                    //       context);
                                    // }
                                    // Reset controller values and perform other cleanup actions.
                                    transporterController.updateName('');
                                    transporterController.updateEmailId('');
                                    transporterController.updatePhoneNo('');
                                    transporterController.updateGstNo('');
                                    transporterController.updateVendorCode('');
                                    transporterController.updatePanNo('');
                                    addLocationDrawerToggleController
                                        .updateSearchTransporterText("");
                                    Future.delayed(const Duration(seconds: 1),
                                        () {
                                      Navigator.of(context).pop();
                                    });
                                  } catch (error) {
                                    // Handle and show error in case of exceptions.
                                    debugPrint(error.toString());
                                    showSnackBar(
                                        error.toString(),
                                        deleteButtonColor,
                                        const Icon(
                                            Icons.report_gmailerrorred_sharp),
                                        context);
                                  }
                                }
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        liveasyGreen),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                              child: Text(
                                // Display appropriate text based on whether add or edit screen.
                                transporterController.create.value == true
                                    ? "Add Transporter"
                                    : "Save Changes",
                                style: TextStyle(
                                    color: white,
                                    fontSize: size_10,
                                    fontWeight: normalWeight),
                              ))),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
