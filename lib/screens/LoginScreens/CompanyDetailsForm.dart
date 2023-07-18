import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shipper_app/screens/LoginScreens/LoginScreenUsingMail.dart';
import '../../functions/alert_dialog.dart';
import '/constants/colors.dart';
import '/constants/spaces.dart';
import '/constants/fontSize.dart';
import '/constants/elevation.dart';
import '/constants/radius.dart';
import '/screens/navigationScreen.dart';
import 'package:get/get.dart';
import '/controller/hudController.dart';
import '/controller/timerController.dart';
import '/controller/isOtpInvalidController.dart';
import '/functions/shipperApis/runShipperApiPost.dart';
import 'package:flutter/foundation.dart';
import '/controller/shipperIdController.dart';

class CompanyDetailsForm extends StatefulWidget {
  const CompanyDetailsForm({Key? key}) : super(key: key);

  @override
  State<CompanyDetailsForm> createState() => _CompanyDetailsFormState();
}

class _CompanyDetailsFormState extends State<CompanyDetailsForm> {
  // TextStyle textStyleForHeader =

  TimerController timerController = Get.put(TimerController());
  HudController hudController = Get.put(HudController());
  IsOtpInvalidController isOtpInvalidController =
      Get.put(IsOtpInvalidController());

  ShipperIdController shipperIdController = Get.put(ShipperIdController());
  String? shipperId;

  // String _verificationCode = '';

  TextEditingController companyNameController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController gstController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        resizeToAvoidBottomInset: true,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          //toolbarHeight: 50,
          backgroundColor: Color.fromARGB(255, 0, 0, 102),
          elevation: 0,

