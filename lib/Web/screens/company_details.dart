import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shipper_app/Web/screens/home_web.dart';
import 'package:shipper_app/Widgets/buttons/ConfirmButton.dart';
import 'package:shipper_app/Widgets/webHeader.dart';
import 'package:shipper_app/constants/colors.dart';
import 'package:shipper_app/constants/fontSize.dart';
import 'package:shipper_app/constants/radius.dart';
import 'package:shipper_app/controller/shipperIdController.dart';
import 'package:shipper_app/functions/alert_dialog.dart';
import 'package:shipper_app/functions/shipperApis/runShipperApiPost.dart';
import 'package:sizer/sizer.dart';

class CompanyDetails extends StatefulWidget {
  const CompanyDetails({Key? key}) : super(key: key);

  @override
  State<CompanyDetails> createState() => _CompanyDetailsState();
}

class _CompanyDetailsState extends State<CompanyDetails> {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? company;
  String? name;
  String? phone;
  ShipperIdController shipperIdController = Get.put(ShipperIdController());
  String? shipperId;
  TextEditingController companyNameController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  bool isError = false;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    width: screenWidth * 0.05,
                    height: screenHeight,
                    decoration: const BoxDecoration(
                        color: white,
                        image: DecorationImage(
                            fit: BoxFit.fill,
                            image: AssetImage(
                                "assets/images/WebCompanyDetails.png"))), // Replace with your desired color or widget
                  ),
                ),
                Expanded(
                  child: Container(
                    color: formBackground,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Form(
                          key: _formKey,
                          child: LayoutBuilder(builder: (context, constraints) {
                            // Here you can access the updated constraints
                            // and adjust your widget sizes accordingly.

                            double maxWidth = kIsWeb ? 55.w : 40.w;
                            double containerHeight = isError ? 50.h : screenHeight * 1;

                            return Container(
                              width: maxWidth,
                              height: containerHeight,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // TODO: Liveasy Logo
                                  const WebHeader(),
                                  Padding(
                                    padding: EdgeInsets.only(top: 7.h),
                                    child: Text("Company Details",
                                        style: GoogleFonts.montserrat(
                                          fontSize: screenHeight * 0.027,
                                          fontWeight: FontWeight.w500,
                                          color:darkBlueTextColor,
                                        )),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 1.5.h),
                                    child: Text(
                                        "Enter the company details to land into\nhomepage",
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.montserrat(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w400,
                                            color: greyShade)),
                                  ),

                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 10.w, top: 7.h, right: 7.w),
                                    child: Container(
                                      color: white,
                                      child: TextFormField(
                                        controller: nameController,
                                        autofocus: true,
                                        decoration: InputDecoration(
                                          suffixIcon: Transform.scale(
                                            scale: 1.5,
                                            child: const Image(
                                                image: AssetImage( "assets/images/UserRounded.png")),
                                          ),
                                          hintStyle: TextStyle(
                                              decorationColor: greyShade,
                                              fontSize: 2.h,
                                              color: hintTextColor),
                                          hintText: 'Name',
                                          contentPadding:
                                              EdgeInsets.only(left: 3.h),
                                          border: const OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5)),
                                          ),
                                        ),

                                        style: GoogleFonts.montserrat(
                                            color: black,
                                            fontWeight: FontWeight.w400,
                                            fontSize: screenHeight * 0.019),
                                      ),
                                    ),
                                  ),
                                  //Phone Field

                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 10.w, top: 6.h, right: 7.w),
                                    child: Container(
                                      color: white,
                                      child: TextFormField(
                                        controller: phoneController,
                                        keyboardType: TextInputType.phone,
                                        inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(10)
                                        ],
                                        autofocus: true,
                                        decoration: InputDecoration(
                                          suffixIcon: Transform.scale(
                                            scale: 1.5,
                                            child: const Image(
                                                image: AssetImage( "assets/images/PhoneRounded.png")),
                                          ),
                                          hintStyle: TextStyle(
                                              decorationColor: greyShade,
                                              fontSize: 2.h,
                                              color: hintTextColor),
                                          hintText: 'Phone Number',
                                          contentPadding:
                                              EdgeInsets.only(left: 3.h),
                                          border: const OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5)),
                                          ),
                                        ),
                                        style: GoogleFonts.montserrat(
                                          color: black,
                                          fontWeight: FontWeight.w400,
                                          fontSize: screenHeight * 0.019,
                                        ),
                                      ),
                                    ),
                                  ),

                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 10.w, top: 6.h, right: 7.w),
                                    child: Container(
                                      color: white,
                                      child: TextFormField(
                                        controller: companyNameController,
                                        autofocus: true,
                                        decoration: InputDecoration(
                                          suffixIcon: Transform.scale(
                                            scale: 1.5,
                                            child: const Image(
                                                image: AssetImage(
                                                    "assets/images/Buildings.png")),
                                          ),
                                          hintStyle: TextStyle(
                                              decorationColor: greyShade,
                                              fontSize: 2.h,
                                              color: hintTextColor),
                                          hintText: 'Company Details',
                                          contentPadding:
                                              EdgeInsets.only(left: 3.h),
                                          border: const OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5)),
                                          ),
                                        ),
                                        style: GoogleFonts.montserrat(
                                          color: black,
                                          fontWeight: FontWeight.w400,
                                          fontSize: screenHeight * 0.019,
                                        ),
                                      ),
                                    ),
                                  ),

                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 10.w, top: 6.h, right: 7.w),
                                    child: Container(
                                     
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                        color: darkBlueTextColor,
                                        borderRadius:
                                            BorderRadius.circular(radius_1),
                                      ),
                                      child: ConfirmButton(text: 'Confirm', 
                                      onPressed: () async {
                                          try {
                                            if (companyNameController.text.toString().isNotEmpty && nameController.text.toString().isNotEmpty) {
                                              updateDetails();
                                            } else {
                                              Fluttertoast.showToast(
                                                  msg: 'Enter details (Company Name and Name)',
                                                  fontSize: size_8,
                                                  backgroundColor: Colors.white,
                                                  textColor: Colors.black);
                                            }
                                          } catch (e) {
                                            log('Not updating--->$e');
                                          }
                                        },
                                      )
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  updateDetails() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    if (firebaseAuth.currentUser!.emailVerified) {
      firebaseAuth.currentUser!
          .updateDisplayName(nameController.text.toString());
      name = nameController.text.toString();
      company = companyNameController.text.toString();
      phone = phoneController.text.toString();
      try {
        String? id = await runShipperApiPost(
          emailId: firebaseAuth.currentUser!.email.toString(),
          shipperName: name,
          companyName: company,
          phoneNo: phone,
        );
        if (id != null) {
          log('Shipper id--->$id');
          if (!mounted) {
            log('In not mounted');
            return;
          }
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const HomeScreenWeb()));
        }
      } catch (e) {
        log('Not updating--->$e');
      }
    } else {
      alertDialog("Verify Email", "Verify your mail id to continue", context);
      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const LoginWeb()));
    }
  }
}
