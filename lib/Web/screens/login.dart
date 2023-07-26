import 'dart:developer';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:shipper_app/Web/screens/login_phone_no.dart';
import 'package:shipper_app/constants/colors.dart';
import 'package:shipper_app/constants/fontSize.dart';
import 'package:shipper_app/constants/radius.dart';
import 'package:shipper_app/constants/spaces.dart';
import 'package:shipper_app/functions/shipperId_fromCompaniesDatabase.dart';
import 'package:shipper_app/models/shipperModel.dart';
import '../../Widgets/buttons/signUpWithGoogleButton.dart';
import '../../functions/firebaseAuthentication/signIn.dart';
import '../../functions/firebaseAuthentication/signInWithGoogle.dart';
import '../../functions/loadOnGoingData.dart';
import '../../functions/shipperApis/runShipperApiPost.dart';
import '../../screens/LoginScreens/CompanyDetailsForm.dart';
import '../../screens/navigationScreen.dart';
import '/Web/screens/home_web.dart';
import '/Widgets/liveasy_Icon_Widgets.dart';
import 'company_details.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '/../functions/alert_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginWeb extends StatefulWidget {
  const LoginWeb({Key? key}) : super(key: key);

  @override
  State<LoginWeb> createState() => _LoginWebState();
}

class _LoginWebState extends State<LoginWeb> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  FirebaseAuth auth = FirebaseAuth.instance;
  late String email;
  late String password;
  bool passwordVisible = true;
  bool isChecked = false;
  bool isError = false;
  Iterable<String>? autofillHints = {'@gmail.com', '@outlook.in', '@yahoo.com'};

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
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
                                "assets/images/WebLoginImage.png"))), // Replace with your desired color or widget
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.topCenter,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.height *
                                        0.04),
                                child: Text("Welcome to Liveasy",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.montserrat(
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.03,
                                        color: white,
                                        fontWeight: FontWeight.w500)),
                              ),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.004),
                              Text(
                                  "One-stop solution for all your logistics operations.\nSign in to unlock new levels of efficiency, transparency, and success.",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.montserrat(
                                      fontWeight: FontWeight.w400,
                                      color: white,
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.01))
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).size.height * 0.1),
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                    "Elevate your business to new heights of success!",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.montserrat(
                                        fontSize:
                                            MediaQuery.of(context).size.height *
                                                0.02,
                                        color: white,
                                        fontWeight: FontWeight.w500)),
                                SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.01),
                                Text("Quality experience on all device",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.montserrat(
                                        fontWeight: FontWeight.w400,
                                        color: white,
                                        fontSize: 13))
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Color.fromARGB(255, 245, 246, 250),
                    // color: Colors
                    //     .blue, // Replace with your desired color or widget
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Form(
                          key: _formKey,
                          child: Container(
                            //width: MediaQuery.of(context).size.width,
                            width: kIsWeb ? 55.w : 40.w,
                            height: isError
                                ? 50.h
                                : MediaQuery.of(context).size.height * 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Center(
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 5.h),
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
                                          child: Text("Liveasy",
                                              style: GoogleFonts.montserrat(
                                                  fontWeight: FontWeight.w700,
                                                  color: Color.fromARGB(
                                                      255, 21, 41, 104),
                                                  fontSize: 28)),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                Center(
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 2.h),
                                    child: Text(
                                        "Efficiency at your finger tips",
                                        style: GoogleFonts.montserrat(
                                            fontWeight: FontWeight.w400,
                                            color: Color.fromARGB(
                                                255, 21, 41, 104),
                                            fontSize: 15)),
                                  ),
                                ),
                                //TODO : Email text field title
                                Row(
                                  children: [
                                    Padding(
                                      padding:
                                          EdgeInsets.only(left: 10.w, top: 5.h),
                                      child: Text(
                                        'Email Address',
                                        style: GoogleFonts.montserrat(
                                          fontSize: 20,
                                          color:
                                              Color.fromARGB(255, 21, 41, 104),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                //TODO : Email text field
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: 10.w, top: 1.h, right: 7.w),
                                  child: Container(
                                    color: white,
                                    child: TextFormField(
                                      autofocus: true,
                                      autofillHints: autofillHints,
                                      decoration: InputDecoration(
                                        hintStyle: TextStyle(
                                            decoration:
                                                TextDecoration.underline,
                                            decorationColor: Color.fromARGB(
                                                255, 197, 195, 195),
                                            fontSize: 2.h,
                                            color: Color.fromARGB(
                                                255, 217, 217, 217)),
                                        hintText: 'joshua07@gmail.com',
                                        //labelText: 'Email Id',
                                        contentPadding:
                                            EdgeInsets.only(left: 3.h),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5)),
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value.toString().isEmpty) {
                                          setState(() {
                                            isError = true;
                                          });
                                          return "Enter your email id";
                                        }
                                        if (!value.toString().contains('@')) {
                                          setState(() {
                                            isError = true;
                                          });
                                          return "Invalid Email Id";
                                        }
                                        setState(() {
                                          isError = false;
                                        });
                                        return null;
                                      },
                                      onSaved: (value) {
                                        email = value.toString();
                                      },
                                    ),
                                  ),
                                ),
                                //TODO : Password text field title
                                Row(
                                  children: [
                                    Padding(
                                      // padding: EdgeInsets.only(
                                      //     left: kIsWeb ? 3.w : 10, top: 3.h),
                                      padding:
                                          EdgeInsets.only(left: 10.w, top: 3.h),
                                      child: Text(
                                        'Password',
                                        style: GoogleFonts.montserrat(
                                          fontSize: 20,
                                          color:
                                              Color.fromARGB(255, 21, 41, 104),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                //TODO : Password text field
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: 10.w, top: 1.h, right: 7.w),
                                  child: Container(
                                    color: white,
                                    child: TextFormField(
                                      obscureText: passwordVisible,
                                      textAlignVertical:
                                          TextAlignVertical.center,
                                      decoration: InputDecoration(
                                        hintStyle: GoogleFonts.roboto(
                                            fontSize: 2.h,
                                            fontWeight: FontWeight.w600,
                                            color: Color.fromARGB(
                                                255, 197, 195, 195)),
                                        // prefixIcon: Icon(Icons.lock),
                                        // prefixIconColor: Colors.grey[350],
                                        hintText: '***********',
                                        contentPadding:
                                            EdgeInsets.only(left: 3.h),
                                        border: const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5)),
                                        ),
                                        suffixIcon: IconButton(
                                          color: Color.fromARGB(
                                              255, 197, 195, 195),
                                          icon: Icon(passwordVisible
                                              ? Icons.visibility_off
                                              : Icons.visibility),
                                          onPressed: () {
                                            setState(() {
                                              passwordVisible =
                                                  !passwordVisible;
                                            });
                                          },
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value.toString().isEmpty) {
                                          setState(() {
                                            isError = true;
                                          });
                                          return "Enter password";
                                        }
                                        if (value.toString().length < 6) {
                                          setState(() {
                                            isError = true;
                                          });
                                          return "Password length should be greater/equal to 6 ";
                                        }
                                        setState(() {
                                          isError = false;
                                        });
                                        return null;
                                      },
                                      onSaved: (value) {
                                        password = value.toString();
                                      },
                                    ),
                                  ),
                                ),
                                //TODO : check box for keep me logged in
                                // Padding(
                                //   padding: EdgeInsets.only(left: 3.w, top: 1.h),
                                //   child: TextButton.icon(
                                //     onPressed: () {
                                //       setState(() {
                                //         isChecked = !isChecked;
                                //       });
                                //     },
                                //     icon: isChecked
                                //         ? const Icon(
                                //             Icons.check_box,
                                //           )
                                //         : const Icon(
                                //             Icons.check_box_outline_blank,
                                //             color: Colors.black,
                                //           ),
                                //     label: const Text(
                                //       "Keep me logged in",
                                //       style: TextStyle(
                                //         fontSize: 16,
                                //         fontWeight: FontWeight.bold,
                                //         color: Colors.black,
                                //       ),
                                //     ),
                                //   ),
                                // ),

                                //TODO : Sign In button
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: 7.w, top: 5.h, right: 4.w),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      backgroundColor: const Color(0xFF000066),
                                      fixedSize: Size(33.w, 7.h),
                                    ),
                                    onPressed: () async {
                                      if (_formKey.currentState!.validate()) {
                                        _formKey.currentState!.save();
                                        try {
                                          UserCredential firebaseUser =
                                              await signIn(
                                                  email, password, context);
                                          SharedPreferences prefs =
                                              await SharedPreferences
                                                  .getInstance();
                                          if (isChecked) {
                                            prefs.setString(
                                                'uid', firebaseUser.user!.uid);
                                          }
                                          // if (firebaseUser.user!.phoneNumber ==
                                          //     null) {
                                          //   Navigator.pushReplacement(
                                          //       context,
                                          //       MaterialPageRoute(
                                          //           builder: (context) =>
                                          //               const LoginWebPhone()));
                                          // }
                                           if (firebaseUser
                                                  .user!.displayName ==
                                              null) {
                                            Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const CompanyDetails()));
                                          } else if (firebaseUser
                                              .user!.emailVerified) {
                                            Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const HomeScreenWeb()));
                                          } else {
                                            alertDialog(
                                                "Verify Your Mail",
                                                "Please verify your \n mail id to continue",
                                                context);
                                            // firebaseUser.user!.sendEmailVerification();
                                          }
                                        } catch (e) {
                                          log('in sign in button catch--->$e');
                                        }
                                      }
                                    },
                                    child: Text(
                                      'Sign in',
                                      style: GoogleFonts.montserrat(
                                        color: Colors.white,
                                        fontSize: 4.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),

                                //Forget Password
                                Padding(
                                  padding:
                                      EdgeInsets.only(right: 7.w, top: 3.h),
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Text("Forgot password ?",
                                        style: GoogleFonts.montserrat(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w400,
                                            color: Color.fromARGB(
                                                255, 197, 195, 195))),
                                  ),
                                ),

                                SizedBox(
                                  height: space_4,
                                ),
                                Container(
                                  padding: EdgeInsets.only(
                                    left: 140,
                                    right: 100,
                                  ),
                                  //width: 2000,
                                  child: Row(
                                    children: [
                                      Expanded(
                                          child: Container(
                                        // width:
                                        //     MediaQuery.of(context).size.width *
                                        //         0.4,
                                        height: 1,
                                        color:
                                            Color.fromARGB(255, 160, 160, 160),
                                      )),
                                      SizedBox(
                                        width: space_5,
                                      ),
                                      Text(
                                        "Or",
                                        style: GoogleFonts.roboto(
                                          decoration: TextDecoration.none,
                                          fontSize: size_10,
                                          fontWeight: FontWeight.w600,
                                          color: const Color.fromARGB(
                                              255, 211, 202, 202),
                                        ),
                                      ),
                                      SizedBox(
                                        width: space_5,
                                      ),
                                      Expanded(
                                          child: Container(
                                        // width:
                                        //     MediaQuery.of(context).size.width,
                                        height: 1,
                                        color:
                                            Color.fromARGB(255, 160, 160, 160),
                                      )),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      left: 10.w, right: 7.w, top: 6.h),
                                  decoration: BoxDecoration(
                                    color: widgetBackGroundColor,
                                    borderRadius:
                                        BorderRadius.circular(radius_1),
                                  ),
                                  child: SignUpWithGoogleButton(
                                    onPressed: () async {
                                      try {
                                        UserCredential firebaseUser =
                                            await signInWithGoogle();
                                        SharedPreferences prefs =
                                            await SharedPreferences
                                                .getInstance();
                                        prefs.setString(
                                            'uid', firebaseUser.user!.uid);
                                        prefs.setBool('isGoogleLogin', true);
                                        getShipperIdFromCompanyDatabase();
                                        if (!mounted) return;
                                        ShipperModel shipperModel =
                                            await shipperApiCalls
                                                .getShipperCompanyDetailsByEmail(
                                                    firebaseUser.user!.email
                                                        .toString());

                                        if (shipperModel.companyName == "Na" &&
                                            shipperModel.shipperName == "Na") {
                                          //firebaseUser.user!.displayName == null --> previous condition
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const CompanyDetails()));
                                        } else {
                                          runShipperApiPost(
                                              emailId: firebaseUser.user!.email
                                                  .toString());
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      NavigationScreen()));
                                        }
                                      } on FirebaseAuthException catch (e) {
                                        alertDialog("Error", '$e', context);
                                      }
                                    },
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
          ),
        ),
      ),
    );
  }
}
