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
      
      child: FractionallySizedBox(
        widthFactor: 0.5,
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.45,
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
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            flex: 837,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 54.0, top: 30,bottom:30),
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
                            flex: 163,
                            child:
                              Container(

                                margin: EdgeInsets.only(left: 15,right:50.0),
                                  height: 50,
                                  width: 30,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(2),
                                    color: darkBlueTextColor
                                  ),
                                  
                              // const Align(alignment: Alignment.center,
                                 child: 
                              const Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Icon(size: 25,Icons.add, color: Colors.white),
                              ),)
                            
                          )
                        ],
                      ),

                      //   ],
                      // ),
                      SizedBox(
                        height: 1.9.h,
                      ),

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
      
    );
  }
}
