import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '/../Widgets/liveasy_Icon_Widgets.dart';
import '/functions/add_user_functions.dart';

class AddUser extends StatefulWidget {
  const AddUser({Key? key}) : super(key: key);

  @override
  State<AddUser> createState() => _AddUserState();

}

class _AddUserState extends State<AddUser> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String companyName;
  late String phoneNumber;
  bool isError = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 10.h,),
              Form(
                key: _formKey,
                child: Container(
                  width: 45.w,
                  height: isError?68.h:65.h,
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: const BorderRadius.all(Radius.circular(30)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 3.w,top: 5.h),
                        child: Text("Add User/ Employee",
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              fontSize: 6.sp
                          ),
                        ),
                      ),//Company Details
                      SizedBox(height: 2.h,),
                      Padding(
                        padding: EdgeInsets.only(left: 3.w,top: 5.h,right: 3.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Email Id",
                              style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 4.5.sp
                              ),
                            ),
                            SizedBox(height: 1.9.h,),
                            TextFormField(
                              decoration: const InputDecoration(
                                hintText: 'Enter Mail Id',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(15)),
                                ),
                              ),
                              validator: (value){
                                if(value.toString().isEmpty){
                                  setState(() {
                                    isError = true;
                                  });
                                  return "Enter employee Mail Id";
                                }
                                setState(() {
                                  isError = false;
                                });
                                return null;
                              },
                              onSaved: (value){
                                companyName = value.toString();
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 2.h,),
                      Center(child: Text('OR',style: TextStyle(fontSize: 4.sp,fontFamily: 'Montserrat'),)),
                      Padding(
                        padding: EdgeInsets.only(left: 3.w,top: 5.h,right: 3.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Phone Number",
                              style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 4.5.sp
                              ),
                            ),
                            SizedBox(height: 1.9.h,),
                            TextFormField(
                              decoration: const InputDecoration(
                                hintText: 'Enter Phone Number',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(15)),
                                ),
                              ),
                              validator: (value){
                                if(value.toString().isEmpty){
                                  setState(() {
                                    isError = true;
                                  });
                                  return "Enter Employee's Phone Number";
                                }
                                if(value.toString().length!=10){
                                  setState(() {
                                    isError = true;
                                  });
                                  return "Phone Number Must be 10 digits";
                                }
                                if(!value.toString().isNum){
                                  setState(() {
                                    isError = true;
                                  });
                                  return "Invalid Phone Number";
                                }
                                setState(() {
                                  isError = false;
                                });
                                return null;
                              },
                              onSaved: (value){
                                phoneNumber = value.toString();
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 50,),
                      Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25),),
                            backgroundColor: const Color(0xFF000066),
                            fixedSize: Size(28.w, 7.h),
                          ),
                          onPressed: () async{
                            if(_formKey.currentState!.validate()){
                              _formKey.currentState!.save();
                              // print(companyName);
                              // print(phoneNumber);
                              await AddUserFunctions().addUser(phoneNumber, companyName,context);
                            }
                          },
                          child: Text('Add Employee',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Montserrat',
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