          title: Align(
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image(
                  width: MediaQuery.of(context).size.width * 0.07,
                  height: screenHeight * 0.032,
                  fit: BoxFit.fill,
                  image: AssetImage("assets/icons/logoCompanyDetails.png"),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.02),
                  child: Text(
                    'Liveasy',
                    style: GoogleFonts.montserrat(
                      fontSize: screenHeight * 0.027,
                      fontWeight: FontWeight.w700,
                      color: white,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        body: SafeArea(
            child: SingleChildScrollView(
          reverse: true,
          physics: NeverScrollableScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.center,
                child: Image(
                    fit: BoxFit.fill,
                    height: screenHeight * 0.42,
                    image: const AssetImage(
                        'assets/images/CompanyDetailsImage.png')),
              ),
              Container(
                margin: EdgeInsets.only(
                  left: space_4,
                  right: space_4,
                ),
                width: MediaQuery.of(context).size.width,
                // decoration: BoxDecoration(
                //   color: white,
                //   borderRadius: BorderRadius.horizontal(
                //     left: Radius.circular(radius_3),
                //     right: Radius.circular(radius_3),
                //   ),
                // ),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.001),
                      child: Text("Company Details",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.w500,
                              fontSize: screenHeight * 0.023,
                              color: Color.fromARGB(255, 21, 41, 104))),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                    Text("Enter the company details here to land into homepage",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: screenHeight * 0.017,
                            color: Color.fromARGB(255, 197, 195, 195))),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                    Padding(
                      padding: EdgeInsets.only(left: space_1, right: space_3),
                      child: SizedBox(
                        height: 46,
                        child: TextFormField(
                          keyboardType: TextInputType.name,
                          controller: nameController,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            suffixIcon: Transform.scale(
                              scale: 1.5,
                              child: const Image(
                                  image: AssetImage(
                                      "assets/images/UserRounded.png")),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: space_2, vertical: space_1),
                            filled: true,
                            fillColor: Colors.white,
                            enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Color.fromARGB(255, 197, 195, 195)),
                                borderRadius: BorderRadius.circular(radius_1)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Color.fromARGB(255, 197, 195, 195)),
                                borderRadius: BorderRadius.circular(radius_1)),
                            hintText: "Name",
                            hintStyle: GoogleFonts.montserrat(
                              color: black,
                              fontWeight: FontWeight.w500,
                              fontSize: screenHeight * 0.019,
                            ),
                            border: InputBorder.none,
                          ),
                          style: TextStyle(
                            color: black,
                            fontWeight: FontWeight.w400,
                            fontFamily: "Poppins",
                            fontSize: size_10,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                    Padding(
                      padding: EdgeInsets.only(left: space_1, right: space_3),
                      child: SizedBox(
                        height: 46,
                        child: TextFormField(
                          controller: phoneController,
                          keyboardType: TextInputType.phone,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(10)
                          ],
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            suffixIcon: Transform.scale(
                              scale: 1.5,
                              child: const Image(
                                  image: AssetImage(
                                      "assets/images/PhoneRounded.png")),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: space_2, vertical: space_1),
                            filled: true,
                            fillColor: Colors.white,
                            enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Color.fromARGB(255, 197, 195, 195)),
                                borderRadius: BorderRadius.circular(radius_1)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Color.fromARGB(255, 197, 195, 195)),
                                borderRadius: BorderRadius.circular(radius_1)),
                            hintText: "PhoneNumber",
                            hintStyle: GoogleFonts.montserrat(
                              color: black,
                              fontWeight: FontWeight.w500,
                              fontSize: screenHeight * 0.019,
                            ),
                            border: InputBorder.none,
                          ),
                          style: GoogleFonts.montserrat(
                            color: black,
                            fontWeight: FontWeight.w500,
                            fontSize: screenHeight * 0.019,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                    Padding(
                      padding: EdgeInsets.only(left: space_1, right: space_3),
                      child: SizedBox(
                        height: 46,
                        child: TextFormField(
                          controller: companyNameController,
                          textInputAction: TextInputAction.done,
                          decoration: InputDecoration(
                            suffixIcon: Transform.scale(
                              scale: 1.5,
                              child: const Image(
                                  image: AssetImage(
                                      "assets/images/Buildings.png")),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: space_2, vertical: space_1),
                            filled: true,
                            fillColor: Colors.white,
                            enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Color.fromARGB(255, 197, 195, 195)),
                                borderRadius: BorderRadius.circular(radius_1)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Color.fromARGB(255, 197, 195, 195)),
                                borderRadius: BorderRadius.circular(radius_1)),
                            hintText: "Company Name",
                            hintStyle: GoogleFonts.montserrat(
                              color: black,
                              fontWeight: FontWeight.w500,
                              fontSize: screenHeight * 0.019,
                            ),
                            border: InputBorder.none,
                          ),
                          style: GoogleFonts.montserrat(
                            color: black,
                            fontWeight: FontWeight.w500,
                            fontSize: screenHeight * 0.019,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                    Padding(
                      padding: EdgeInsets.only(
                        left: space_1,
                        right: space_3,
                      ),
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.053,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 21, 41, 104),
                          borderRadius: BorderRadius.circular(radius_1),
                        ),
                        child: ElevatedButton(
                          style: ButtonStyle(
                            elevation: MaterialStateProperty.resolveWith(
                                (states) => elevation_0),
                            backgroundColor: MaterialStateColor.resolveWith(
                                (states) => Colors.black.withOpacity(0.01)),
                          ),
                          onPressed: () {
                            if (companyNameController.text
                                    .toString()
                                    .isNotEmpty &&
                                nameController.text.toString().isNotEmpty) {
                              updateDetails();
                            } else {
                              Fluttertoast.showToast(
                                  msg: 'Enter details (Company Name and Name)',
                                  fontSize: size_8,
                                  backgroundColor: Colors.white,
                                  textColor: Colors.black);
                            }
                          },
                          child: Text(
                            "Confirm",
                            style: GoogleFonts.montserrat(
                                fontSize: screenHeight * 0.019,
                                color: Colors.white,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )));
  }

  updateDetails() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    if (firebaseAuth.currentUser!.emailVerified) {
      firebaseAuth.currentUser!
          .updateDisplayName(nameController.text.toString());
      String? id = await runShipperApiPost(
        emailId: firebaseAuth.currentUser!.email.toString(),
        shipperName: nameController.text.toString(),
        companyName: companyNameController.text.toString(),
        phoneNo: phoneController.text.toString(),
      );
      if (id != null) {
        log('Shipper id--->$id');
        if (!mounted) {
          log('In not mounted');
          return;
        }
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => NavigationScreen()));
      }
    } else {
      alertDialog("Verify Email", "Verify your mail id to continue", context);
      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const LoginWeb()));
    }
  }
}
