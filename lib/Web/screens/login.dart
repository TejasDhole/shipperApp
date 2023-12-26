import 'dart:developer';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shipper_app/Web/screens/login_phone_no.dart';
import 'package:shipper_app/Widgets/buttons/ConfirmButton.dart';
import 'package:shipper_app/Widgets/showSnackBarTop.dart';
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
import 'package:shipper_app/responsive.dart';
import 'package:shipper_app/screens/LoginScreens/RegisterScreen.dart';
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
  bool isError = false;
  Iterable<String>? autofillHints = {'@gmail.com', '@outlook.in', '@yahoo.com'};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Center(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Row(
              children: [
                WebLoginLeftPart(login: true,),
                Expanded(
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Form(
                          key: _formKey,
                          child: SizedBox(
                            width: kIsWeb ? 55.w : 40.w,
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
                                            fontWeight: FontWeight.w500,
                                            color: darkBlueTextColor,
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
                                          fontSize: 16,
                                          color: black,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                //TODO : Email text field
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: 10.w, top: 1.h, right: 7.w),
                                  child: TextFormField(
                                    autofocus: true,
                                    autofillHints: autofillHints,
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: offWhite,
                                      hintStyle: TextStyle(
                                          decorationColor: greyShade,
                                          fontSize: 2.h,
                                          color: hintTextColor),
                                      suffixIcon: Icon(FontAwesomeIcons.user, color: greyShade,),
                                      hintText: 'eg: kartikkun@gmail.com',
                                      contentPadding:
                                          EdgeInsets.only(left: 3.h),
                                      border: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5)),
                                      ),
                                      focusedBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(color: black, width: 2),
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
                                //TODO : Password text field title
                                Row(
                                  children: [
                                    Padding(
                                      padding:
                                          EdgeInsets.only(left: 10.w, top: 3.h),
                                      child: Text(
                                        'Password',
                                        style: GoogleFonts.montserrat(
                                          fontSize: 16,
                                          color: black,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                //TODO : Password text field
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: 10.w, top: 1.h, right: 7.w),
                                  child: TextFormField(
                                    obscureText: passwordVisible,
                                    textAlignVertical: TextAlignVertical.center,
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: offWhite,
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
                                      focusedBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(color: black, width: 2),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5)),
                                      ),
                                      suffixIcon: IconButton(
                                        color: greyShade,
                                        icon: Icon(passwordVisible
                                            ? FontAwesomeIcons.lock
                                            : FontAwesomeIcons.lockOpen),
                                        onPressed: () {
                                          setState(() {
                                            passwordVisible = !passwordVisible;
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

                                //Forget Password
                                Padding(
                                  padding:
                                  EdgeInsets.only(right: 7.w, top: 3.h),
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Text("Forgot password ?",
                                        style: GoogleFonts.montserrat(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: kLiveasyColor)),
                                  ),
                                ),

                                //TODO : Sign In button
                                ConfirmButton(
                                  text: 'Log in',
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      _formKey.currentState!.save();
                                      try {
                                        UserCredential? firebaseUser =
                                            await signIn(
                                                email, password, context);
                                        if (firebaseUser != null) {
                                          SharedPreferences prefs =
                                              await SharedPreferences
                                                  .getInstance();
                                          prefs.setString(
                                              'uid', firebaseUser.user!.uid);

                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const HomeScreenWeb()));
                                        }
                                      } catch (e) {
                                        debugPrint(
                                            'in sign in button catch--->$e');
                                      }
                                    }
                                  },
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
                                        color: lightGrey,
                                      )),
                                      SizedBox(
                                        width: space_5,
                                      ),
                                      Text(
                                        "Or",
                                        style: GoogleFonts.roboto(
                                          decoration: TextDecoration.none,
                                          fontSize: size_7,
                                          fontWeight: FontWeight.w600,
                                          color: lightGrey,
                                        ),
                                      ),
                                      SizedBox(
                                        width: space_5,
                                      ),
                                      Expanded(
                                          child: Container(
                                        height: 1,
                                        color: lightGrey,
                                      )),
                                    ],
                                  ),
                                ),
                                SignUpWithGoogleButton(
                                  txt: "Login with Google",
                                  onPressed: () async {
                                    try {
                                      UserCredential firebaseUser =
                                          await signInWithGoogle();
                                      if (firebaseUser
                                              .additionalUserInfo!.isNewUser ==
                                          true) {
                                        showSnackBar(
                                            'No user found for this Gmail.',
                                            deleteButtonColor,
                                            const Icon(Icons.warning),
                                            context);
                                        FirebaseAuth.instance.signOut();
                                        firebaseUser.user!.delete();
                                      } else {
                                        SharedPreferences prefs =
                                            await SharedPreferences
                                                .getInstance();
                                        prefs.setString(
                                            'uid', firebaseUser.user!.uid);
                                        prefs.setBool('isGoogleLogin', true);
                                        prefs.setString('userEmail',
                                            firebaseUser.user!.email!);

                                        runShipperApiPost(
                                            emailId: firebaseUser.user!.email
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
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 3.h),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  RegisterScreen()));
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text("Don't have an account? ",
                                            style: GoogleFonts.montserrat(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w400,
                                                color: greyShade)),
                                        Text("Sign Up",
                                            style: GoogleFonts.montserrat(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600,
                                                color: kLiveasyColor)),
                                      ],
                                    ),
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
