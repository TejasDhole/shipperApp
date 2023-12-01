import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shipper_app/Web/screens/home_web.dart';
import 'package:shipper_app/Widgets/buttons/ConfirmButton.dart';
import 'package:shipper_app/Widgets/showSnackBarTop.dart';
import 'package:shipper_app/Widgets/webHeader.dart';
import 'package:shipper_app/constants/colors.dart';
import 'package:shipper_app/constants/fontSize.dart';
import 'package:shipper_app/constants/radius.dart';
import 'package:shipper_app/controller/shipperIdController.dart';
import 'package:shipper_app/functions/CompanyFirebase/createCompany.dart';
import 'package:shipper_app/functions/alert_dialog.dart';
import 'package:shipper_app/functions/shipperApis/runShipperApiPost.dart';
import 'package:sizer/sizer.dart';

class CompanyDetails extends StatefulWidget {
  final email;
  const CompanyDetails({Key? key, required this.email}) : super(key: key);

  @override
  State<CompanyDetails> createState() => _CompanyDetailsState();
}

class _CompanyDetailsState extends State<CompanyDetails> {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  ShipperIdController shipperIdController = Get.put(ShipperIdController());
  TextEditingController companyNameController = TextEditingController();
  TextEditingController companyPhoneController = TextEditingController();
  TextEditingController companyEmailController = TextEditingController();
  TextEditingController companyAddressController = TextEditingController();
  TextEditingController companyCityController = TextEditingController();
  TextEditingController companyStateController = TextEditingController();
  TextEditingController companyPinCodeController = TextEditingController();
  TextEditingController companyGSTNoController = TextEditingController();
  TextEditingController companyCinController = TextEditingController();

