import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shipper_app/Web/screens/home_web.dart';
import 'package:shipper_app/Widgets/buttons/ConfirmButton.dart';
import 'package:shipper_app/Widgets/buttons/signUpWithGoogleButton.dart';
import 'package:shipper_app/Widgets/showSnackBarTop.dart';
import 'package:shipper_app/constants/colors.dart';
import 'package:shipper_app/constants/fontSize.dart';
import 'package:shipper_app/constants/spaces.dart';
import 'package:shipper_app/functions/JoinTeamController.dart';
import 'package:shipper_app/functions/alert_dialog.dart';
import 'package:shipper_app/functions/firebaseAuthentication/signIn.dart';
import 'package:shipper_app/functions/firebaseAuthentication/signInWithGoogle.dart';
import 'package:shipper_app/functions/shipperApis/runShipperApiPost.dart';
import 'package:sizer/sizer.dart';

class InviteJoiningScreen extends StatefulWidget {
  final String inviteID;

  const InviteJoiningScreen({super.key, required this.inviteID});

  @override
  State<InviteJoiningScreen> createState() => _InviteJoiningScreenState();
}

class _InviteJoiningScreenState extends State<InviteJoiningScreen> {
  //form key
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool passwordVisible = true, isError = false;
  Iterable<String>? autofillHints = {'@gmail.com', '@outlook.in', '@yahoo.com'};

