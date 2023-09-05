import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shipper_app/constants/fontSize.dart';
import 'package:shipper_app/responsive.dart';
import 'package:shipper_app/screens/accountScreens/label_text.dart';

import '../../Widgets/headingTextWidget.dart';
import '../../constants/colors.dart';
import '../../constants/spaces.dart';
import '../../controller/shipperIdController.dart';
import 'package:http/http.dart' as http;

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  AccountVerificationWebScreenState createState() =>
      AccountVerificationWebScreenState();
}

class AccountVerificationWebScreenState extends State<AccountScreen> {
  final _formKey = GlobalKey<FormState>();
  late ShipperIdController shipperIdController;
  late TextEditingController shipperuniqueIdController;
  late TextEditingController nameController;
  late TextEditingController roleController;
  late TextEditingController emailController;
  late TextEditingController phoneNumberController;
  late TextEditingController companyNameController;

  bool isEditing = false;
  bool changesMade = true;
  bool hasValidationError = false;

  @override
  void initState() {
    super.initState();
    shipperIdController = Get.find();
    nameController =
        TextEditingController(text: shipperIdController.name.value);
    roleController = TextEditingController(
        text: shipperIdController.isOwner.value ? 'Owner' : 'Employee');
    emailController =
        TextEditingController(text: shipperIdController.emailId.value);
    phoneNumberController =
        TextEditingController(text: shipperIdController.mobileNum.value);
    companyNameController =
        TextEditingController(text: shipperIdController.companyName.value);
    shipperuniqueIdController =
        TextEditingController(text: shipperIdController.shipperId.value);
  }

