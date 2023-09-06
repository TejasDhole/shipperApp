import 'dart:developer';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:shipper_app/Web/screens/login_phone_no.dart';
import 'package:shipper_app/Widgets/buttons/ConfirmButton.dart';
import 'package:shipper_app/Widgets/webHeader.dart';
import 'package:shipper_app/Widgets/webLoginLeftPart.dart';
import 'package:shipper_app/constants/colors.dart';
import 'package:shipper_app/constants/fontSize.dart';
import 'package:shipper_app/constants/radius.dart';
import 'package:shipper_app/constants/spaces.dart';
import 'package:shipper_app/functions/alert_dialog.dart';
import 'package:shipper_app/functions/firebaseAuthentication/signIn.dart';
import 'package:shipper_app/functions/firebaseAuthentication/signInWithGoogle.dart';
import 'package:shipper_app/functions/loadOnGoingData.dart';
import 'package:shipper_app/functions/shipperApis/runShipperApiPost.dart';
import 'package:shipper_app/functions/shipperId_fromCompaniesDatabase.dart';
import 'package:shipper_app/models/shipperModel.dart';
import 'package:shipper_app/widgets/buttons/signUpWithGoogleButton.dart';
//import '../../screens/LoginScreens/CompanyDetailsForm.dart';
//import '../../screens/navigationScreen.dart';
import '/Web/screens/home_web.dart';
//import '/Widgets/liveasy_Icon_Widgets.dart';
import 'company_details.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
        physics: const NeverScrollableScrollPhysics(),
        child: Center(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Row(
              children: [
                const WebLoginLeftPart(),
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
                            double maxWidth = kIsWeb ? 55.w : 40.w;
                            double containerHeight =
                                isError ? 50.h : screenHeight * 1;
                            return Container(
                              //width: MediaQuery.of(context).size.width,
                              width: maxWidth,
                              height: containerHeight,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const WebHeader(),
                                  Center(
                                    child: Padding(
                                      padding: EdgeInsets.only(top: 2.h),
                                      child: Text(
                                          "Efficiency at your finger tips",
                                          style: GoogleFonts.montserrat(
                                              fontWeight: FontWeight.w400,
                                              color: darkBlueTextColor,
                                              fontSize: 15)),
                                    ),
                                  ),
                                  //TODO : Email text field title
                                  Row(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: 10.w, top: 5.h),
                                        child: Text(
                                          'Email Address',
                                          style: GoogleFonts.montserrat(
                                            fontSize: 20,
                                            color: darkBlueTextColor,
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
                                              decorationColor: greyShade,
                                              fontSize: 2.h,
                                              color: hintTextColor),
                                          hintText: 'joshua07@gmail.com',
                                          contentPadding:
                                              EdgeInsets.only(left: 3.h),
                                          border: const OutlineInputBorder(
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
                                        padding: EdgeInsets.only(
                                            left: 10.w, top: 3.h),
                                        child: Text(
                                          'Password',
                                          style: GoogleFonts.montserrat(
                                            fontSize: 20,
                                            color: darkBlueTextColor,
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
                                              color: greyShade),
                                          hintText: '***********',
                                          contentPadding:
                                              EdgeInsets.only(left: 3.h),
                                          border: const OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5)),
                                          ),
                                          suffixIcon: IconButton(
                                            color: greyShade,
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

                                  //TODO : Sign In button
                                  Padding(
                                      padding: EdgeInsets.only(
                                          left: 7.w, top: 5.h, right: 4.w),
                                      child: ConfirmButton(
                                        text: 'Sign in',
                                        onPressed: () async {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            _formKey.currentState!.save();
                                            try {
                                              UserCredential firebaseUser =
                                                  await signIn(
                                                      email, password, context);
                                              SharedPreferences prefs =
                                                  await SharedPreferences
                                                      .getInstance();
                                              if (isChecked) {
                                                prefs.setString('uid',
                                                    firebaseUser.user!.uid);
                                              }
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
                                      )),

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
                                              color: greyShade)),
                                    ),
                                  ),

                                  SizedBox(
                                    height: space_4,
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(
                                        left: 140, right: 100),
                                    child: Row(
                                      children: [
                                        Expanded(
                                            child: Container(
                                          height: 1,
                                          color: darkGreyish,
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
                                            color: textGreyColor,
                                          ),
                                        ),
                                        SizedBox(
                                          width: space_5,
                                        ),
                                        Expanded(
                                            child: Container(
                                          height: 1,
                                          color: darkGreyish,
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
                                          prefs.setString('userEmail', firebaseUser.user!.email!);
                                          getShipperIdFromCompanyDatabase();
                                          if (!mounted) return;
                                          ShipperModel shipperModel =
                                              await shipperApiCalls
                                                  .getShipperCompanyDetailsByEmail(
                                                      firebaseUser.user!.email
                                                          .toString());

                                          if (shipperModel.companyName ==
                                                  "Na" &&
                                              shipperModel.shipperName ==
                                                  "Na") {
                                            //firebaseUser.user!.displayName == null --> previous condition
                                            Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const CompanyDetails()));
                                          } else {
                                            runShipperApiPost(
                                                emailId: firebaseUser
                                                    .user!.email
                                                    .toString());
                                            Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const HomeScreenWeb()));
                                          }
                                        } on FirebaseAuthException catch (e) {
                                          alertDialog("Error", '$e', context);
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
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
