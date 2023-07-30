import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import '/screens/home.dart';
import '/constants/colors.dart';
import '/constants/spaces.dart';
import '/screens/navigationScreen.dart';
import 'package:get/get.dart';
import '/controller/shipperIdController.dart';
import '/functions/shipperApis/runShipperApiPost.dart';

class SplashScreenToHomePage extends StatefulWidget {
  const SplashScreenToHomePage({Key? key}) : super(key: key);

  @override
  State<SplashScreenToHomePage> createState() => _SplashScreenToHomePageState();
}

class _SplashScreenToHomePageState extends State<SplashScreenToHomePage> {
  ShipperIdController shipperIdController =
      Get.put(ShipperIdController(), permanent: true);
  String? shipperId;

  @override
  void initState() {
    super.initState();
    getData();
    Timer(Duration(seconds: 1), () => Get.off(() => NavigationScreen()));
  }

  getData() async {
    bool? companyApproved;
    String? mobileNum;
    bool? accountVerificationInProgress;
    String? shipperLocation;
    String? name;
    String? companyName;
    String? companyStatus;

    if (shipperId != null) {
      // setState(() {
      //   _nextScreen=true;
      // });
    } else {
      setState(() {
        shipperId = sidstorage.read("shipperId");
        companyApproved = sidstorage.read("companyApproved");
        mobileNum = sidstorage.read("mobileNum");
        accountVerificationInProgress =
            sidstorage.read("accountVerificationInProgress");
        shipperLocation = sidstorage.read("shipperLocation");
        name = sidstorage.read("name");
        companyName = sidstorage.read("companyName");
        companyStatus = sidstorage.read("companyStatus");
      });

      if (shipperId == null) {
        print("Shipper ID is null");
      } else {
        print("It is in else");
        shipperIdController.updateShipperId(shipperId!);
        shipperIdController.updateCompanyApproved(companyApproved!);
        shipperIdController.updateCompanyStatus(companyStatus!);
        shipperIdController.updateMobileNum(mobileNum!);
        shipperIdController.updateAccountVerificationInProgress(
            accountVerificationInProgress!);
        shipperIdController.updateShipperLocation(shipperLocation!);
        shipperIdController.updateName(name!);
        shipperIdController.updateCompanyName(companyName!);
        print("shipperId is $shipperId");
        // setState(() {
        //   _nextScreen=true;
        // });
      }
      //setState(() {
      //_nextScreen=true;
      //});
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: statusBarColor,
      body: SafeArea(
          child: Container(
        height: screenHeight,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/SplashImage.png"),
            fit: BoxFit.fill,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image(
              width: screenWidth * 0.14,
              height: screenHeight * 0.069,
              fit: BoxFit.fill,
              image: AssetImage("assets/icons/logoCompanyDetails.png"),
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.05),
              child: Text(
                'Liveasy',
                style: GoogleFonts.montserrat(
                  fontSize: screenHeight * 0.070,
                  fontWeight: FontWeight.w700,
                  color: white,
                ),
              ),
            )
          ],
        ),
      )),
    );
  }
}
