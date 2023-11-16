import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shipper_app/Widgets/custom_text_field.dart';
import 'package:shipper_app/constants/colors.dart';
import 'package:shipper_app/functions/shipperApis/updateShipperTransporterList.dart';
import 'package:shipper_app/functions/transporterApis/getTransporterIdByPhone.dart';

Widget addTransporters(diaLogContext, transporterList) {
  TextEditingController txtEdtNameController = TextEditingController(),
      txtEdtPhoneNoController = TextEditingController(),
      txtEdtEmailController = TextEditingController();

  return Container(
    margin: const EdgeInsets.all(10.0),
    child: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Transporter Details',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF152968),
                      fontSize: 16,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.of(diaLogContext).pop();
                    },
                    icon: const Icon(Icons.close),
                  )
                ],
              ),
              const SizedBox(height: 12),
              const Divider(),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 2,
                    child: CustomTextField(
                      controller: txtEdtNameController,
                      hintText: "Enter Transporter Name",
                      labelText: "Transporter Name",
                    ),
                  ),
                  const SizedBox(width: 20),
                  Flexible(
                    flex: 2,
                    child: CustomTextField(
                      controller: txtEdtPhoneNoController,
                      hintText: "Enter Contact Number",
                      labelText: "Contact Number",
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 2,
                    child: CustomTextField(
                      controller: txtEdtEmailController,
                      hintText: "Enter Email id",
                      labelText: "Email id",
                      validator: (value) {
                        if (value == null) {
                          return 'Please enter an email address';
                        } else if (!_isValidEmail(value)) {
                          return 'Invalid email format';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 20),
                  Flexible(
                    flex: 2,
                    child: CustomTextField(
                      hintText: "Enter Pan Number",
                      labelText: "Pan Number",
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 2,
                    child: CustomTextField(
                      hintText: "Enter GST Number",
                      labelText: "GST Number",
                    ),
                  ),
                  const SizedBox(width: 20),
                  Flexible(
                    flex: 2,
                    child: CustomTextField(
                      hintText: "Enter Vendor Code",
                      labelText: "Vendor Code ",
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  String name = txtEdtNameController.text;
                  String phone = txtEdtPhoneNoController.text;
                  String email = txtEdtEmailController.text;

                  if (name.isNotEmpty && phone.isNotEmpty && email.isNotEmpty) {
                    getTransporterIdByPhone(phone).then((value) {
                      List newAddedTransporter = [
                        email,
                        name,
                        phone,
                        value.toString()
                      ];
                      transporterList.add(newAddedTransporter);
                      updateShipperTransporterList(
                          transporterList, diaLogContext);
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(40, 50),
                  alignment: Alignment.center,
                  primary: Colors.green,
                  onPrimary: Colors.white,
                ),
                child: const Text('Add Transporter'),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

bool _isValidEmail(String email) {
  final emailRegex = RegExp(r'^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$');
  return emailRegex.hasMatch(email);
}