  //text controllers for name, email, password field
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: (widget.inviteID == '')
            ? Center(child: Text("Invitation Link is not valid"))
            : Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 5.w),
                        child: Text("Join Team",
                            style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.w700,
                                color: darkBlueTextColor,
                                fontSize: 28)),
                      ),
                    ),
                    //TODO : Name text field title
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 10.w, top: 5.h),
                          child: Text('Full Name',
                              style: GoogleFonts.montserrat(
                                fontSize: 16,
                                color: black,
                                fontWeight: FontWeight.w600,
                              )),
                        )
                      ],
                    ),
                    //TODO : Name text field
                    Padding(
                      padding:
                          EdgeInsets.only(left: 10.w, top: 1.h, right: 7.w),
                      child: TextFormField(
                        controller: name,
                        autofocus: true,
                        autofillHints: autofillHints,
                        decoration: InputDecoration(
                          fillColor: offWhite,
                          filled: true,
                          hintStyle: TextStyle(
                              decoration: TextDecoration.underline,
                              decorationColor: greyShade,
                              fontSize: 2.h,
                              color: hintTextColor),
                          contentPadding: EdgeInsets.only(left: 3.h),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: black, width: 2),
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                        ),
                        validator: (value) {
                          if (value.toString().isEmpty || value == null) {
                            isError = true;
                            return "Enter your full Name";
                          }
                          isError = false;
                          return null;
                        },
                      ),
                    ),
                    //TODO : Email text field title
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 10.w, top: 3.h),
                          child: Text('Email Address',
                              style: GoogleFonts.montserrat(
                                fontSize: 16,
                                color: black,
                                fontWeight: FontWeight.w600,
                              )),
                        )
                      ],
                    ),
                    //TODO : Email text field
                    Padding(
                      padding:
                          EdgeInsets.only(left: 10.w, top: 1.h, right: 7.w),
                      child: TextFormField(
                        controller: email,
                        autofocus: true,
                        autofillHints: autofillHints,
                        decoration: InputDecoration(
                          fillColor: offWhite,
                          filled: true,
                          hintStyle: TextStyle(
                              decoration: TextDecoration.underline,
                              decorationColor: greyShade,
                              fontSize: 2.h,
                              color: hintTextColor),
                          hintText: 'eg: kartikkun@gmail.com',
                          contentPadding: EdgeInsets.only(left: 3.h),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: black, width: 2),
                            borderRadius: BorderRadius.all(Radius.circular(5)),
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
                          child: Text('Password',
                              style: GoogleFonts.montserrat(
                                fontSize: 16,
                                color: black,
                                fontWeight: FontWeight.w600,
                              )),
                        ),
                      ],
                    ),
                    //TODO : Password text field
                    Padding(
                      padding:
                          EdgeInsets.only(left: 10.w, top: 1.h, right: 7.w),
                      child: TextFormField(
                        controller: password,
                        obscureText: passwordVisible,
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                          fillColor: offWhite,
                          filled: true,
                          hintStyle: GoogleFonts.roboto(
                              fontSize: 2.h,
                              fontWeight: FontWeight.w600,
                              color: greyShade),
                          hintText: '***********',
                          contentPadding: EdgeInsets.only(left: 3.h),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: black, width: 2),
                            borderRadius: BorderRadius.all(Radius.circular(5)),
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
                    Padding(
                      padding: EdgeInsets.only(left: 10.w, top: 8.0),
                      child: Row(
                        children: [
                          Text(
                            "6 or more characters",
                            style: GoogleFonts.roboto(
                              decoration: TextDecoration.none,
                              fontSize: size_7,
                              fontWeight: FontWeight.w600,
                              color: lightGrey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    //TODO : Join In button
                    ConfirmButton(
                      text: 'Join',
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          UserCredential? firebaseUser;

                          try {
                            //create user account in firebase
                            firebaseUser =
                                await auth.createUserWithEmailAndPassword(
                                    email: email.text, password: password.text);
                          } on FirebaseAuthException catch (e) {
                            if (e.code == 'weak-password') {
                              alertDialog('Weak password',
                                  'Entered password is too weak', context);
                            } else if (e.code == 'email-already-in-use') {
                              //if user already exits in firebase
                              firebaseUser = await signIn(
                                  email.text, password.text, context);
                            } else if (e.code == 'invalid-email') {
                              debugPrint(e.toString());
                              showSnackBar(
                                  'Email Address is not valid.',
                                  deleteButtonColor,
                                  const Icon(Icons.warning),
                                  context);
                            } else {
                              alertDialog('Error', '$e', context);
                            }
                          }

                          Map? inviteDetails =
                              await getInviteDetails(widget.inviteID);

                          if (inviteDetails != null && firebaseUser != null) {
                            if (inviteDetails['receiverMailId'] != email.text) {
                              showSnackBar(
                                  "Wrong Email!!",
                                  deleteButtonColor,
                                  const Icon(Icons.error_outline_sharp),
                                  context);
                              return;
                            }

                            //create shipper account
                            final shipperId = await createUpdateEmployee(
                                emailId: email.text,
                                shipperName: name.text,
                                companyId: inviteDetails['companyId'],
                                companyName: inviteDetails['companyName'],
                                role: inviteDetails['roles']);

                            if (shipperId != null) {
                              //place shipper id in company table
                              addUserToCompany(inviteDetails['companyId'],
                                  shipperId, context);

                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              prefs.setString('uid', firebaseUser.user!.uid);

                              await deleteInviteLink(widget.inviteID);

                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const HomeScreenWeb()));
                            } else {
                              showSnackBar(
                                  "Something Went Wrong!!",
                                  deleteButtonColor,
                                  const Icon(Icons.error_outline_sharp),
                                  context);
                            }
                          } else {
                            showSnackBar(
                                "Something Went Wrong!!",
                                deleteButtonColor,
                                const Icon(Icons.error_outline_sharp),
                                context);
                            debugPrint("Something went wrong");
                          }
                        }

                        _formKey.currentState!.save();
                      },
                    ),

                    SizedBox(
                      height: space_4,
                    ),

                    Container(
                      padding: const EdgeInsets.only(left: 140, right: 100),
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
                            color: darkGreyish,
                          )),
                        ],
                      ),
                    ),

                    SignUpWithGoogleButton(
                      txt: "Join with Google",
                      onPressed: () async {
                        try {
                          UserCredential firebaseUser =
                              await signInWithGoogle();

                          Map? inviteDetails =
                              await getInviteDetails(widget.inviteID);

                          if (inviteDetails != null && firebaseUser != null) {
                            if (inviteDetails['receiverMailId'] !=
                                firebaseUser.user!.email) {
                              showSnackBar(
                                  "Wrong Email!!",
                                  deleteButtonColor,
                                  const Icon(Icons.error_outline_sharp),
                                  context);
                              return;
                            }

                            //create shipper account
                            final shipperId = await createUpdateEmployee(
                                emailId: firebaseUser.user!.email!,
                                shipperName: firebaseUser.user!.displayName ??
                                    'Untitled',
                                companyId: inviteDetails['companyId'],
                                companyName: inviteDetails['companyName'],
                                role: inviteDetails['roles']);

                            if (shipperId != null) {
                              //place shipper id in company table
                              addUserToCompany(inviteDetails['companyId'],
                                  shipperId, context);

                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              prefs.setString('uid', firebaseUser.user!.uid);
                              prefs.setBool('isGoogleLogin', true);
                              prefs.setString(
                                  'userEmail', firebaseUser.user!.email!);

                              runShipperApiPost(
                                  emailId: firebaseUser.user!.email.toString());

                              await deleteInviteLink(widget.inviteID);

                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const HomeScreenWeb()));
                            } else {
                              showSnackBar(
                                  "Something Went Wrong!!",
                                  deleteButtonColor,
                                  const Icon(Icons.error_outline_sharp),
                                  context);
                            }
                          } else {
                            showSnackBar(
                                "Something Went Wrong!!",
                                deleteButtonColor,
                                const Icon(Icons.error_outline_sharp),
                                context);
                            debugPrint("Something went wrong");
                          }
                        } on FirebaseAuthException catch (e) {
                          debugPrint("Error : $e");
                        }
                      },
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
