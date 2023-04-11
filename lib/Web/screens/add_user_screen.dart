import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shipper_app/responsive.dart';
import 'package:sizer/sizer.dart';
import '../../controller/shipperIdController.dart';
import '/functions/add_user_functions.dart';

class AddUser extends StatefulWidget {
  const AddUser({Key? key}) : super(key: key);

  @override
  State<AddUser> createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String mail;
  late String phoneNumber;
  bool isError = false;
  ShipperIdController shipperIdController = Get.put(ShipperIdController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: 10.h,
              ),
              //TODO: We are using to form types, one is for mobile and the other for desktop or tablet
              Responsive.isMobile(context)
                  ? Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 3.w, top: 5.h),
                            child: Text(
                              "Add User/ Employee",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.sp),
                            ),
                          ), //Company Details
                          SizedBox(
                            height: 2.h,
                          ),
                          //TODO: Email Id text form field
                          Padding(
                            padding: EdgeInsets.only(
                                left: 3.w, top: 5.h, right: 3.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Email Id",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15.sp),
                                ),
                                SizedBox(
                                  height: 1.9.h,
                                ),
                                TextFormField(
                                  decoration: const InputDecoration(
                                    hintText: 'Enter Mail Id',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15)),
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
                                    mail = value.toString();
                                  },
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 2.h,
                          ),
                          Center(
                              child: Text(
                            'OR',
                            style: TextStyle(
                                fontSize: 10.sp, fontFamily: 'Montserrat'),
                          )),
                          //TODO: Phone Number text form field
                          Padding(
                            padding: EdgeInsets.only(
                                left: 3.w, top: 5.h, right: 3.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Phone Number",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15.sp),
                                ),
                                SizedBox(
                                  height: 1.9.h,
                                ),
                                TextFormField(
                                  decoration: const InputDecoration(
                                    hintText: 'Enter Phone Number',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15)),
                                    ),
                                  ),
                                  validator: (value) {
                                    // if(value.toString().isEmpty){
                                    //   setState(() {
                                    //     isError = true;
                                    //   });
                                    //   return "Enter Employee's Phone Number";
                                    // }
                                    if (value.toString().isNotEmpty) {
                                      if (value.toString().length != 10) {
                                        setState(() {
                                          isError = true;
                                        });
                                        return "Phone Number Must be 10 digits";
                                      }
                                      if (!value.toString().isNum) {
                                        setState(() {
                                          isError = true;
                                        });
                                        return "Invalid Phone Number";
                                      }
                                    }
                                    setState(() {
                                      isError = false;
                                    });
                                    return null;
                                  },
                                  onSaved: (value) {
                                    phoneNumber = value.toString();
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                          //TODO: Add employee Button
                          Center(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                backgroundColor: const Color(0xFF000066),
                              ),
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  _formKey.currentState!.save();
                                  // print(companyName);
                                  // print(phoneNumber);
                                  await AddUserFunctions().addUser(
                                      phoneNumber,
                                      shipperIdController.companyName
                                          .toString(),
                                      mail,
                                      context: context);
                                }
                              },
                              child: Text(
                                'Add Employee',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Form(
                      key: _formKey,
                      child: Container(
                        width: 45.w,
                        height: isError ? 70.h : 67.h,
                        decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(30)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 3.w, top: 5.h),
                              child: Text(
                                "Add User/ Employee",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 6.sp),
                              ),
                            ), //Company Details
                            SizedBox(
                              height: 2.h,
                            ),
                            //TODO: Email Id text form field
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 3.w, top: 5.h, right: 3.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Email Id",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 4.5.sp),
                                  ),
                                  SizedBox(
                                    height: 1.9.h,
                                  ),
                                  TextFormField(
                                    decoration: const InputDecoration(
                                      hintText: 'Enter Mail Id',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15)),
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
                                      mail = value.toString();
                                    },
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 2.h,
                            ),
                            Center(
                                child: Text(
                              'OR',
                              style: TextStyle(
                                  fontSize: 4.sp, fontFamily: 'Montserrat'),
                            )),
                            //TODO: Phone Number text form field
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 3.w, top: 5.h, right: 3.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Phone Number",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 4.5.sp),
                                  ),
                                  SizedBox(
                                    height: 1.9.h,
                                  ),
                                  TextFormField(
                                    decoration: const InputDecoration(
                                      hintText: 'Enter Phone Number',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15)),
                                      ),
                                    ),
                                    validator: (value) {
                                      // if(value.toString().isEmpty){
                                      //   setState(() {
                                      //     isError = true;
                                      //   });
                                      //   return "Enter Employee's Phone Number";
                                      // }
                                      if (value.toString().isNotEmpty) {
                                        if (value.toString().length != 10) {
                                          setState(() {
                                            isError = true;
                                          });
                                          return "Phone Number Must be 10 digits";
                                        }
                                        if (!value.toString().isNum) {
                                          setState(() {
                                            isError = true;
                                          });
                                          return "Invalid Phone Number";
                                        }
                                      }
                                      setState(() {
                                        isError = false;
                                      });
                                      return null;
                                    },
                                    onSaved: (value) {
                                      phoneNumber = value.toString();
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 50,
                            ),
                            //TODO: Add employee button
                            Center(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  backgroundColor: const Color(0xFF000066),
                                  fixedSize: Size(28.w, 7.h),
                                ),
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    _formKey.currentState!.save();
                                    // print(companyName);
                                    // print(phoneNumber);
                                    await AddUserFunctions().addUser(
                                        phoneNumber,
                                        shipperIdController.companyName
                                            .toString(),
                                        mail,
                                        context: context);
                                  }
                                },
                                child: Text(
                                  'Add Employee',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 4.3.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
