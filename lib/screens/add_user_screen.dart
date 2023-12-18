import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shipper_app/constants/colors.dart';
import 'package:shipper_app/constants/fontSize.dart';
import 'package:shipper_app/responsive.dart';
import 'package:sizer/sizer.dart';
import '../controller/shipperIdController.dart';
import '../functions/add_user_functions.dart';

class AddUser extends StatefulWidget {
  const AddUser({Key? key}) : super(key: key);

  @override
  State<AddUser> createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String phoneOrMail;
  bool isError = false;
  ShipperIdController shipperIdController = Get.put(ShipperIdController());
  String selectedRole = "EDITOR";

  List<String> dateRanges = ["ADMIN", "EDITOR", "VIEWER"];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Dialog(
      insetPadding: EdgeInsets.zero,
      child: FractionallySizedBox(
        widthFactor: Responsive.isMobile(context) ? 0.9 : 0.5,
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
                maxHeight: Responsive.isMobile(context)
                    ? screenHeight * 0.4
                    : screenHeight * 0.45,
                maxWidth: screenWidth * 0.7),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                children: [
                  ListBody(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Text(
                          "Invite Member",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.montserrat(
                              color: darkBlueTextColor,
                              fontWeight: FontWeight.w500,
                              fontSize: Responsive.isMobile(context)
                                  ? 14.sp
                                  : 4.75.sp),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            flex: 648,
                            child: Padding(
                              padding: Responsive.isMobile(context)
                                  ? const EdgeInsets.only(
                                      left: 20.0, top: 30, bottom: 30)
                                  : const EdgeInsets.only(
                                      left: 54.0, top: 30, bottom: 30),
                              child: Container(
                                alignment: Alignment.centerLeft,
                                padding:
                                    EdgeInsets.only(left: screenWidth * 0.01),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(7),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.2),
                                        spreadRadius: 5,
                                        blurRadius: 5,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                    color: white),
                                child: TextFormField(
                                  decoration: InputDecoration(
                                      fillColor: Colors.white,
                                      hintText: 'Enter Email Address',
                                      hintStyle: GoogleFonts.montserrat(
                                          fontWeight: FontWeight.w500,
                                          color: grey2,
                                          fontSize: Responsive.isMobile(context)
                                              ? screenHeight * 0.027
                                              : screenWidth * 0.012),
                                      border: InputBorder.none),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter an email address';
                                    } else if (!RegExp(
                                            r'\b[\w\.-]+@[\w\.-]+\.\w{2,4}\b')
                                        .hasMatch(value)) {
                                      return 'Please enter a valid email address';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    phoneOrMail = value.toString();
                                  },
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                              flex: 250,
                              child: Container(
                                height: 55,
                                margin: EdgeInsets.only(
                                    left: screenWidth * 0.008),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(7),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.2),
                                        spreadRadius: 5,
                                        blurRadius: 5,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                    color: white),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                      value: selectedRole,
                                      dropdownColor: Colors.white,
                                      alignment: Alignment.center,
                                      icon: Padding(
                                          padding: EdgeInsets.only(
                                              right: screenWidth * 0.015),
                                          child: Icon(
                                              Icons.arrow_drop_down,
                                              size: screenWidth * 0.02)),
                                      items: dateRanges.map((String role) {
                                        return DropdownMenuItem<String>(
                                          value: role,
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                left: screenWidth * 0.015),
                                            child: Text(role,
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.montserrat(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: screenWidth * 0.013,
                                                    color: Colors.black)),
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (newValue) {
                                        setState(() {
                                          selectedRole = newValue!;
                                        });
                                      }),
                                ),
                              )),
                          Expanded(
                              flex: 183,
                              child: Container(
                                margin: Responsive.isMobile(context)
                                    ? const EdgeInsets.only(
                                        left: 15, right: 15.0)
                                    : const EdgeInsets.only(
                                        left: 15, right: 50.0),
                                height: 50,
                                width: 22,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(2),
                                    color: darkBlueTextColor),
                                child: Padding(
                                  padding: Responsive.isMobile(context)
                                      ? EdgeInsets.symmetric(
                                          horizontal: screenWidth * 0.005)
                                      : const EdgeInsets.all(12.0),
                                  child: const Icon(
                                      size: 25, Icons.add, color: Colors.white),
                                ),
                              ))
                        ],
                      ),
                      SizedBox(
                        height: Responsive.isMobile(context) ? 0.005.h : 1.9.h,
                      ),
                      Container(
                        height: 55,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: Responsive.isMobile(context)
                                  ? screenWidth * 0.20
                                  : screenWidth * 0.18,
                              vertical:
                                  Responsive.isMobile(context) ? 3.0 : screenHeight * 0.01),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              backgroundColor: const Color(0xFF000066),
                            ),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                AddUserFunctions().sendEmailToEmployee(
                                    phoneOrMail,
                                    shipperIdController.companyName.value,
                                    shipperIdController.companyId.value,
                                    selectedRole,
                                    context);
                              }
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text('Send Invite',
                                    style: GoogleFonts.montserrat(
                                        color: white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: screenWidth * 0.0125)),
                                const Image(
                                    image: AssetImage(
                                        'assets/icons/telegramicon.png')),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
