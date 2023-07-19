import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shipper_app/screens/LoginScreens/LoginScreenUsingMail.dart';
import '/constants/colors.dart';
import '/constants/spaces.dart';
import '/controller/shipperIdController.dart';
import '/functions/shipperApis/runShipperApiPost.dart';

class SplashScreenToLoginScreen extends StatefulWidget {
  const SplashScreenToLoginScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreenToLoginScreen> createState() =>
      _SplashScreenToLoginScreenState();
}

class _SplashScreenToLoginScreenState extends State<SplashScreenToLoginScreen> {
  ShipperIdController shipperIdController =
      Get.put(ShipperIdController(), permanent: true);
  String? shipperId;

  @override
  void initState() {
    super.initState();
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [
    //   SystemUiOverlay.top,
    // ]);
    getData();
    Timer(const Duration(seconds: 2),
        () => Get.off(() => const LoginScreenUsingMail()));
  }

  getData() async {
    // print();
    // Fluttertoast.showToast(
    //   msg: "shipperIdController ${shipperIdController}",
    //   // toastLength: Toast.LENGTH_SHORT,
    //   gravity: ToastGravity.BOTTOM,
    //   timeInSecForIosWeb: 1,
    //   backgroundColor: Colors.black,
    //   textColor: Colors.white,
    // );

    bool? companyApproved;
    String? mobileNum;
    bool? accountVerificationInProgress;
    String? shipperLocation;
    String? name;
    String? companyName;
    String? companyStatus;

    if (shipperId != null) {
      print("shipperId is not null");
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
        print("shipper ID is null");
      } else {
        print("It is in else");
        shipperIdController.updateShipperId(shipperId!);
        shipperIdController.updateCompanyApproved(companyApproved!);
        shipperIdController.updateMobileNum(mobileNum!);
        shipperIdController.updateAccountVerificationInProgress(
            accountVerificationInProgress!);
        shipperIdController.updateShipperLocation(shipperLocation!);
        shipperIdController.updateName(name!);
        shipperIdController.updateCompanyName(companyName!);
        shipperIdController.updateCompanyStatus(companyStatus!);
        print("shipperID is $shipperId");
      }
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
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding:
                EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.05),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: black.withOpacity(0.26),
                        offset: const Offset(0, 16.22),
                        blurRadius: 12.96,
                      ),
                      BoxShadow(
                        color: black.withOpacity(0.21),
                        offset: const Offset(0, 8.62),
                        blurRadius: 6.89,
                      ),
                      BoxShadow(
                        color: black.withOpacity(0.15),
                        offset: const Offset(0, 3.59),
                        blurRadius: 6.89,
                      ),
                    ],
                  ),
                  child: Image(
                    width: screenWidth * 0.12,
                    height: screenHeight * 0.069,
                    fit: BoxFit.fill,
                    image: AssetImage("assets/icons/logoCompanyDetails.png"),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.05),
                  child: Text(
                    'Liveasy',
                    style: GoogleFonts.montserrat(
                      shadows: [
                        Shadow(
                            offset: const Offset(0, 8.55),
                            blurRadius: 10.35,
                            color: black.withOpacity(0.34)),
                        Shadow(
                            offset: const Offset(0, 4.79),
                            blurRadius: 5.8,
                            color: black.withOpacity(0.28)),
                        Shadow(
                            offset: const Offset(0, 2.55),
                            blurRadius: 3.08,
                            color: black.withOpacity(0.23)),
                        Shadow(
                            offset: const Offset(0, 1.06),
                            blurRadius: 1.28,
                            color: black.withOpacity(0.16))
                      ],
                      fontSize: screenHeight * 0.070,
                      fontWeight: FontWeight.w700,
                      color: white,
                    ),
                  ),
                )
              ],
            ),
          ),
          // Column(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          // const Image(
          //   image: AssetImage("assets/images/liveasyTruck.png"),
          // ),
          // SizedBox(height: space_2),
          // Container(
          //     child: Column(
          //   children: [
          // Image(
          //   image: const AssetImage("assets/images/SplashImage.png"),
          //   height: MediaQuery.of(context).size.height,
          //   width: MediaQuery.of(context).size.width,
          // ),
          // SizedBox(
          //   height: space_3,
          // )
          //   ],
          // ))
          //   ],
          // )
        )));
  }
}
