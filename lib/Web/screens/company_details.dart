import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shipper_app/Web/screens/home_web.dart';
import 'package:shipper_app/constants/colors.dart';
import 'package:shipper_app/functions/alert_dialog.dart';

import '../../constants/colors.dart';
import '../../constants/elevation.dart';
import '../../constants/fontSize.dart';
import '../../constants/radius.dart';
import '../../constants/spaces.dart';
import '../../controller/hudController.dart';
import '../../controller/isOtpInvalidController.dart';
import '../../controller/shipperIdController.dart';
import '../../controller/timerController.dart';
import '../../functions/shipperApis/runShipperApiPost.dart';
import '/Widgets/liveasy_Icon_Widgets.dart';
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
                    // padding: EdgeInsets.symmetric(
                    //     vertical: MediaQuery.of(context).size.height * 0.02),
                    //color: Colors.blueGrey,
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
                    color: Color.fromARGB(255, 245, 246, 250),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Form(
                          key: _formKey,
                          child: Container(
                            width: kIsWeb ? 55.w : 40.w,
                            height: isError
                                ? 50.h
                                : MediaQuery.of(context).size.height * 1,
                            
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // TODO: Liveasy Logo
                                Center(
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 7.h),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Image(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.02,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.02,
                                            image: AssetImage(
                                                "assets/images/logoWebLogin.png")),
                                        Padding(
                                          padding: EdgeInsets.only(left: 1.w),
                                          child: Text(
                                            "Liveasy",
                                            style: GoogleFonts.montserrat(
                                              fontSize: 28,
                                              fontWeight: FontWeight.w700,
                                              color: Color.fromARGB(
                                                  255, 21, 41, 104),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 7.h),
                                  child: Text("Company Details",
                                      style: GoogleFonts.montserrat(
                                        fontSize: screenHeight * 0.027,
                                        fontWeight: FontWeight.w500,
                                        color: Color.fromARGB(255, 21, 41, 104),
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
                                          color: Color.fromARGB(
                                              255, 197, 195, 195))),
                                ),

                                Padding(
                                  padding: EdgeInsets.only(
                                      left: 10.w, top: 7.h, right: 7.w),
                                  child: Container(
                                    color: white,
                                    child: TextFormField(
                                      controller: nameController,
                                      autofocus: true,
                                      // autofillHints: ,
                                      decoration: InputDecoration(
                                        suffixIcon: Transform.scale(
                                          scale: 1.5,
                                          child: const Image(
                                              image: AssetImage(
                                                  "assets/images/UserRounded.png")),
                                        ),
                                        hintStyle: TextStyle(
                                            decorationColor: Color.fromARGB(
                                                255, 197, 195, 195),
                                            fontSize: 2.h,
                                            color: Color.fromARGB(
                                                255, 217, 217, 217)),
                                        hintText: 'Name',
                                        //labelText: 'Email Id',
                                        contentPadding:
                                            EdgeInsets.only(left: 3.h),
                                        border: OutlineInputBorder(
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
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                        LengthLimitingTextInputFormatter(10)
                                      ],
                                      autofocus: true,
                                      decoration: InputDecoration(
                                        suffixIcon: Transform.scale(
                                          scale: 1.5,
                                          child: const Image(
                                              image: AssetImage(
                                                  "assets/images/PhoneRounded.png")),
                                        ),
                                        hintStyle: TextStyle(
                                            decorationColor: Color.fromARGB(
                                                255, 197, 195, 195),
                                            fontSize: 2.h,
                                            color: Color.fromARGB(
                                                255, 217, 217, 217)),
                                        hintText: 'Phone Number',
                                        contentPadding:
                                            EdgeInsets.only(left: 3.h),
                                        border: OutlineInputBorder(
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
                                            decorationColor: Color.fromARGB(
                                                255, 197, 195, 195),
                                            fontSize: 2.h,
                                            color: Color.fromARGB(
                                                255, 217, 217, 217)),
                                        hintText: 'Company Details',
                                        contentPadding:
                                            EdgeInsets.only(left: 3.h),
                                        border: OutlineInputBorder(
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
                                    // height: MediaQuery.of(context).size.height *
                                    //     0.053,
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                      color: Color.fromARGB(255, 21, 41, 104),
                                      borderRadius:
                                          BorderRadius.circular(radius_1),
                                    ),
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        
                                        backgroundColor:
                                            const Color(0xFF000066),
                                        fixedSize: Size(33.w, 7.h),
                                      ),
                                      onPressed: () async {
                                        // if (_formKey.currentState!.validate()) {
                                        //   _formKey.currentState!.save();
                                        //   if (firebaseAuth
                                        //       .currentUser!.emailVerified) {
                                        //     firebaseAuth.currentUser!
                                        //         .updateDisplayName(name);
                                        //         print(name);
                                        //     String? id =
                                        //         await runShipperApiPost(

                                        //       emailId: firebaseAuth
                                        //           .currentUser!.email
                                        //           .toString(),
                                        //       shipperName: name,
                                        //       //phoneNo: phoneNumber,
                                        //       phoneNo: firebaseAuth
                                        //           .currentUser!.phoneNumber
                                        //           .toString()
                                        //           .replaceFirst("+91", ""),
                                        //       companyName: companyName,

                                        //     );
                                        //     if (id != null) {
                                        //       log('Shipper id--->$id');
                                        //       if (!mounted) {
                                        //         log('In not mounted');
                                        //         return;
                                        //       }
                                        //       Navigator.pushReplacement(
                                        //           context,
                                        //           MaterialPageRoute(
                                        //               builder: (context) =>
                                        //                   const HomeScreenWeb()));
                                        //     }
                                        //   } else {
                                        //     alertDialog(
                                        //         "Verify Email",
                                        //         "Verify your mail id to continue",
                                        //         context);
                                        //     // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const LoginWeb()));
                                        //   }
                                        // }
                                        try {
                                          if (companyNameController.text
                                                  .toString()
                                                  .isNotEmpty &&
                                              nameController.text
                                                  .toString()
                                                  .isNotEmpty) {
                                            updateDetails();
                                          } else {
                                            Fluttertoast.showToast(
                                                msg:
                                                    'Enter details (Company Name and Name)',
                                                fontSize: size_8,
                                                backgroundColor: Colors.white,
                                                textColor: Colors.black);
                                          }
                                        } catch (e) {
                                          log('Not updating--->$e');
                                        }
                                      },
                                      child: Text(
                                        "Confirm",
                                        style: GoogleFonts.montserrat(
                                            fontSize: screenHeight * 0.022,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
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
              MaterialPageRoute(builder: (context) => HomeScreenWeb()));
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
