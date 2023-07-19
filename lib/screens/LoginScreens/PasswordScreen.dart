import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shipper_app/functions/alert_dialog.dart';
import 'package:shipper_app/functions/firebaseAuthentication/signIn.dart';
import 'package:shipper_app/functions/loadOnGoingData.dart';
import 'package:shipper_app/models/shipperModel.dart';
import 'package:shipper_app/screens/LoginScreens/CompanyDetailsForm.dart';
import 'package:shipper_app/screens/navigationScreen.dart';

import '../../functions/firebaseAuthentication/signInWithGoogle.dart';
import '../../functions/shipperApis/runShipperApiPost.dart';
import 'package:shipper_app/functions/shipperId_fromCompaniesDatabase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/constants/spaces.dart';
import '/constants/colors.dart';
import '/widgets/buttons/signUpWithGoogleButton.dart';
import '/constants/fontSize.dart';
import '/constants/radius.dart';
import '/constants/elevation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

//import '../../functions/shipperApis/runShipperApiPost.dart';

class PasswordScreen extends StatefulWidget {
  final TextEditingController emailController;

  PasswordScreen({super.key, required this.emailController});

  //const PasswordScreen({Key? key}) : super(key: key);

  @override
  State<PasswordScreen> createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {
  TextEditingController passwordController = TextEditingController();
  bool isVisible = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    clearFirebaseAndSharedPreference();
  }

  void clearFirebaseAndSharedPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('uid');
    //sidstorage.erase();
    Get.deleteAll(force: true);
    if (prefs.getBool('isGoogleLogin') == true) {
      await GoogleSignIn().disconnect();
    }
    prefs.clear();
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        //toolbarHeight: 50,
        backgroundColor: Color.fromARGB(255, 0, 0, 102),
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          iconSize: 28,
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          color: Colors.white,
        ),
        title: Align(
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image(
                width: MediaQuery.of(context).size.width * 0.07,
                height: screenHeight * 0.025,
                image: AssetImage("assets/icons/liveasyicon.png"),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.01),
                child: Text(
                  'Liveasy',
                  style: GoogleFonts.montserrat(
                    fontSize: screenHeight * 0.026,
                    fontWeight: FontWeight.w700,
                    color: white,
                  ),
                ),
              ),
              SizedBox(width: MediaQuery.of(context).size.width * 0.15),
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
                height: screenHeight * 0.44,
                //width: MediaQuery.of(context).size.width,
                image: AssetImage("assets/images/PasswordImage.png"),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                left: space_4,
                right: space_4,
              ),
              width: MediaQuery.of(context).size.width,
              // height: MediaQuery.of(context).size.height,
              child: Row(
                children: [
                  Expanded(
                      child: Container(
                    height: 1,
                    color: widgetBackGroundColor,
                  )),
                  SizedBox(
                    width: space_3,
                  ),
                  Text(
                    "Enter the password",
                    style: GoogleFonts.montserrat(
                      decoration: TextDecoration.none,
                      fontSize: screenHeight * 0.019,
                      fontWeight: FontWeight.w600,
                      color: Color.fromARGB(255, 128, 128, 128),
                    ),
                  ),
                  SizedBox(
                    width: space_3,
                  ),
                  Expanded(
                      child: Container(
                    // width: space_26,
                    height: 1,
                    color: widgetBackGroundColor,
                  )),
                ],
              ),
            ),
            // SizedBox(
            //   height: MediaQuery.of(context).size.height * 0.02,
            // ),
            Padding(
              padding:
                  EdgeInsets.only(left: space_6, right: space_6, top: space_3),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: space_0),
                    child: Text(
                      "Password",
                      style: GoogleFonts.montserrat(
                          decoration: TextDecoration.none,
                          fontWeight: FontWeight.w500,
                          fontSize: screenHeight * 0.019,
                          color: Color.fromARGB(255, 21, 41, 104)),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01,
                  ),
                  Container(
                    height: screenHeight * 0.056,
                    child: TextFormField(
                      obscureText: !isVisible,
                      controller: passwordController,
                      keyboardType: TextInputType.visiblePassword,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * 0.04),
                        filled: true,
                        fillColor: Colors.white,
                        enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Color.fromARGB(255, 192, 192, 192)),
                            borderRadius: BorderRadius.circular(radius_1)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Color.fromARGB(255, 192, 192, 192)),
                            borderRadius: BorderRadius.circular(radius_1)),
                        suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                isVisible = !isVisible;
                              });
                            },
                            icon: Icon(isVisible
                                ? Icons.visibility
                                : Icons.visibility_off)),
                        hintText: "***********",
                        //border: InputBorder,
                      ),
                      style: GoogleFonts.montserrat(
                        //fontWeight: FontWeight.w600,
                        fontSize: screenHeight * 0.019,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            //const SizedBox(height: 28),
            Padding(
              padding: EdgeInsets.only(
                left: space_6,
                right: space_6,
                top: MediaQuery.of(context).size.height * 0.03,
              ),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.056,
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
                  onPressed: () async {
                    String email = widget.emailController.text.toString();
                    String password = passwordController.text.toString();
                    if (email.isNotEmpty && email.contains('@')) {
                      if (password.length > 5) {
                        UserCredential firebaseUser =
                            await signIn(email, password, context);
                        getShipperIdFromCompanyDatabase();
                        ShipperModel shipperModel = await shipperApiCalls
                            .getShipperCompanyDetailsByEmail(
                                firebaseUser.user!.email.toString());
                        if (!mounted) return;
                        if (shipperModel.companyName == "Na" &&
                            shipperModel.shipperName == "Na") {
                          //firebaseUser.user!.displayName == null --> previous condition
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const CompanyDetailsForm()));
                        } else {
                          runShipperApiPost(
                              emailId: firebaseUser.user!.email.toString());

                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => NavigationScreen()));
                        }
                      } else {
                        Fluttertoast.showToast(
                            msg: 'Password must contain at least 6 characters',
                            fontSize: size_8,
                            backgroundColor: Colors.white,
                            textColor: Colors.black);
                      }
                    } else {
                      Fluttertoast.showToast(
                          msg: 'Invalid email',
                          fontSize: size_8,
                          backgroundColor: Colors.white,
                          textColor: Colors.black);
                    }
                  },
                  child: Text(
                    "Continue",
                    style: GoogleFonts.montserrat(
                        fontSize: screenHeight * 0.019,
                        color: Colors.white,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ),
            // SizedBox(
            //   height: space_8,
            // ),
            Padding(
              padding: EdgeInsets.only(
                  right: MediaQuery.of(context).size.width * 0.06,
                  top: MediaQuery.of(context).size.height * 0.01),
              child: Align(
                  alignment: Alignment.centerRight,
                  child: Text("Forgot Password ?",
                      style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w400,
                          fontSize: screenHeight * 0.019,
                          color: Color.fromARGB(255, 197, 195, 195)))),
            ),
            Container(
              margin:
                  EdgeInsets.only(left: space_4, right: space_4, top: space_2),
              height: MediaQuery.of(context).size.height * 0.05,
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: [
                  Expanded(
                      child: Container(
                    height: 1,
                    color: widgetBackGroundColor,
                  )),
                  SizedBox(
                    width: space_4,
                  ),
                  Text(
                    "Or",
                    style: GoogleFonts.roboto(
                      decoration: TextDecoration.none,
                      fontSize: screenHeight * 0.022,
                      fontWeight: FontWeight.w700,
                      color: Color.fromARGB(255, 128, 128, 128),
                    ),
                  ),
                  SizedBox(
                    width: space_4,
                  ),
                  Expanded(
                      child: Container(
                    // width: space_26,
                    height: 1,
                    color: widgetBackGroundColor,
                  )),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                  left: space_6,
                  right: space_6,
                  bottom: space_2,
                  top: MediaQuery.of(context).size.height * 0.009),
              decoration: BoxDecoration(
                color: widgetBackGroundColor,
                borderRadius: BorderRadius.circular(radius_1),
              ),
              child: SignUpWithGoogleButton(
                onPressed: () async {
                  try {
                    UserCredential firebaseUser = await signInWithGoogle();
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.setString('uid', firebaseUser.user!.uid);
                    prefs.setBool('isGoogleLogin', true);
                    getShipperIdFromCompanyDatabase();
                    if (!mounted) return;
                    ShipperModel shipperModel =
                        await shipperApiCalls.getShipperCompanyDetailsByEmail(
                            firebaseUser.user!.email.toString());

                    if (shipperModel.companyName == "Na" &&
                        shipperModel.shipperName == "Na") {
                      //firebaseUser.user!.displayName == null --> previous condition
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const CompanyDetailsForm()));
                    } else {
                      runShipperApiPost(
                          emailId: firebaseUser.user!.email.toString());
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => NavigationScreen()));
                    }
                  } on FirebaseAuthException catch (e) {
                    alertDialog("Error", '$e', context);
                  }
                },
              ),
            ),
            // SizedBox(height: MediaQuery.of(context).size.height * 0.001),
            // const Center(
            //   child: Text('create new account?',
            //       style: TextStyle(
            //           color: Color.fromARGB(255, 33, 67, 172),
            //           fontSize: 20,
            //           fontWeight: FontWeight.w600)),
            // )
          ],
        ),
      )),
    );
  }
}
