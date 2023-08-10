import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shipper_app/constants/colors.dart';
import 'package:shipper_app/constants/fontSize.dart';
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
  String selectedRole = "employee";
  // List<DropdownMenuItem<String>> _dropDownItem() {
  //   List<String> roles = ['employee', 'owner'];
  //   return roles
  //       .map((value) => DropdownMenuItem(value: value, child: Text(value)))
  //       .toList();
  // }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.zero,
      // title: Padding(
      //   padding: const EdgeInsets.only(top: 16.0),
      //   child: Text(
      //     "Invite Member",
      //     textAlign: TextAlign.center,
      //     style: GoogleFonts.montserrat(
      //         color: darkBlueTextColor,
      //         fontWeight: FontWeight.w500,
      //         fontSize: kIsWeb ? 4.75.sp : 16.sp),
      //   ),
      // ),
      child: FractionallySizedBox(
        widthFactor: 0.5,
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.4,
                maxWidth: MediaQuery.of(context).size.width *
                    0.7 // Adjust the height as needed
                ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                children: [
                  ListBody(
                    children: <Widget>[
                      // Text(
                      //   "Invite Member",
                      //   style: TextStyle(
                      //       fontWeight: FontWeight.bold,
                      //       color: darkBlueTextColor,
                      //       fontSize: kIsWeb ? 3.5.sp : 12.5.sp),
                      // ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Text(
                          "Invite Member",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.montserrat(
                              color: darkBlueTextColor,
                              fontWeight: FontWeight.w500,
                              fontSize: kIsWeb ? 4.75.sp : 16.sp),
                        ),
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 4,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 55.0, vertical: 30),
                              child: TextFormField(
                                decoration: InputDecoration(
                                  labelText: 'Email',
                                  floatingLabelAlignment:
                                      FloatingLabelAlignment.start,
                                  floatingLabelStyle: GoogleFonts.montserrat(
                                      color: darkBlueTextColor,
                                      fontWeight: FontWeight.w500),
                                  hintText: 'Enter Email Address ',
                                  border: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(2)),
                                  ),
                                ),
                                validator: (value) {
                                  // if(value.toString().isEmpty){
                                  //   setState(() {
                                  //     isError = true;
                                  //   });
                                  //   return "Enter employee Mail Id";
                                  // }
                                  setState(() {
                                    isError = false;
                                  });
                                  return null;
                                },
                                onSaved: (value) {
                                  phoneOrMail = value.toString();
                                },
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Stack(children: [
                              Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(2),
                                    color: darkBlueTextColor
                                  ),
                                  ),
                              // const Align(alignment: Alignment.center,
                              //   child: 
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Icon(size: 25,Icons.add, color: Colors.white),
                              )
                            ]),
                          )
                        ],
                      ),

                      //   ],
                      // ),
                      SizedBox(
                        height: 1.9.h,
                      ),
                      // Text(
                      //   "Role :",
                      //   style: TextStyle(
                      //       fontWeight: FontWeight.bold,
                      //       fontSize: kIsWeb ? 3.5.sp : 12.5.sp),
                      // ),
                      // SizedBox(
                      //   width: 10.w,
                      //   child: DropdownButton(
                      //     value: selectedRole,
                      //     items: _dropDownItem(),
                      //     onChanged: (value) {
                      //       setState(() {
                      //         selectedRole = value!;
                      //       });
                      //     },
                      //   ),
                      // ),

                      Container(
                        height: 55,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 265.0, vertical: 10.0),
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
                                await AddUserFunctions().addUser(phoneOrMail,
                                    shipperIdController.companyName.value,
                                    context: context, role: selectedRole);
                              }
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text('Send Invite',
                                    style: GoogleFonts.montserrat(
                                        fontWeight: FontWeight.w600,
                                        fontSize: size_8)),
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
      //actions: <Widget>[
      // Container(
      //   width: 160,
      //   child: ElevatedButton(
      //     style: ElevatedButton.styleFrom(
      //       shape: RoundedRectangleBorder(
      //         borderRadius: BorderRadius.circular(5),
      //       ),
      //       backgroundColor: const Color(0xFF000066),
      //     ),
      //     onPressed: () async {
      //       if (_formKey.currentState!.validate()) {
      //         _formKey.currentState!.save();
      //         await AddUserFunctions().addUser(
      //             phoneOrMail, shipperIdController.companyName.value,
      //             context: context, role: selectedRole);
      //       }
      //     },
      //     child: Row(
      //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //       children: [
      //         Text('Send Invite',
      //             style: GoogleFonts.montserrat(
      //                 fontWeight: FontWeight.w600, fontSize: size_8)),
      //         const Image(image: AssetImage('assets/icons/telegramicon.png')),
      //       ],
      //     ),
      //   ),
      // ),
      // ElevatedButton(
      //     style: ElevatedButton.styleFrom(
      //       shape: RoundedRectangleBorder(
      //         borderRadius: BorderRadius.circular(25),
      //       ),
      //       backgroundColor: Colors.white,
      //       // fixedSize: Size(28.w, 7.h),
      //     ),
      //     onPressed: () {
      //       Navigator.pop(context);
      //     },
      //     child: const Text(
      //       "Cancel",
      //       style: TextStyle(
      //         color: Color(0xFF000066),
      //         fontWeight: FontWeight.bold,
      //       ),
      //     )),
      //],
    );
  }
}