  @override
  void dispose() {
    nameController.dispose();
    roleController.dispose();
    emailController.dispose();
    phoneNumberController.dispose();
    companyNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Responsive.isMobile(context)
        ? Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: darkBlueColor,
              title: Row(
                children: [
                  // Liveasy Logo
                  Image.asset(
                    'assets/icons/liveasyicon.png',
                    width: 20,
                    height: 20,
                  ),
                  const SizedBox(width: 12),

                  // Liveasy Text
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
                // Drawer Icon
                IconButton(
                  onPressed: () {
                    // Open the drawer or implement your desired logic
                  },
                  icon: const Icon(
                    Icons.menu,
                  ),
                ),
              ],
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Center(
                    child: Text(
                      ' My Account Details ',
                      style: TextStyle(
                          color: darkBlueColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                  ),
                  // Linear Gradient Container
                  Stack(
                    // alignment: Alignment.topLeft,
                    children: [
                      Container(
                        height: 125,
                        padding: EdgeInsets.zero,
                        margin: const EdgeInsets.only(top: 5, bottom: 5),
                        decoration: const BoxDecoration(
                          // color: Colors.greenAccent,
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [Colors.white],
                          ),
                        ),
                      ),
                      Positioned(
                        top: 20,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          decoration: const BoxDecoration(
                            color: Color(0xFF152968),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(6),
                              bottomRight: Radius.circular(6),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 95,
                        padding: EdgeInsets.zero,
                        margin: const EdgeInsets.only(top: 5, bottom: 5),
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              Color(0xFFE6E4E4), // Starting color: #E6E4E4
                              Color(0xFFFFFFFF)
                              // Ending color: #F1F0F0
                            ],
                          ),
                        ),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: IconButton(
                            onPressed: () {
                              // Handle back arrow onPressed
                            },
                            icon: Image.asset(
                              "assets/icons/accountarrow.png",
                              width: 100,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 20,
                        top: 55,
                        child: Container(
                          width: 90,
                          height: 70,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white, width: 3.0),
                            shape: BoxShape.circle,
                            color:
                                const Color(0xFFAD8EE0), // Circle profile color
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

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            isEditing = !isEditing;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          primary: isEditing
                              ? Colors.white
                              : const Color(0xFF152968),
                          onPrimary: isEditing ? Colors.blue : Colors.white,
                          side: BorderSide(
                            color: isEditing
                                ? const Color(0xFF152968)
                                : Colors.transparent,
                            width: 2.0,
                          ),
                          minimumSize: const Size(80, 30),
                        ),
                        child: Text(
                          "Edit",
                          style: TextStyle(
                            fontSize: 15,
                            color: isEditing ? Colors.black : Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          // Your onPressed logic here
                        },
                        style: ElevatedButton.styleFrom(
                          primary: const Color(0xFF152968),
                          minimumSize: const Size(80, 30),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Send Invite',
                              style: TextStyle(fontSize: 15),
                            ),
                            Image(
                              width: 20,
                              image:
                                  AssetImage('assets/icons/telegramicon.png'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 18,
                  ),
                  // User Details as List Tiles
                  ListTile(
                    subtitle: Container(
                      height: isEditing ? 60 : 55,
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: LabelTextWidget(
                          isEditing: isEditing,
                          labelText: 'Name',
                          controller: nameController,
                        ),
                      ),
                    ),
                  ),
                  ListTile(
                    subtitle: Container(
                      height: isEditing ? 60 : 55,
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: LabelTextWidget(
                          controller: roleController,
                          isEditing: false,
                          labelText: 'Role',
                        ),
                      ),
                    ),
                  ),
                  ListTile(
                    subtitle: Container(
                      height: isEditing ? 60 : 55,
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: LabelTextWidget(
                          controller: emailController,
                          isEditing: false,
                          labelText: 'Email',
                        ),
                      ),
                    ),
                  ),
                  ListTile(
                    subtitle: Container(
                      height: isEditing ? 60 : 55,
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: LabelTextWidget(
                                controller: phoneNumberController,
                                isEditing: false,
                                labelText: 'Phone Number',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  ListTile(
                    subtitle: Container(
                      height: isEditing ? 60 : 55,
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: LabelTextWidget(
                          controller: companyNameController,
                          labelText: 'Company Name',
                          isEditing: isEditing,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Save and Cancel Buttons
                  if (isEditing)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              isEditing = false;
                            });
                            // Save logic here
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(100, 40),
                            primary: const Color(0xFF09B778),
                          ),
                          child: const Text(
                            'Save',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              isEditing = false;
                            });
                            // Reset form logic here
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(100, 40),
                            primary: Colors.red,
                          ),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          )
        : Scaffold(
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        HeadingTextWidget("My Account Details"),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.circle,
                          color: Color(0xFF09B778),
                          size: 10,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          'online'.tr,
                          style: const TextStyle(
                            fontSize: 18,
                            color: Color(0xFF09B778),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Stack(
                      // alignment: Alignment.topLeft,
                      children: [
                        Container(
                          height: 150,
                          padding: EdgeInsets.zero,
                          margin: const EdgeInsets.only(top: 5, bottom: 5),
                          decoration: const BoxDecoration(
                            // color: Colors.greenAccent,
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [white],
                            ),
                          ),
                        ),
                        Positioned(
                          top: 112,
                          right: 65,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    // Toggle the editing state
                                    isEditing = !isEditing;
                                    changesMade = false;
                                    if (!isEditing) {
                                      // Save the edited values to the controller when editing is done
                                      shipperIdController.name.value =
                                          nameController.text;
                                      // shipperIdController.isOwner.value =
                                      //     roleController.text == 'true';
                                      shipperIdController.emailId.value =
                                          emailController.text;
                                      shipperIdController.mobileNum.value =
                                          phoneNumberController.text;
                                      shipperIdController.companyName.value =
                                          companyNameController.text;
                                      // Add logic to save the edited values to the backend/database
                                    }
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: isEditing
                                      ? Colors.white
                                      : const Color(0xFF152968),
                                  onPrimary:
                                      isEditing ? Colors.blue : Colors.white,
                                  side: isEditing
                                      ? const BorderSide(
                                          color: Color(0xFF152968), width: 2.0)
                                      : BorderSide.none,
                                  minimumSize: const Size(100, 40),
                                ),
                                child: Text(
                                  "Edit",
                                  style: TextStyle(
                                    color:
                                        isEditing ? Colors.black : Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 20),
                              ElevatedButton(
                                onPressed: () {
                                  // Your onPressed logic here
                                },
                                style: ElevatedButton.styleFrom(
                                  minimumSize: const Size(70, 38),
                                  primary: const Color(
                                      0xFF152968), // Background color for "Send Invite" button
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Send Invite',
                                      style: GoogleFonts.montserrat(
                                          fontSize: size_8),
                                    ),
                                    const Image(
                                      image: AssetImage(
                                          'assets/icons/telegramicon.png'),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        Positioned(
                          top: 50,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            decoration: const BoxDecoration(
                              color: Color(0xFF152968),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(6),
                                bottomRight: Radius.circular(6),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: 100,
                          padding: EdgeInsets.zero,
                          margin: const EdgeInsets.only(top: 5, bottom: 5),
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                Color(0xFFE6E4E4), // Starting color: #E6E4E4
                                Color(0xFFFFFFFF)
                                // Ending color: #F1F0F0
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          left: 35,
                          top: 55,
                          child: Container(
                            width: 105,
                            height: 90,
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.white, width: 4.0),
                              shape: BoxShape.circle,
                              color: const Color(
                                  0xFFAD8EE0), // Circle profile color
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
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Flexible(
                          child: ListTile(
                            subtitle: Container(
                              height: isEditing ? 60 : 55,
                              padding: const EdgeInsets.all(8.0),
                              child: Align(
                                child: LabelTextWidget(
                                  controller: nameController,
                                  isEditing: isEditing,
                                  labelText: 'Name',
                                  // editMode: isEditing,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Flexible(
                          child: ListTile(
                            subtitle: Container(
                              height: isEditing ? 60 : 55,
                              padding: const EdgeInsets.all(8.0),
                              child: LabelTextWidget(
                                controller: roleController,
                                isEditing: false,
                                // editMode: isEditing,
                                labelText: 'Role',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: space_5),
                    ListTile(
                      subtitle: Container(
                        height: isEditing ? 60 : 55,
                        padding: const EdgeInsets.all(8.0),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: LabelTextWidget(
                            controller: emailController,
                            isEditing: false,
                            // editMode: isEditing,
                            labelText: 'Email',
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: space_5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Flexible(
                          child: ListTile(
                            subtitle: Container(
                              height: isEditing ? 60 : 55,
                              padding: const EdgeInsets.all(8.0),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: LabelTextWidget(
                                  controller: phoneNumberController,
                                  isEditing: false,
                                  labelText: 'Phone Numebr',
                                ),
                              ),
                            ),
                          ),
                        ),
                        Flexible(
                          child: ListTile(
                            subtitle: Container(
                              height: isEditing ? 60 : 55,
                              padding: const EdgeInsets.all(8.0),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: LabelTextWidget(
                                  controller: companyNameController,
                                  isEditing: isEditing,
                                  labelText: 'Company Name',
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    if (isEditing)
                      Row(
                        children: [
                          const SizedBox(
                            width: 750,
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              setState(() {
                                isEditing = false;
                              });
                              hasValidationError = false;
                              if (true) {
                                _formKey.currentState
                                    ?.save(); // Save form fields

                                if (nameController.text.isEmpty ||
                                    companyNameController.text.isEmpty) {
                                  setState(() {
                                    hasValidationError =
                                        true; // Set validation error
                                  });
                                  return; // Exit the function
                                }
                                try {
                                  await updateUserDetails(
                                    uniqueID: shipperuniqueIdController.text,
                                    name: nameController.text,
                                    companyName: companyNameController.text,
                                  );

                                  // Update the controller values

                                  shipperIdController
                                      .updateName(nameController.text);
                                  shipperIdController.updateCompanyName(
                                      companyNameController.text);
                                  shipperIdController
                                      .updateEmailId(emailController.text);
                                  shipperIdController.updateMobileNum(
                                      phoneNumberController.text);
                                } catch (e) {
                                  print('Error updating user details: $e');
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(100, 38),
                              primary: const Color(0xFF09B778),
                            ),
                            child: const Text(
                              'Save',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                isEditing = false;

                                nameController.text =
                                    shipperIdController.name.value;
                                companyNameController.text =
                                    shipperIdController.companyName.value;
                                emailController.text =
                                    shipperIdController.emailId.value;
                                phoneNumberController.text =
                                    shipperIdController.mobileNum.value;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              primary:
                                  Colors.white, // Set white background color
                              onPrimary: Colors.red, // Set red text color
                              side: const BorderSide(
                                  color: Colors.red,
                                  width: 2.0), // Set red side border
                            ),
                            child: const Text(
                              'Cancel',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          );
  }
}

Future<void> updateUserDetails({
  // required String token,
  required String uniqueID,
  required String name,
  required String companyName,
}) async {
  final String shipperApiUrl = dotenv.get('shipperApiUrl');
  final url = Uri.parse('$shipperApiUrl/$uniqueID');

  final body = {
    'shipperName': name,
    'companyName': companyName,
  };

  final headers = {
    'Content-Type': 'application/json',
  };

  final response =
      await http.put(url, headers: headers, body: jsonEncode(body));

  if (response.statusCode == 200) {
    print('User details updated successfully');
  } else {
    print('Failed to update user details');
  }
}
