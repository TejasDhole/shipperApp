import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shipper_app/Web/screens/company_details.dart';
import 'package:shipper_app/Web/screens/login.dart';
import 'package:shipper_app/Widgets/buttons/ConfirmButton.dart';
import 'package:shipper_app/Widgets/buttons/signUpWithGoogleButton.dart';
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
import 'package:shipper_app/responsive.dart';
import 'package:sizer/sizer.dart';

class RegisterScreen extends StatefulWidget {
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool passwordVisible = true, isError = false;
  Iterable<String>? autofillHints = {'@gmail.com', '@outlook.in', '@yahoo.com'};
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: formBackground,
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Center(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Row(
              children: [
                Visibility(
                    visible: Responsive.isMobile(context) ? false : true,
                    child: const WebLoginLeftPart()),
                Expanded(
                  child: SizedBox(
                    width: kIsWeb ? 55.w : 40.w,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const WebHeader(),
                          Center(
                            child: Padding(
                              padding: EdgeInsets.only(top: 2.h),
                              child: Text("Efficiency at your finger tips",
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
                                padding: EdgeInsets.only(left: 10.w, top: 5.h),
                                child: Text(
                                  'Email Address',
                                  style: GoogleFonts.montserrat(
                                    fontSize:
                                        Responsive.isMobile(context) ? 15 : 20,
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
                            child: TextFormField(
                              controller: email,
                              autofocus: true,
                              autofillHints: autofillHints,
                              decoration: InputDecoration(
                                fillColor: white,
                                filled: true,
                                hintStyle: TextStyle(
                                    decoration: TextDecoration.underline,
                                    decorationColor: greyShade,
                                    fontSize: 2.h,
                                    color: hintTextColor),
                                hintText: 'joshua07@gmail.com',
                                contentPadding: EdgeInsets.only(left: 3.h),
                                border: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                ),
                              ),
                              validator: (value) {
                                if (value.toString().isEmpty || value == null) {
                                  isError = true;
                                  return "Enter your email id";
                                }
                                if (!value.toString().contains('@') ||
                                    !value.toString().isEmail) {
                                  isError = true;
                                  return "Invalid Email Id";
                                }
                                isError = false;
                                return null;
                              },
                            ),
                          ),
                          //TODO : Password text field title
                          Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 10.w, top: 3.h),
                                child: Text(
                                  'Password',
                                  style: GoogleFonts.montserrat(
                                    fontSize:
                                        Responsive.isMobile(context) ? 15 : 20,
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
                            child: TextFormField(
                              controller: password,
                              obscureText: passwordVisible,
                              textAlignVertical: TextAlignVertical.center,
                              decoration: InputDecoration(
                                fillColor: white,
                                filled: true,
                                hintStyle: GoogleFonts.roboto(
                                    fontSize: 2.h,
                                    fontWeight: FontWeight.w600,
                                    color: greyShade),
                                hintText: '***********',
                                contentPadding: EdgeInsets.only(left: 3.h),
                                border: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                ),
                                suffixIcon: IconButton(
                                  color: greyShade,
                                  icon: Icon(passwordVisible
                                      ? Icons.visibility_off
                                      : Icons.visibility),
                                  onPressed: () {
                                    setState(() {
                                      passwordVisible = !passwordVisible;
                                    });
                                  },
                                ),
                              ),
                              validator: (value) {
                                if (value.toString().isEmpty || value == null) {
                                  isError = true;
                                  return "Enter password";
                                }
                                if (value.toString().length < 6) {
                                  isError = true;
                                  return "Password length should be greater/equal to 6 ";
                                }
                                isError = false;
                                return null;
                              },
                            ),
                          ),

                          //TODO : Sign In button
                          ConfirmButton(
                            text: 'Register',
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                try {
                                  var value = await signUp(
                                      email.text, password.text, context);

                                  if(value != null){
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => CompanyDetails(
                                              email: email.text,
                                            )));
                                  }
                                } catch (e) {
                                  debugPrint('in sign in button catch--->$e');
                                }
                              }
                            },
                          ),

                          SizedBox(
                            height: space_4,
                          ),

                          Container(
                            padding:
                                const EdgeInsets.only(left: 140, right: 100),
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

                          SignUpWithGoogleButton(
                            txt: "Register using Google",
                            onPressed: () async {
                              try {
                                UserCredential firebaseUser =
                                    await signInWithGoogle();
                                if (firebaseUser
                                        .additionalUserInfo!.isNewUser ==
                                    false) {
                                  showSnackBar(
                                      'An account exits with the given email address.',
                                      deleteButtonColor,
                                      const Icon(Icons.warning),
                                      context);
                                  FirebaseAuth.instance.signOut();
                                } else {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => CompanyDetails(
                                                email: firebaseUser.user!.email,
                                              )));
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
                                        builder: (context) => LoginWeb()));
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text("Already have an account? ",
                                      style: GoogleFonts.montserrat(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400,
                                          color: greyShade)),
                                  Text("Sign In",
                                      style: GoogleFonts.montserrat(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: truckGreen)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
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
