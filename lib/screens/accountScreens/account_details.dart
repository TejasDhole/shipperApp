import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shipper_app/Widgets/Input_text_filed.dart';
import 'package:shipper_app/constants/colors.dart';
import 'package:shipper_app/constants/fontSize.dart';
import 'package:shipper_app/constants/spaces.dart';
import 'package:shipper_app/controller/shipperIdController.dart';
import 'package:shipper_app/functions/shipperApis/updateUserDetails.dart';
import 'package:shipper_app/responsive.dart';
import 'package:shipper_app/screens/add_user_screen.dart';
import 'package:http/http.dart' as http;

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  AccountScreenState createState() => AccountScreenState();
}

class AccountScreenState extends State<AccountScreen> {
  ShipperIdController shipperIdController = Get.put(ShipperIdController());
  GetStorage sidstorage = GetStorage('ShipperIDStorage');
  TextEditingController nameController = TextEditingController();
  TextEditingController roleController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController companyNameController = TextEditingController();

  //company email is uneditable
  TextEditingController companyEmailController = TextEditingController();
  TextEditingController gstNoController = TextEditingController();
  TextEditingController cinController = TextEditingController();

  //e-way is not visible and editable by the ADMIN only
  TextEditingController ewayUserID = TextEditingController();
  TextEditingController ewayPassword = TextEditingController();

  bool isUserDetailsEditing = false;

  //only admin should have the right to edit company details
  bool isCompanyDetailsEditing = false;
  bool passwordObscure = true;

  @override
  void initState() {
    super.initState();
  }

  //Gets eway bill details using company Id
  getEwayBillUser(String companyId) async {
    if (shipperIdController.role.value == "ADMIN") {
      try {
        final String ewayURL = dotenv.get('ewayBillUser');

        final response = await http.get(Uri.parse(
            "$ewayURL/ewayBillUser/${shipperIdController.companyId.value}"));

        if (response.statusCode == 200) {
          var data = jsonDecode(response.body);
          ewayUserID.text = data['username'];
          ewayPassword.text = data['password'];
        }
      } catch (error) {
        debugPrint(error.toString());
      }
    }
  }

  updateEwayBillUser() async {
    if (shipperIdController.role.value == "ADMIN") {
      try {
        final String ewayURL = dotenv.get('ewayBillUser');

        Map data = {
          "username": ewayUserID.text.toString(),
          "password": ewayPassword.text.toString()
        };

        var body = json.encode(data);

        final response = await http.put(
            Uri.parse(
                "$ewayURL/updateEwayBill?userId=${shipperIdController.companyId.value}"),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: body);

        if (response.statusCode == 200) {
          var data = jsonDecode(response.body);
          ewayUserID.text = data['username'];
          ewayPassword.text = data['password'];
        }
      } catch (error) {
        debugPrint(error.toString());
      }
    }
  }

  //get company details using company Id
  getCompanyDetails(String companyId) async {
    final DocumentReference documentRef =
        FirebaseFirestore.instance.collection('/Companies').doc(companyId);

    await documentRef.get().then((doc) {
      if (doc.exists) {
        Map data = doc.data() as Map;
        companyNameController.text = data["company_details"]["company_name"];
        gstNoController.text = data["company_details"]["gst_no"];
        cinController.text = data["company_details"]["cin"];
        companyEmailController.text =
            data["company_details"]["contact_info"]["company_email"];
      } else {
        debugPrint('No such document!');
      }
    });
  }

