import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shipper_app/Widgets/Input_text_filed.dart';
import 'package:shipper_app/constants/colors.dart';
import 'package:shipper_app/constants/spaces.dart';
import 'package:shipper_app/controller/shipperIdController.dart';
import 'package:shipper_app/functions/shipperApis/updateUserDetails.dart';
import 'package:shipper_app/responsive.dart';
import 'package:shipper_app/screens/add_user_screen.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  AccountScreenState createState() => AccountScreenState();
}

class AccountScreenState extends State<AccountScreen> {
  ShipperIdController shipperIdController = Get.put(ShipperIdController());
  GetStorage sidstorage = GetStorage('ShipperIDStorage');
  late TextEditingController shipperuniqueIdController;
  late TextEditingController nameController;
  late TextEditingController roleController;
  late TextEditingController emailController;
  late TextEditingController phoneNumberController;
  late TextEditingController companyNameController;

  bool isEditing = false;

  @override
  void initState() {
    super.initState();

    nameController =
        TextEditingController(text: shipperIdController.name.value);
    roleController = TextEditingController(
        text: shipperIdController.isOwner.value ? 'Owner' : 'Employee');
    emailController = TextEditingController(
        text: FirebaseAuth.instance.currentUser!.email.toString());

    phoneNumberController =
        TextEditingController(text: shipperIdController.mobileNum.value);
    companyNameController =
        TextEditingController(text: shipperIdController.companyName.value);
    shipperuniqueIdController =
        TextEditingController(text: shipperIdController.shipperId.value);
    setState(() {});
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
                : Row(
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
            SizedBox(height: space_2),
            Stack(
              children: [
                Container(
                  height: Responsive.isMobile(context) ? 200 : 150,
                  padding: EdgeInsets.zero,
                  margin: const EdgeInsets.only(top: 5, bottom: 5),
                  decoration: const BoxDecoration(
                    color:  white
                  ),
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
                            isEditing = !isEditing;

                            if (!isEditing) {
                              shipperIdController.name.value =
                                  nameController.text;

                              shipperIdController.companyName.value =
                                  companyNameController.text;
                            }
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isEditing ? white : darkBlueColor,
                          foregroundColor: isEditing ? darkBlueColor : white,
                          side: isEditing
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
                            color: isEditing ? Colors.black : Colors.white,
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
                        isEditing: isEditing,
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
                        isEditing: isEditing,
                        controller: companyNameController,
                      ),
                      SizedBox(height: space_2),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: InputTextField(
                              controller: nameController,
                              isEditing: isEditing,
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
                      ),
                      SizedBox(height: space_5),
                      Row(
                        children: [
                          Flexible(
                            child: InputTextField(
                              controller: emailController,
                              isEditing: false,
                              labelText: 'Email',
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: space_5),
                      Row(
                        children: [
                          Flexible(
                            child: InputTextField(
                              controller: phoneNumberController,
                              isEditing: false,
                              labelText: 'Phone Number',
                            ),
                          ),
                          SizedBox(width: space_5),
                          Flexible(
                            child: InputTextField(
                              controller: companyNameController,
                              isEditing: isEditing,
                              labelText: 'Company Name',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
            SizedBox(height: Responsive.isMobile(context) ? 10 : 30),
            if (isEditing)
              Row(
                children: [
                  SizedBox(
                    width: Responsive.isMobile(context) ? 100 : 750,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      // if (nameController.text.isNotEmpty &&
                      //     companyNameController.text.isNotEmpty) {
                      //   try {
                      //     await updateUserDetails(
                      //       uniqueID: shipperuniqueIdController.text,
                      //       name: nameController.text,
                      //       companyName: companyNameController.text,
                      //     );
                      //
                      //     shipperIdController.updateName(nameController.text);
                      //     shipperIdController
                      //         .updateCompanyName(companyNameController.text);
                      //     sidstorage.write("name", nameController.text);
                      //     sidstorage.write(
                      //         "companyName", companyNameController.text);
                      //     setState(() {
                      //       isEditing = false;
                      //     });
                      //   } catch (e) {
                      //     debugPrint('Error updating user details: $e');
                      //   }
                      // } else {
                      //   showMySnackBar(context, "Update Company and Name");
                      // }
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(100, 38),
                      backgroundColor: liveasyGreen,
                    ),
                    child: const Text(
                      'Save',
                      style: TextStyle(color: white),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isEditing = false;
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
                ],
              ),
          ],
        ),
      ),
    );
  }
}