  bool allowToSubmit = true;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    companyEmailController.text  = widget.email;
    companyGSTNoController.text.toUpperCase();
    companyCinController.text.toUpperCase();
    return Scaffold(
      backgroundColor: formBackground,
      body: SingleChildScrollView(
        child: Center(
          child: SizedBox(
            height: screenHeight,
            width: screenWidth,
            child: Form(
              key: _formKey,
              child: SizedBox(
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
                            color: darkBlueTextColor,
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

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //Company Name Field
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.all(10),
                            child: TextFormField(
                              controller: companyNameController,
                              validator: (value) {
                                //company name is mandatory
                                if (value == null || value.isEmpty) {
                                  return 'Enter Company Name';
                                } else {
                                  return null;
                                }
                              },
                              autofocus: true,
                              decoration: InputDecoration(
                                fillColor: white,
                                filled: true,
                                suffixIcon: Transform.scale(
                                  scale: 1.5,
                                  child: const Icon(Icons.person,
                                      color: greyShade, size: 15),
                                ),
                                hintStyle: TextStyle(
                                    decorationColor: greyShade,
                                    fontSize: 2.h,
                                    color: hintTextColor),
                                hintText: 'Company Name',
                                focusedBorder: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)),
                                    borderSide:
                                        BorderSide(color: kLiveasyColor)),
                                contentPadding: EdgeInsets.only(left: 3.h),
                                border: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                ),
                              ),
                              style: GoogleFonts.montserrat(
                                  color: black,
                                  fontWeight: FontWeight.w400,
                                  fontSize: screenHeight * 0.019),
                            ),
                          ),
                        ),
                        //Company Phone Field
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.all(10),
                            child: TextFormField(
                              controller: companyPhoneController,
                              maxLength: 10,
                              validator: (value) {
                                //phone is not mandatory
                                //but if any one's enter phone no it should check whether it is correct or not
                                if (value != null &&
                                    value.isNotEmpty &&
                                    !value.isPhoneNumber) {
                                  if(value.length!=10){
                                    return 'Phone No Length is 10';
                                  }
                                  return 'Enter Valid Phone No';
                                } else {
                                  return null;
                                }
                              },
                              keyboardType: TextInputType.phone,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(10)
                              ],
                              autofocus: true,
                              decoration: InputDecoration(
                                fillColor: white,
                                filled: true,
                                suffixIcon: Transform.scale(
                                  scale: 1.5,
                                  child: const Icon(Icons.phone,
                                      color: greyShade, size: 15),
                                ),
                                hintStyle: TextStyle(
                                    decorationColor: greyShade,
                                    fontSize: 2.h,
                                    color: hintTextColor),
                                hintText: 'Company Phone No',
                                focusedBorder: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)),
                                    borderSide:
                                        BorderSide(color: kLiveasyColor)),
                                contentPadding: EdgeInsets.only(left: 3.h),
                                border: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
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
                        //Company Email Field
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.all(10),
                            child: TextFormField(
                              controller: companyEmailController,
                              validator: (value) {
                                //Company Email is mandatory
                                if (value != null && value.isNotEmpty) {
                                  if (!value.isEmail) {
                                    return 'Enter Valid Email Id';
                                  } else {
                                    return null;
                                  }
                                } else {
                                  return 'Enter Company Email Id';
                                }
                              },
                              keyboardType: TextInputType.emailAddress,
                              autofocus: true,
                              decoration: InputDecoration(
                                fillColor: white,
                                filled: true,
                                suffixIcon: Transform.scale(
                                  scale: 1.5,
                                  child: const Icon(
                                      Icons.alternate_email_outlined,
                                      color: greyShade,
                                      size: 15),
                                ),
                                hintStyle: TextStyle(
                                    decorationColor: greyShade,
                                    fontSize: 2.h,
                                    color: hintTextColor),
                                hintText: 'Company Email',
                                focusedBorder: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)),
                                    borderSide:
                                        BorderSide(color: kLiveasyColor)),
                                contentPadding: EdgeInsets.only(left: 3.h),
                                border: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
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
                      ],
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.all(10),
                            child: TextFormField(
                              controller: companyAddressController,
                              validator: (value) {
                                //address is mandatory
                                if (value != null && value.isNotEmpty) {
                                  return null;
                                } else {
                                  return 'Enter Company Address';
                                }
                              },
                              autofocus: true,
                              decoration: InputDecoration(
                                fillColor: white,
                                filled: true,
                                suffixIcon: Transform.scale(
                                  scale: 1.5,
                                  child: const Icon(Icons.location_city,
                                      color: greyShade, size: 15),
                                ),
                                hintStyle: TextStyle(
                                    decorationColor: greyShade,
                                    fontSize: 2.h,
                                    color: hintTextColor),
                                hintText: 'Address',
                                focusedBorder: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)),
                                    borderSide:
                                        BorderSide(color: kLiveasyColor)),
                                contentPadding: EdgeInsets.only(left: 3.h),
                                border: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
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
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.all(10),
                            child: TextFormField(
                              controller: companyCityController,
                              validator: (value) {
                                //city is mandatory
                                if (value != null && value.isNotEmpty) {
                                  return null;
                                } else {
                                  return 'Enter City';
                                }
                              },
                              autofocus: true,
                              decoration: InputDecoration(
                                fillColor: white,
                                filled: true,
                                suffixIcon: Transform.scale(
                                  scale: 1.5,
                                  child: const Icon(Icons.location_city,
                                      color: greyShade, size: 15),
                                ),
                                hintStyle: TextStyle(
                                    decorationColor: greyShade,
                                    fontSize: 2.h,
                                    color: hintTextColor),
                                hintText: 'City',
                                focusedBorder: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)),
                                    borderSide:
                                        BorderSide(color: kLiveasyColor)),
                                contentPadding: EdgeInsets.only(left: 3.h),
                                border: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
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
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.all(10),
                            child: TextFormField(
                              controller: companyStateController,
                              validator: (value) {
                                //state is mandatory
                                if (value != null && value.isNotEmpty) {
                                  return null;
                                } else {
                                  return 'Enter State';
                                }
                              },
                              autofocus: true,
                              decoration: InputDecoration(
                                fillColor: white,
                                filled: true,
                                suffixIcon: Transform.scale(
                                  scale: 1.5,
                                  child: const Icon(Icons.location_city,
                                      color: greyShade, size: 15),
                                ),
                                hintStyle: TextStyle(
                                    decorationColor: greyShade,
                                    fontSize: 2.h,
                                    color: hintTextColor),
                                hintText: 'State',
                                focusedBorder: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)),
                                    borderSide:
                                        BorderSide(color: kLiveasyColor)),
                                contentPadding: EdgeInsets.only(left: 3.h),
                                border: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
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
                      ],
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.all(10),
                            child: TextFormField(
                              controller: companyPinCodeController,
                              validator: (value) {
                                //pinCode is mandatory
                                if (value != null &&
                                    value.isNotEmpty &&
                                    value.isNum && value.length == 6) {
                                  return null;
                                } else {
                                  return 'Enter Valid PinCode';
                                }
                              },
                              maxLength: 6,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(6)
                              ],
                              autofocus: true,
                              decoration: InputDecoration(
                                fillColor: white,
                                filled: true,
                                suffixIcon: Transform.scale(
                                  scale: 1.5,
                                  child: const Icon(Icons.numbers,
                                      color: greyShade, size: 15),
                                ),
                                hintStyle: TextStyle(
                                    decorationColor: greyShade,
                                    fontSize: 2.h,
                                    color: hintTextColor),
                                hintText: 'PinCode',
                                focusedBorder: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)),
                                    borderSide:
                                        BorderSide(color: kLiveasyColor)),
                                contentPadding: EdgeInsets.only(left: 3.h),
                                border: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
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
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.all(10),
                            child: TextFormField(
                              controller: companyGSTNoController,
                              maxLength: 15,
                              validator: (value) {
                                if (value != null &&
                                    value.isNotEmpty &&
                                    value.length == 15) {
                                  return null;
                                }
                                else {
                                  return 'Enter GST No';
                                }
                              },
                              autofocus: true,
                              decoration: InputDecoration(
                                suffixIcon: Transform.scale(
                                  scale: 1.5,
                                  child: const Icon(Icons.numbers,
                                      color: greyShade, size: 15),
                                ),
                                hintStyle: TextStyle(
                                    decorationColor: greyShade,
                                    fontSize: 2.h,
                                    color: hintTextColor),
                                hintText: 'GST No',
                                focusedBorder: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)),
                                    borderSide:
                                        BorderSide(color: kLiveasyColor)),
                                fillColor: white,
                                filled: true,
                                contentPadding: EdgeInsets.only(left: 3.h),
                                border: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
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
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.all(10),
                            child: TextFormField(
                              controller: companyCinController,
                              validator: (value) {
                                if (value != null &&
                                    value.isNotEmpty && value.length == 21) {
                                  return null;
                                } else {
                                  return 'Enter CIN';
                                }
                              },
                              autofocus: true,
                              maxLength: 21,
                              decoration: InputDecoration(
                                suffixIcon: Transform.scale(
                                  scale: 1.5,
                                  child: const Icon(Icons.numbers,
                                      color: greyShade, size: 15),
                                ),
                                hintStyle: TextStyle(
                                    decorationColor: greyShade,
                                    fontSize: 2.h,
                                    color: hintTextColor),
                                hintText: 'CIN',
                                focusedBorder: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)),
                                    borderSide:
                                        BorderSide(color: kLiveasyColor)),
                                fillColor: white,
                                filled: true,
                                contentPadding: EdgeInsets.only(left: 3.h),
                                border: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
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
                      ],
                    ),

                    Padding(
                      padding:
                          EdgeInsets.only(left: 10.w, top: 6.h, right: 7.w),
                      child: Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: darkBlueTextColor,
                            borderRadius: BorderRadius.circular(radius_1),
                          ),
                          child: ConfirmButton(
                            text: 'Confirm',
                            onPressed: () async {
                              if (_formKey.currentState!.validate() && allowToSubmit) {
                                _formKey.currentState!.save();
                                allowToSubmit = false;
                                try {
                                    await createCompany(companyNameController.text,
                                    companyEmailController.text,
                                    companyPhoneController.text,
                                    companyAddressController.text,
                                    companyCityController.text,
                                    companyStateController.text,
                                    companyPinCodeController.text,
                                    companyGSTNoController.text,
                                    companyCinController.text,
                                    firebaseAuth.currentUser!.email!);

                                    showSnackBar('Resgistration Successful', truckGreen, Icon(Icons.check), context);

                                    SharedPreferences prefs =
                                    await SharedPreferences
                                        .getInstance();

                                    prefs.setString(
                                        'uid', FirebaseAuth.instance.currentUser!.uid!);
                                    prefs.setBool('isGoogleLogin', true);
                                    prefs.setString('userEmail',
                                        FirebaseAuth.instance.currentUser!.email!);
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                            const HomeScreenWeb()));
                                } catch (e) {
                                  showSnackBar(e.toString(), deleteButtonColor, Icon(Icons.report_gmailerrorred_rounded), context);
                                  debugPrint('Error : $e');
                                  allowToSubmit = true;
                                }
                              }
                            },
                          )),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

}