  updateCompanyDetails() {
    final DocumentReference documentRef = FirebaseFirestore.instance
        .collection('/Companies')
        .doc(shipperIdController.companyId.value);

    documentRef.update({
      'company_details.company_name': companyNameController.text,
      'company_details.gst_no': gstNoController.text,
      'company_details.cin': cinController.text
    }).then((_) {
      shipperIdController.updateCompanyName(companyNameController.text);
    }).catchError((error) => debugPrint('Failed: $error'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Responsive.isMobile(context)
          ? AppBar(
              elevation: 0,
              backgroundColor: darkBlueColor,
              title: Row(
                children: [
                  Image.asset(
                    'assets/icons/liveasyicon.png',
                    width: 20,
                    height: 20,
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Liveasy',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.menu,
                  ),
                ),
              ],
            )
          : null,
      backgroundColor: headerLightBlueColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Responsive.isMobile(context)
                ? const Center(
                    child: Text(
                      'My Account Details',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Montserrat',
                        color: darkBlueColor,
                      ),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Row(
                      children: [
                        const Text(
                          'My Account Details',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Montserrat',
                            color: darkBlueColor,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          Icons.circle,
                          color: liveasyGreen,
                          size: 10,
                        ),
                        SizedBox(width: space_1),
                        Text(
                          'online',
                          style: TextStyle(
                            fontSize: 18,
                            color: liveasyGreen,
                          ),
                        ),
                      ],
                    ),
                  ),
            SizedBox(height: space_2),
            Stack(
              children: [
                Container(
                  height: Responsive.isMobile(context) ? 200 : 150,
                  padding: EdgeInsets.zero,
                  margin: const EdgeInsets.only(top: 5, bottom: 5),
                  decoration: const BoxDecoration(color: headerLightBlueColor),
                ),
                Positioned(
                  top: Responsive.isMobile(context) ? 120 : 112,
                  right: Responsive.isMobile(context) ? 5 : 65,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            isUserDetailsEditing = !isUserDetailsEditing;

                            if (!isUserDetailsEditing) {
                              nameController.text =
                                  shipperIdController.name.value;

                              companyNameController.text =
                                  shipperIdController.companyName.value;
                            }

                            if (shipperIdController.role.value == "ADMIN") {
                              //company details should only be editable by admin
                              isCompanyDetailsEditing =
                                  !isCompanyDetailsEditing;
                              getCompanyDetails(
                                  shipperIdController.companyId.value);
                            }
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              isUserDetailsEditing ? white : darkBlueColor,
                          foregroundColor:
                              isUserDetailsEditing ? darkBlueColor : white,
                          side: isUserDetailsEditing
                              ? const BorderSide(
                                  color: darkBlueColor, width: 2.0)
                              : BorderSide.none,
                          minimumSize: Responsive.isMobile(context)
                              ? const Size(80, 35)
                              : const Size(100, 40),
                        ),
                        child: Text(
                          "Edit",
                          style: TextStyle(
                            color: isUserDetailsEditing
                                ? Colors.black
                                : Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(width: space_2),
                      ElevatedButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return const AddUser();
                              });
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: Responsive.isMobile(context)
                              ? const Size(80, 35)
                              : const Size(100, 40),
                          backgroundColor: darkBlueColor,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Send Invite',
                              style: TextStyle(fontSize: space_3),
                            ),
                            const Image(
                              image:
                                  AssetImage('assets/icons/telegramicon.png'),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  height: Responsive.isMobile(context) ? 70 : 95,
                  margin: const EdgeInsets.only(top: 5, bottom: 5),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [Color(0xFFE6E4E4), Color(0xFFFFFFFF)],
                    ),
                  ),
                ),
                Positioned(
                  left: Responsive.isMobile(context) ? 8 : 35,
                  top: Responsive.isMobile(context) ? 40 : 45,
                  child: Container(
                    width: 90,
                    height: Responsive.isMobile(context) ? 70 : 90,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 3.0),
                      shape: BoxShape.circle,
                      color: const Color(0xFFAD8EE0),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.person,
                        size: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            (Responsive.isMobile(context))
                ? Column(
                    children: [
                      InputTextField(
                        labelText: 'Name',
                        isEditing: isUserDetailsEditing,
                        controller: nameController,
                      ),
                      const SizedBox(height: 10),
                      InputTextField(
                        labelText: 'Role',
                        isEditing: false,
                        controller: roleController,
                      ),
                      const SizedBox(height: 10),
                      InputTextField(
                        labelText: 'Email',
                        isEditing: false,
                        controller: emailController,
                      ),
                      const SizedBox(height: 10),
                      InputTextField(
                        labelText: 'Phone Number',
                        isEditing: false,
                        controller: phoneNumberController,
                      ),
                      const SizedBox(height: 10),
                      InputTextField(
                        labelText: 'Company Name',
                        isEditing: isUserDetailsEditing,
                        controller: companyNameController,
                      ),
                      SizedBox(height: space_2),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 5),
                        child: Text(
                          "User Details",
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: size_9,
                              color: kLiveasyColor,
                              fontWeight: FontWeight.w700),
                        ),
                      ),

                      Obx(() {
                        nameController.text = shipperIdController.name.value;
                        roleController.text = shipperIdController.role.value;
                        return Row(
                          children: [
                            Flexible(
                              child: InputTextField(
                                controller: nameController,
                                isEditing: isUserDetailsEditing,
                                labelText: 'Name',
                              ),
                            ),
                            SizedBox(width: space_5),
                            Flexible(
                              child: InputTextField(
                                controller: roleController,
                                isEditing: false,
                                labelText: 'Role',
                              ),
                            ),
                          ],
                        );
                      }),
                      SizedBox(height: space_3),
                      Obx(() {
                        emailController.text =
                            FirebaseAuth.instance.currentUser!.email.toString();
                        phoneNumberController.text =
                            shipperIdController.mobileNum.value;

                        return Row(
                          children: [
                            Flexible(
                              child: InputTextField(
                                controller: emailController,
                                isEditing: false,
                                labelText: 'Email',
                              ),
                            ),
                            SizedBox(width: space_5),
                            Flexible(
                              child: InputTextField(
                                controller: phoneNumberController,
                                isEditing: false,
                                labelText: 'Phone Number',
                              ),
                            ),
                          ],
                        );
                      }),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 5),
                        child: Text(
                          "Company Details",
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: size_9,
                              color: kLiveasyColor,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                      Obx(() {
                        return FutureBuilder(
                          future: getCompanyDetails(
                              shipperIdController.companyId.value),
                          builder: (context, snapshot) {
                            return Row(
                              children: [
                                Flexible(
                                  child: InputTextField(
                                    controller: companyNameController,
                                    isEditing: isCompanyDetailsEditing,
                                    labelText: 'Company Name',
                                  ),
                                ),
                                SizedBox(width: space_5),
                                Flexible(
                                  child: InputTextField(
                                    controller: companyEmailController,
                                    isEditing: false,
                                    labelText: 'Company Email',
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      }),
                      SizedBox(height: space_3),
                      Obx(() {
                        return FutureBuilder(
                          future: getCompanyDetails(
                              shipperIdController.companyId.value),
                          builder: (context, snapshot) {
                            return Row(
                              children: [
                                Flexible(
                                  child: InputTextField(
                                    controller: gstNoController,
                                    isEditing: isCompanyDetailsEditing,
                                    labelText: 'GST no',
                                  ),
                                ),
                                SizedBox(width: space_5),
                                Flexible(
                                  child: InputTextField(
                                    controller: cinController,
                                    isEditing: isCompanyDetailsEditing,
                                    labelText: 'CIN',
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      }),
                      Obx(() => Visibility(
                            visible: shipperIdController.role.value == "ADMIN"
                                ? true
                                : false,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 5),
                              child: Text(
                                "E-way Bill credentials",
                                style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: size_9,
                                    color: kLiveasyColor,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                          )),
                      Obx(() => Visibility(
                            visible: shipperIdController.role.value == "ADMIN"
                                ? true
                                : false,
                            child: FutureBuilder(
                              future: getEwayBillUser(
                                  shipperIdController.companyId.value),
                              builder: (context, snapshot) {
                                return Row(
                                  children: [
                                    Flexible(
                                      child: InputTextField(
                                        controller: ewayUserID,
                                        isEditing: isCompanyDetailsEditing,
                                        labelText: 'User Id',
                                      ),
                                    ),
                                    SizedBox(width: space_5),
                                    Flexible(
                                        child: Container(
                                      margin: EdgeInsets.all(8),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Password',
                                            style: TextStyle(
                                                fontFamily: 'Montserrat',
                                                fontSize: size_7,
                                                color: black,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          TextFormField(
                                              controller: ewayPassword,
                                              readOnly:
                                                  !isCompanyDetailsEditing,
                                              obscureText: passwordObscure,
                                              obscuringCharacter: '*',
                                              style: TextStyle(
                                                  fontFamily: 'Montserrat',
                                                  fontSize: size_7,
                                                  color: black,
                                                  fontWeight: FontWeight.w600),
                                              decoration: InputDecoration(
                                                contentPadding:
                                                    const EdgeInsets.fromLTRB(
                                                        10, 0, 0, 0),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                      width: 2,
                                                      color: lightGrey),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          2.0),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                    width: 2,
                                                    color: black,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          2.0),
                                                ),
                                                suffixIcon: IconButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      passwordObscure =
                                                          !passwordObscure;
                                                    });
                                                  },
                                                  icon: Icon(
                                                      passwordObscure
                                                          ? FontAwesomeIcons.eye
                                                          : FontAwesomeIcons
                                                              .eyeSlash,
                                                      size: 15,
                                                      color: Colors.black),
                                                ),
                                                alignLabelWithHint: true,
                                              ),
                                              cursorColor: darkBlueColor),
                                        ],
                                      ),
                                    )),
                                  ],
                                );
                              },
                            ),
                          )),
                    ],
                  ),
            SizedBox(height: Responsive.isMobile(context) ? 10 : 30),
            if (isUserDetailsEditing)
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Container(),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        if (nameController.text.isNotEmpty &&
                            companyNameController.text.isNotEmpty) {
                          await updateUserDetails(
                            uniqueID: shipperIdController.shipperId.value,
                            name: nameController.text,
                            companyName: companyNameController.text,
                          );

                          shipperIdController.updateName(nameController.text);
                          shipperIdController
                              .updateCompanyName(companyNameController.text);
                          sidstorage.write("name", nameController.text);
                          sidstorage.write(
                              "companyName", companyNameController.text);
                        } else {
                          showMySnackBar(context, "Update Company and Name");
                        }

                        if (shipperIdController.role.value == "ADMIN") {
                          if (gstNoController.text.isNotEmpty &&
                              companyNameController.text.isNotEmpty &&
                              cinController.text.isNotEmpty) {
                            updateCompanyDetails();
                          }

                          if (ewayUserID.text.isNotEmpty &&
                              ewayPassword.text.isNotEmpty) {
                            updateEwayBillUser();
                          }
                        }
                      } catch (e) {
                        debugPrint('Error updating user details: $e');
                      }
                      setState(() {
                        isUserDetailsEditing = false;
                        isCompanyDetailsEditing = false;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(100, 38),
                      backgroundColor: liveasyGreen,
                    ),
                    child: const Text(
                      'Save Changes',
                      style: TextStyle(color: white),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isUserDetailsEditing = false;
                        isCompanyDetailsEditing = false;
                        nameController.text = shipperIdController.name.value;
                        emailController.text =
                            FirebaseAuth.instance.currentUser!.email.toString();
                        phoneNumberController.text =
                            shipperIdController.mobileNum.value;
                        roleController.text = shipperIdController.role.value;
                        getCompanyDetails(shipperIdController.companyId.value);
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: white,
                      foregroundColor: red,
                      side: const BorderSide(color: red, width: 2.0),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: red),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(),
                  )
                ],
              ),
            const SizedBox(
              height: 40,
            ),
          ],
        ),
      ),
    );
  }
}
